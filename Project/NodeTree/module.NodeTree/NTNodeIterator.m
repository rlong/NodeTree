//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CASqliteConnection.h"
#import "CASqliteStatement.h"

#import "NTNode.h"
#import "NTNodeContext.h"
#import "NTNodeIterator.h"

@implementation NTNodeIterator {
    
    NTNodeContext* _context;
    CASqliteStatement* _sqliteStatement;
    BOOL _sqliteDone;
}



- (instancetype)initWithContext:(NTNodeContext*)context;
{
    
    self = [super init];

    if( nil != self ) {
        
        _context = context;
        
        CASqliteConnection* sqliteConnection = [context sqliteConnection];
        
        NSString* sql = @"select NodeId, ParentId, ParentPath, EdgeName, EdgeIndex, Tag from node";
        
        _sqliteStatement = [sqliteConnection prepare:sql];
        _sqliteDone = false;
        
    }
    
    return self;
    
}


- (instancetype)initWithContext:(NTNodeContext*)context sqliteStatement:(CASqliteStatement*)sqliteStatement;
{
    
    self = [super init];
    
    if( nil != self ) {
        
        _context = context;
        _sqliteStatement = sqliteStatement;
        _sqliteDone = false;
        
    }
    
    return self;
    
}



- (void)dealloc {
    
    [self finalize];
    
}



+ (NTNodeIterator*)childrenOf:(NTNode*)node;
{
    Log_debugString( [node pkPath] );
    
    NTNodeContext* context = [node context];
    
    
    CASqliteConnection* sqliteConnection = [context sqliteConnection];
    
    NSString* sql = @"select NodeId, ParentId, ParentPath, EdgeName, EdgeIndex, Tag from node where ParentPath like ? order by ParentPath"; // 'B.%'
    
    CASqliteStatement* sqliteStatement = [sqliteConnection prepare:sql];
    NSString* like = [[node pkPath] stringByAppendingString:@"%"];
    Log_debugString(like);
    [sqliteStatement bindText:like atIndex:1];
    
    return [[NTNodeIterator alloc] initWithContext:context sqliteStatement:sqliteStatement];
}

+ (NTNodeIterator*)immediateChildrenOf:(NTNode*)node;
{
    Log_debugString( [node pkPath] );
    
    NTNodeContext* context = [node context];
    
    
    CASqliteConnection* sqliteConnection = [context sqliteConnection];
    
    NSString* sql = @"select NodeId, ParentId, ParentPath, EdgeName, EdgeIndex, Tag from node where ParentId = ?";
    
    CASqliteStatement* sqliteStatement = [sqliteConnection prepare:sql];
    [sqliteStatement bindInt64:[node.pk longLongValue] atIndex:1];
    
    return [[NTNodeIterator alloc] initWithContext:context sqliteStatement:sqliteStatement];
}



- (NTNode*)next {
    
    
    if( _sqliteDone ) {
        return nil;
    }
    
    int resultCode = [_sqliteStatement step];
    if( SQLITE_ROW == resultCode ) {
        
        NSNumber* pk = [_sqliteStatement getNumberAtColumn:0 defaultTo:nil];
        NSNumber* ParentId = [_sqliteStatement getNumberAtColumn:1 defaultTo:nil];
        NSString* ParentPath = [_sqliteStatement getStringAtColumn:2 defaultTo:nil];
        NSString* EdgeName = [_sqliteStatement getStringAtColumn:3 defaultTo:nil];
        NSNumber* EdgeIndex = [_sqliteStatement getNumberAtColumn:4 defaultTo:nil];
        NSNumber* Tag = [_sqliteStatement getNumberAtColumn:5 defaultTo:nil];
        
        NTNode* answer = [[NTNode alloc] initWithContext:_context pk:pk parentPk:ParentId parentPkPath:ParentPath];
        [answer setEdgeName:EdgeName];
        [answer setEdgeIndex:EdgeIndex];
        [answer setTypeId:Tag];
        
        Log_debugString( answer.edgeName );
        
        return answer;
        
    } else if( SQLITE_DONE == resultCode ) {
        
        [self finalize];
        return nil;
    }
    
    
    Log_error(@"unexpected code path");
    return nil;
    
    
}


- (void)finalize;
{
    
    if( nil != _sqliteStatement ) {
        
        [_sqliteStatement finalize];
        _sqliteDone = true;
        _sqliteStatement = nil;
        
    }
}


@end
