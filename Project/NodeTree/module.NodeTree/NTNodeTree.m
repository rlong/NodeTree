//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CAFileUtilities.h"
#import "CALog.h"
#import "CASqliteConnection.h"
#import "CASqliteStatement.h"




#import "NTIntegerEncoder.h"
#import "NTNodeTreeSchema.h"
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

#pragma mark - instance lifecycle


-(id)initWithDatabasePath:(NSString*)databasePath {
    
    
    NTNodeTree* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setDatabasePath:databasePath];
        
    }
    
    return answer;
    
}

-(void)dealloc {
    
    [self setDatabasePath:nil];
    
    
}


#pragma mark - 


+ (NSString*)databaseVersion;
{
    return @"1.0";
}

-(NTNode*)addRootToContext:(NTNodeContext*)context withKey:(NSString*)key {
    
    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    
    CASqliteConnection* connection = [sqlLiteNodeContext sqliteConnection];
    
    NSString* sql = @"insert into node (edge_name, edge_index) values(?,0)";
    
    CASqliteStatement* sqliteStatement = [connection prepare:sql];

    @try {
        [sqliteStatement bindText:key atIndex:1];
        
        [sqliteStatement step];
        
        long long rowId = [connection last_insert_rowid];
        
        NSString* path = [NTIntegerEncoder base64EncodeLongLong:rowId];
        Log_debugString( path );
        
        NTNode* answer = [[NTNode alloc] initWithContext:context pk:@(rowId) parentPk:nil parentPkPath:nil];
        
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
    
    CASqliteConnection* connection = [sqlLiteNodeContext sqliteConnection];
    NSString* sql = @"select pk from node where edge_name = ? and root_pk is NULL";
    
    CASqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        [sqliteStatement bindText:key atIndex:1];

        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            NSNumber* pk = [sqliteStatement getNumberAtColumn:0 defaultTo:nil];
            
            NTNode* answer = [[NTNode alloc] initWithContext:context pk:pk parentPk:nil parentPkPath:nil];
            
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
    if( ! [CAFileUtilities fileExistsAtPath:_databasePath] ) {
        
        [NTNodeTreeSchema buildSchema:_databasePath];
    }

    CASqliteConnection* connection = [CASqliteConnection open:_databasePath];
    NTNodeContext* answer = [[NTNodeContext alloc] initWithSqliteConnection:connection];
    
    return answer;
    
}

-(void)closeContext:(NTNodeContext*)context {
    
    NTNodeContext* sqlLiteNodeContext = (NTNodeContext*)context;
    [sqlLiteNodeContext close];
    
}

#pragma mark -





#pragma mark -
#pragma mark fields

// databasePath
//NSString* _databasePath;
//@property (nonatomic, retain) NSString* databasePath;
@synthesize databasePath = _databasePath;


@end

