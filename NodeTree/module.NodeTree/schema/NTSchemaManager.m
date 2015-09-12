//
//  NDSchemaManager.m
//  prototype
//
//  Created by rlong on 5/12/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//


#import "JBLog.h"
#import "JBMemoryModel.h"

#import "NTSchemaManager.h"
#import "NTSqliteConnection.h"
#import "NTSqliteUtilities.h"
#import "NTSqliteStatement.h"
#import "NTTableDescriptor.h"
#import "NTTableProperty.h"


@implementation NTSchemaManager



+(void)addIndexes:(NTSqliteConnection*)connection tableDescriptor:(NTTableDescriptor*)tableDescriptor {
    
    NSArray* indexes = [tableDescriptor indexes];
    
    for( NSString* createIndex in indexes ) {
        Log_debugString( createIndex );
        [connection exec:createIndex];
    }
    
}

+(void)buildTables:(NTSqliteConnection*)connection tables:(__strong NTTableDescriptor*[])tables {
    
    for( int i = 0; NULL != tables[i]; i++ ) {
        
        NTTableDescriptor* tableDescriptor = tables[i];
  
        NSString* createTable = [self createTableDdl:tableDescriptor];
        Log_debugString( createTable );
        
        [connection exec:createTable];
        
    }

    for( int i = 0; NULL != tables[i]; i++ ) {
        
        NTTableDescriptor* tableDescriptor = tables[i];
        [self addIndexes:connection tableDescriptor:tableDescriptor];
    }
}



//////////////////////////////////////////////////////////////////////////

+(NSString*)createTableDdl:(NTTableDescriptor*)tableDescriptor {
    
    
    NSMutableString* answer = [[NSMutableString alloc] initWithString:@"create table if not exists "];
    JBAutorelease( answer );
    [answer appendString:[tableDescriptor name]];
    [answer appendString:@"(\n"];
    
    // properties ...
    {

        NSArray* properties = [tableDescriptor properties];
        
        BOOL firstProperty = true;
        
        for( NTTableProperty* tableProperty in properties ) {
            
            if( firstProperty ) {
                firstProperty = false;
                [answer appendString:@"\t"];
            } else {
                [answer appendString:@",\n\t"];
            }
            
            [answer appendString:[tableProperty toString]];
        }

    }
    
    // constraints
    {
        NSArray* constraints = [tableDescriptor constraints];
        for( NSString* constraint in constraints ) {
            
            [answer appendString:@",\n\t"];
            [answer appendString:constraint];
        }
    }
    
    [answer appendString:@"\n);"];
    
    return answer;
}



+(NSString*)dropTableDdl:(NTTableDescriptor*)tableDescriptor {
    

    NSMutableString* answer = [[NSMutableString alloc] initWithString:@"drop table if exists "];
    JBAutorelease( answer );
    [answer appendString:[tableDescriptor name]];
    [answer appendString:@";"];
    
    return answer;
    
}


+(void)dropTables:(NTSqliteConnection*)connection tables:(__strong NTTableDescriptor*[])tables {
    

    for( int i = 0; NULL != tables[i]; i++ ) {
        
        NTTableDescriptor* tableDescriptor = tables[i];
        NSString* dropStatement = [self dropTableDdl:tableDescriptor];
        Log_debugString( dropStatement );
        
        [connection exec:dropStatement];

        
    }
    
}


@end
