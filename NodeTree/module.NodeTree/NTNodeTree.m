//
//  NDNodeDatabase.m
//  prototype
//
//  Created by rlong on 27/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//


#import "JBBaseException.h"
#import "JBFileUtilities.h"
#import "JBLog.h"
#import "JBMemoryModel.h"



#import "NTIntegerEncoder.h"
#import "NTNodeTreeSchema.h"
#import "NTSqliteConnection.h"
#import "NTSqliteStatement.h"
#import "NTNodeContext.h"
#import "NTNode.h"
#import "NTNodeTree.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface NTNodeTree ()

// databasePath
//NSString* _databasePath;
@property (nonatomic, retain) NSString* databasePath;
//@synthesize databasePath = _databasePath;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation NTNodeTree



#pragma mark - 
#pragma mark <XPNodeDatabase> implementation


-(NTNode*)addRootToContext:(NTNodeContext*)context withKey:(NSString*)key {
    
    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    
    NTSqliteConnection* connection = [sqlLiteNodeContext sqliteConnection];
    
    NSString* sql = @"insert into node (edge_name, edge_index) values(?,0)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];

    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        [sqliteStatement step];
        
        long long rowId = [connection last_insert_rowid];
        
        NSString* path = [NTIntegerEncoder base64Encode:rowId];
        Log_debugString( path );
        
        NTNode* answer = [[NTNode alloc] initWithContext:context pk:rowId parentPkPath:path];
        JBAutorelease( answer );
        
        return answer;
    
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}


// can return nil */
-(NTNode*)getRootFromContext:(NTNodeContext*)context withKey:(NSString*)key {
    
    return [self getRootFromContext:context withKey:key createIfNeeded:false];
}


// can return nil if 'createIfNeeded' is false */
-(NTNode*)getRootFromContext:(NTNodeContext*)context withKey:(NSString*)key createIfNeeded:(bool)createIfNeeded {
    
    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    
    NTSqliteConnection* connection = [sqlLiteNodeContext sqliteConnection];
    NSString* sql = @"select pk from node where edge_name = ? and root_pk is NULL";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];

        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            long long pk = [sqliteStatement getInt64AtColumn:0];
            NSString* path = [NTIntegerEncoder base64Encode:pk];
            Log_debugString( path );
            
            NTNode* answer = [[NTNode alloc] initWithContext:context pk:pk parentPkPath:path];
            JBAutorelease( answer );
            
            return answer;
            
        } else if( SQLITE_DONE == resultCode ) {
            
            if( createIfNeeded ) {
                return [self addRootToContext:context withKey:key];
            } else {
                return nil;
            }
        }
        
    }
    @finally {
        [sqliteStatement finalize];
    }

    
    
}


-(void)begin:(NTNodeContext*)context {

    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    [sqlLiteNodeContext begin];

}

-(void)commit:(NTNodeContext*)context {

    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    [sqlLiteNodeContext commit];

}

-(NTNodeContext*)openContext {

    // database does not exists ...
    if( ! [JBFileUtilities fileExistsAtPath:_databasePath] ) {
        
        [NTNodeTreeSchema buildSchema:_databasePath];
    }

    NTSqliteConnection* connection = [NTSqliteConnection open:_databasePath];
    NTNodeContext* answer = [[NTNodeContext alloc] initWithSqliteConnection:connection];
    JBAutorelease( answer );
    
    return answer;
    
}

-(void)closeContext:(NTNodeContext*)context {
    
    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    [sqlLiteNodeContext close];
    
}

#pragma mark -


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithDatabasePath:(NSString*)databasePath {
    
   
    NTNodeTree* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setDatabasePath:databasePath];
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setDatabasePath:nil];
	
    JBSuperDealloc();
	
}


#pragma mark -
#pragma mark fields

// databasePath
//NSString* _databasePath;
//@property (nonatomic, retain) NSString* databasePath;
@synthesize databasePath = _databasePath;


@end

