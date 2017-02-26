//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CASqliteConnection.h"
#import "CASqliteStatement.h"

#import "NTIntegerEncoder.h"
#import "NTNode.h"
#import "NTNodeContext.h"



@implementation NTNodeContext {
    
    
    CASqliteConnection* _sqliteConnection;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSqliteConnection:(CASqliteConnection*)sqliteConnection {
    
    NTNodeContext* answer = [super init];
    
    if( nil != answer ) {
        
        _sqliteConnection = sqliteConnection;
        
    }
    
    return answer;
    
}



-(NTNode*)addRootWithKey:(NSString*)key {
    
    NSString* sql = @"insert into node (edge_name, edge_index) values(?,null)";
    
    CASqliteStatement* sqliteStatement = [_sqliteConnection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        [sqliteStatement step];
        
        long long rowId = [_sqliteConnection last_insert_rowid];
        
        NSString* path = [NTIntegerEncoder base64EncodeLongLong:rowId];
        Log_debugString( path );
        
        NTNode* answer = [[NTNode alloc] initWithContext:self pk:@(rowId) parentPk:nil parentPkPath:nil];
        return answer;
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}


-(void)begin {
    
    [_sqliteConnection begin];
}


-(void)close {
    
    [_sqliteConnection close];
    
}

-(void)commit {

    [_sqliteConnection commit];

}

// can return nil */
-(NTNode*)getRootWithKey:(NSString*)key {
    
    return [self getRootWithKey:key createIfNeeded:false];
}

// can return nil if 'createIfNeeded' is false */
-(NTNode*)getRootWithKey:(NSString*)key createIfNeeded:(bool)createIfNeeded {
    
    NSString* sql = @"select pk from node where edge_name = ? and parent_pk is NULL";
    
    CASqliteStatement* sqliteStatement = [_sqliteConnection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            long long pk = [sqliteStatement getInt64AtColumn:0];
            NSString* path = [NTIntegerEncoder base64EncodeLongLong:pk];
            Log_debugString( path );
            
            NTNode* answer = [[NTNode alloc] initWithContext:self pk:@(pk) parentPk:nil parentPkPath:nil];
            
            return answer;
            
        } else if( SQLITE_DONE == resultCode ) {
            
            if( createIfNeeded ) {
                return [self addRootWithKey:key];
            } else {
                return nil;
            }
        }
        
    }
    @finally {
        [sqliteStatement finalize];
    }
}





@end
