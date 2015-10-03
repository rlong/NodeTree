//
//  NDSchemaManager.h
//  prototype
//
//  Created by rlong on 5/12/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@class NTSqliteConnection;
@class NTTableDescriptor;

@interface NTSchemaManager : NSObject

+(void)buildTables:(NTSqliteConnection*)connection tables:(__strong NTTableDescriptor*[])tables;
+(void)dropTables:(NTSqliteConnection*)connection tables:(__strong NTTableDescriptor*[])tables;

@end
