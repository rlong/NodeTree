
//
//  XPSqliteNodeContext.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "JBLog.h"
#import "JBMemoryModel.h"

#import "NTIntegerEncoder.h"
#import "NTNode.h"
#import "NTNodeContext.h"
#import "NTSqliteConnection.h"
#import "NTSqliteStatement.h"






@implementation NTNodeContext {
    
    
    NTSqliteConnection* _sqliteConnection;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSqliteConnection:(NTSqliteConnection*)sqliteConnection {
    
    NTNodeContext* answer = [super init];
    
    if( nil != answer ) {
        
        _sqliteConnection = sqliteConnection;
        
    }
    
    return answer;
    
}



-(NTNode*)addRootWithKey:(NSString*)key {
    
    
    
    NSString* sql = @"insert into node (edge_name, edge_index) values(?,null)";
    
    NTSqliteStatement* sqliteStatement = [_sqliteConnection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        [sqliteStatement step];
        
        long long rowId = [_sqliteConnection last_insert_rowid];
        
        NSString* path = [NTIntegerEncoder base64Encode:rowId];
        Log_debugString( path );
        
        NTNode* answer = [[NTNode alloc] initWithContext:self pk:rowId parentPkPath:path];
        JBAutorelease( answer );
        
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
    
    NSString* sql = @"select pk from node where edge_name = ? and root_pk is NULL";
    
    NTSqliteStatement* sqliteStatement = [_sqliteConnection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            long long pk = [sqliteStatement getInt64AtColumn:0];
            NSString* path = [NTIntegerEncoder base64Encode:pk];
            Log_debugString( path );
            
            NTNode* answer = [[NTNode alloc] initWithContext:self pk:pk parentPkPath:path];
            JBAutorelease( answer );
            
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
