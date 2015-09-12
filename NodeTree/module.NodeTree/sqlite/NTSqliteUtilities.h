//
//  NDSqliteHelper.h
//  prototype
//
//  Created by rlong on 5/12/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NTSqliteUtilities : NSObject

//+(void)checkResultCodeIsOk:(int)resultCode;
+(void)checkResultCodeIsOk:(int)resultCode forConnection:(sqlite3*)connection;
+(void)checkResultCodeIsOk:(int)resultCode forStatement:(sqlite3_stmt*)statement;

@end
