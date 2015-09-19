//
//  XPSqlLiteStatement.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "FALog.h"

#import "JBBaseException.h"


#import "NTSqliteStatement.h"
#import "NTSqliteUtilities.h"

@implementation NTSqliteStatement


-(void)bindDouble:(double)value atIndex:(int)index {
    

    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_double( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];

    
}


-(void)bindInt:(int)value atIndex:(int)index {
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_int( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
    
}


-(void)bindInt64:(sqlite3_int64)value atIndex:(int)index {
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_int64( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
    
}


-(void)bindText:(NSString*)value atIndex:(int)index {
    
    const char* utf8Text = NULL;

    if( nil != value ) {
        utf8Text = [value UTF8String];
    }
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_text( _statement, index, utf8Text, -1, SQLITE_TRANSIENT);
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html

    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];

    
}


-(long long)getInt64AtColumn:(int)columnIndex {
    
    

    return sqlite3_column_int64( _statement, columnIndex);
    
}

-(NSString*)getTextAtColumn:(int)columnIndex {

    const char* text = (const char*)sqlite3_column_text( _statement, columnIndex);
    
    return [NSString stringWithUTF8String:text];

    
    
}

-(void)finalize {
    
    
    if( NULL != _statement ) {
        
        int resultCode = sqlite3_finalize( _statement );
        [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];

    }
    _statement = NULL;
}

-(int)step {
    
    int resultCode = sqlite3_step( _statement );

    if( SQLITE_ROW != resultCode && SQLITE_DONE != resultCode ) {
        
		NSString* technicalError = [NSString stringWithFormat:@"unexpected result from 'sqlite3_step'; resultCode = %d",resultCode];
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultString:technicalError];
		
	} else {

        // sqlite3_reset( _statement );
        
    }
    return resultCode;

}



#pragma mark -
#pragma mark instance lifecycle


-(id)initWithStatement:(sqlite3_stmt*)statement {
    
    
    NTSqliteStatement* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_statement = statement;
        
    }
    return answer;
    
}

-(void)dealloc {
	
    if( NULL != _statement ) {
        Log_warn( @"NULL != _statement" );
        [self finalize];
    }
	
}



@end
