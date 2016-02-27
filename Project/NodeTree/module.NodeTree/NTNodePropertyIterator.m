//
//  NTNodePropertyIterator.m
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import "CALog.h"
#import "CASqliteConnection.h"
#import "CASqliteStatement.h"


#import "NTNode.h"
#import "NTNodeContext.h"
#import "NTNodePropertyIterator.h"
#import "NTNodeProperty.h"

@implementation NTNodePropertyIterator {
    
    NTNodeContext* _context;
    NTNode* _node;
    CASqliteStatement* _sqliteStatement;
    BOOL _sqliteDone;

}


- (instancetype)initWithContext:(NTNodeContext*)context node:(NTNode*)node  sqliteStatement:(CASqliteStatement*)sqliteStatement;
{
    
    self = [super init];
    
    if( nil != self ) {
        
        _context = context;
        _node = node;
        _sqliteStatement = sqliteStatement;
        _sqliteDone = false;
        
    }
    
    return self;
    
}

- (void)dealloc {
    
    if( !_sqliteDone &&  nil != _sqliteStatement ) {
        
        [_sqliteStatement finalize];
        
    }
}


+ (NTNodePropertyIterator*)propertiesOf:(NTNode*)node;
{
//    Log_debugString( [node pkPath] );
    
    NTNodeContext* context = [node context];
    
    
    CASqliteConnection* sqliteConnection = [context sqliteConnection];
    
    NSString* sql = @"select edge_name, edge_index, boolean_value, integer_value, real_value, string_value from node_property where node_pk = ?"; // 'B.%'
    
    CASqliteStatement* sqliteStatement = [sqliteConnection prepare:sql];
    [sqliteStatement bindInt64:[[node pk] longLongValue] atIndex:1];
    
    return [[NTNodePropertyIterator alloc] initWithContext:context node:node sqliteStatement:sqliteStatement];
}



- (NTNodeProperty*)next;
{
    
    if( _sqliteDone ) {
        return nil;
    }
    
    int resultCode = [_sqliteStatement step];
    if( SQLITE_ROW == resultCode ) {

        NTNodeProperty* answer = [[NTNodeProperty alloc] init];
        answer.nodePk = [_node pk];
        answer.edgeName = [_sqliteStatement getStringAtColumn:0 defaultTo:nil];
        answer.edgeIndex = [_sqliteStatement getNumberAtColumn:1 defaultTo:nil];
        answer.booleanValue = [_sqliteStatement getNumberAtColumn:2 defaultTo:nil];
        answer.integerValue = [_sqliteStatement getNumberAtColumn:3 defaultTo:nil];
        answer.realValue = [_sqliteStatement getNumberAtColumn:4 defaultTo:nil];
        answer.stringValue = [_sqliteStatement getStringAtColumn:5 defaultTo:nil];
        
        return answer;
        
    } else if( SQLITE_DONE == resultCode ) {
        
        [_sqliteStatement finalize];
        _sqliteDone = true;
        _sqliteStatement = nil;
        return nil;
    }
    
    
    Log_error(@"unexpected code path");
    return nil;
    

    return nil;
}

@end
