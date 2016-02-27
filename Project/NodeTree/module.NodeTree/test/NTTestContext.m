//
//  XPTestConfiguration.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "NTNodeTreeSchema.h"

#import "NTNodeTree.h"
#import "NTNodeTreeSchema.h"
#import "NTTestContext.h"

@implementation NTTestContext {
    
    NTNodeTree* _nodeDb;
}



static NTTestContext* _defaultContext;

+ (void)initialize {
    
    _defaultContext = [[NTTestContext alloc] init];
}


- (instancetype)init {
    
    self = [super init];
    
    
    if( self ) {
     
        NSString* databasePath = [NTTestContext DATABASE_PATH];
        
        [NTNodeTreeSchema buildSchema:databasePath];
        
        _nodeDb = [[NTNodeTree alloc] initWithDatabasePath:databasePath];


    }
    
    
    return self;
}

+ (NTTestContext*)defaultContext {
    
    return _defaultContext;
    
}


- (void)closeContext:(NTNodeContext*)context;
{
    
    [_nodeDb closeContext:context];
    
}


- (NTNodeContext*)openContext;
{
    
    return [_nodeDb openContext];

    
}



- (void)teardownDatabase;
{
    
    NSString* databasePath = [NTTestContext DATABASE_PATH];
    [NTNodeTreeSchema dropSchema:databasePath];

    
}

+(NSString*)DATABASE_PATH {
    
    return @"/tmp/NTTestContext.db";
    
}

@end
