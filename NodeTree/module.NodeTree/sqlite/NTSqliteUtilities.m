//
//  NDSqliteHelper.m
//  prototype
//
//  Created by rlong on 5/12/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//


#import "JBBaseException.h"
#import "JBLog.h"
#import "JBMemoryModel.h"


#import "NTSqliteUtilities.h"

@implementation NTSqliteUtilities



+(void)checkResultCodeIsOk:(int)resultCode forConnection:(sqlite3*)connection {
    
    // vvv http://www.sqlite.org/c3ref/c_abort.html
    
    if( SQLITE_OK != resultCode ) {
        
        const char* errmsg = sqlite3_errmsg(connection);
        
        NSString* technicalError;
        if( nil == errmsg ) {
            technicalError = [NSString stringWithFormat:@"SQLITE_OK != resultCode; resultCode = %d; errmsg = nil",resultCode];
        } else {
            technicalError = [NSString stringWithFormat:@"SQLITE_OK != resultCode; resultCode = %d; errmsg = '%s'",resultCode, errmsg];
        }
        BaseException* e = [[JBBaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
        
        @throw e;
        
    }
    
    // ^^^ http://www.sqlite.org/c3ref/c_abort.html
    
}

+(void)checkResultCodeIsOk:(int)resultCode forStatement:(sqlite3_stmt*)statement {
    
    if( SQLITE_OK == resultCode ) {
        return;
    }
    
    // vvv [c++ - Retrieve sqlite3* from sqlite3_stmt* - Stack Overflow](http://stackoverflow.com/questions/18480516/retrieve-sqlite3-from-sqlite3-stmt)
    
    sqlite3*  connection = sqlite3_db_handle(statement);
    
    // ^^^ [c++ - Retrieve sqlite3* from sqlite3_stmt* - Stack Overflow](http://stackoverflow.com/questions/18480516/retrieve-sqlite3-from-sqlite3-stmt)
    

    [self checkResultCodeIsOk:resultCode forConnection:connection];
}



@end
