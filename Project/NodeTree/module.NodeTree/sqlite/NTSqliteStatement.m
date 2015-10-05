//
//  XPSqlLiteStatement.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "FALog.h"

#import "JBBaseException.h"
#import "NodeTree-Swift.h"
#import "ErrorBuilder.h"


#import "NTSqliteStatement.h"
#import "NTSqliteUtilities.h"

@implementation NTSqliteStatement




-(void)bindDouble:(double)value atIndex:(int)index {
    

    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_double( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];

    
}


-(void)bindInt:(int)value atIndex:(int)index;
{
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_int( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
    
}


-(void)bindInt64:(sqlite3_int64)value atIndex:(int)index;
{
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_int64( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
    
}

-(void)bindInteger:(int64_t)value atIndex:(int)index;
{
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_int64( _statement, index, value );
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
    
}



- (void)bindNullAtIndex:(int)index;
{
    
    int resultCode = sqlite3_bind_null( _statement, index);
    
    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];

}


// will accept nil
-(void)bindNumber:(NSNumber*)value atIndex:(int)index;
{

    if( nil == value ) {
        [self bindNullAtIndex:index];
        return;
    }
    
    
    const char* objCType = [value objCType];
    
    // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    
    if (strcmp(objCType, @encode(BOOL)) == 0) {
        
        // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        [self bindInt:[value boolValue] atIndex:index];
        return;
    }
    
    // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    CFNumberType numberType = CFNumberGetType( (CFNumberRef)value );
    // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    
    switch (numberType) {
        case kCFNumberFloat32Type:
        case kCFNumberFloat64Type:
        case kCFNumberFloatType:
        case kCFNumberDoubleType:
        case kCFNumberCGFloatType:
            [self bindDouble:[value doubleValue] atIndex:index];
            return;
        default:
            [self bindInt64:[value longLongValue] atIndex:index];
            return;
    }

}



// will accept nil
-(void)bindText:(NSString*)value atIndex:(int)index;
{
    
    if( nil == value ) {
        [self bindNullAtIndex:index];
        return;
    }
    
    const char* utf8Text = NULL;

    if( nil != value ) {
        utf8Text = [value UTF8String];
    }
    
    // vvv http://www.sqlite.org/c3ref/bind_blob.html
    int resultCode = sqlite3_bind_text( _statement, index, utf8Text, -1, SQLITE_TRANSIENT);
    // ^^^ http://www.sqlite.org/c3ref/bind_blob.html

    [NTSqliteUtilities checkResultCodeIsOk:resultCode forStatement:_statement];
    
}


-(BOOL)getBoolAtColumn:(int)columnIndex error:(NSError**)error;
{

    int columnType = sqlite3_column_type( _statement, columnIndex );
    
    if( SQLITE_INTEGER != columnType ) {
        
        *error = ErrorBuilder_errorForFailure( @"SQLITE_INTEGER != columnType" );
        return false;
        
    }
    
    int value = sqlite3_column_int( _statement, columnIndex);
    if( 0 == value ) {
        return false;
    }
    return true;
    
    
}


- (int64_t)getIntegerAtColumn:(int)columnIndex error:(NSError**)error;
{

    int columnType = sqlite3_column_type( _statement, columnIndex );
    
    if( SQLITE_INTEGER != columnType ) {
        
        *error = ErrorBuilder_errorForFailure( @"SQLITE_INTEGER != columnType" );
        return false;
        
    }
    
    return sqlite3_column_int64( _statement, columnIndex);

}



- (NSNumber*)getNumberAtColumn:(int)columnIndex defaultTo:(NSNumber*)defaultValue;
{
    
    int columnType = sqlite3_column_type( _statement, columnIndex );
    
    if( SQLITE_NULL == columnType ) {
        return defaultValue;
    }

    if( SQLITE_INTEGER == columnType ) {
        long long value = sqlite3_column_int64( _statement, columnIndex);
        return [NSNumber numberWithLongLong:value];
    }

    if( SQLITE_FLOAT == columnType ) {
        double value = sqlite3_column_double( _statement, columnIndex);
        return [NSNumber numberWithDouble:value];
    }
    
    Log_warnFormat( @"columnIndex = %d; columnType = %d; ", columnIndex, columnType );

    return defaultValue;
    
}

-(long long)getInt64AtColumn:(int)columnIndex {
    
    return sqlite3_column_int64( _statement, columnIndex);
    
}


- (NSString*)getStringAtColumn:(int)columnIndex defaultTo:(NSString*)defaultValue;
{
    
    int columnType = sqlite3_column_type( _statement, columnIndex );
    
    if( SQLITE_NULL == columnType ) {
        return defaultValue;
    }
    
    if( SQLITE_TEXT == columnType ) {
        const char* text = (const char*)sqlite3_column_text( _statement, columnIndex);
        return [NSString stringWithUTF8String:text];
    }
    Log_warnFormat( @"columnIndex = %d; columnType = %d; ", columnIndex, columnType );
    
    return defaultValue;

    
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
