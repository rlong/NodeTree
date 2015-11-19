//
//  XPSqliteNodeHandle.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "NodeTree-Swift.h"
#import "ErrorBuilder.h"

#import "FALog.h"

#import "JBBaseException.h"


#import "NTIntegerEncoder.h"
#import "NTNode.h"
#import "NTNodeContext.h"
#import "NTSqliteConnection.h"
#import "NTSqliteStatement.h"




@implementation NTNode {
    

}


#pragma mark -
#pragma mark instance lifecycle


// 'parentPk' and 'parentPkPath' can be nil for root nodes
-(id)initWithContext:(NTNodeContext*)context pk:(NSNumber*)pk parentPk:(NSNumber*)parentPk parentPkPath:(NSString*)parentPkPath;
{
    
    NTNode* answer = [super init];
    
    if( nil != answer ) {
        
        _context = context;
        _pk = pk;
        _parentPk = parentPk;
        _parentPkPath = parentPkPath;
        
        if( nil == _parentPkPath ) {
            _pkPath = [[NTIntegerEncoder base64EncodeNumber:pk] stringByAppendingString:@"."];
        } else {
            _pkPath = [_parentPkPath stringByAppendingFormat:@"%@.", [NTIntegerEncoder base64EncodeNumber:pk]];
        }
    }
    
    return answer;
    
}



#pragma mark - 
#pragma mark <XPNodeHandle> implementation


-(NTNode*)addChildWithKey:(NSString*)key typeId:(sqlite3_int64)typeId;
{
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert into node (parent_pk, parent_pk_path, edge_name, edge_index, type_id) values(?,?,?,null,?)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:_pkPath atIndex:2];
        [sqliteStatement bindText:key atIndex:3];
        [sqliteStatement bindInt64:typeId atIndex:4];
        
        [sqliteStatement step];
        sqlite3_int64 rowId = [connection last_insert_rowid];
        
        return [self buildNodeHandle:rowId];
        
    }
    @finally {
        [sqliteStatement finalize];
    }

}


-(NTNode*)addChildWithKey:(NSString*)key {
    
    NTSqliteConnection* connection = [_context sqliteConnection];

    NSString* sql = @"insert into node (parent_pk, parent_pk_path, edge_name, edge_index) values(?,?,?,null)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:_pkPath atIndex:2];
        [sqliteStatement bindText:key atIndex:3];
        
        [sqliteStatement step];
        sqlite3_int64 rowId = [connection last_insert_rowid];
        
        return [self buildNodeHandle:rowId];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}

-(NTNode*)addChildWithKey:(NSString*)key index:(long long)index {
    

    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert into node (parent_pk, parent_pk_path, edge_name, edge_index) values(?,?,?,?)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:_pkPath atIndex:2];
        [sqliteStatement bindText:key atIndex:3];
        [sqliteStatement bindInt64:index atIndex:4];
        
        [sqliteStatement step];
        sqlite3_int64 rowId = [connection last_insert_rowid];
        
        return [self buildNodeHandle:rowId];
        
    }
    @finally {
        [sqliteStatement finalize];
    }

    
}


-(NTNode*)addChildWithIndex:(long long)index {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert into node (parent_pk, parent_pk_path, edge_name, edge_index) values(?,?,null,?)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:_pkPath atIndex:2];
        [sqliteStatement bindInt64:index atIndex:3];
        
        [sqliteStatement step];
        sqlite3_int64 rowId = [connection last_insert_rowid];
        
        return [self buildNodeHandle:rowId];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
    
}


-(NTNode*)addChildWithIndex:(long long)index typeId:(sqlite3_int64)typeId {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert into node (parent_pk, parent_pk_path, edge_name, edge_index, type_id) values(?,?,null,?,?)";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:_pkPath atIndex:2];
        [sqliteStatement bindInt64:index atIndex:3];
        [sqliteStatement bindInt64:typeId atIndex:4];
        
        [sqliteStatement step];
        sqlite3_int64 rowId = [connection last_insert_rowid];
        
        return [self buildNodeHandle:rowId];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
    
}


-(NTNode*)buildNodeHandle:(sqlite3_int64)rowId {
    
    NTNode* answer = [[NTNode alloc] initWithContext:_context  pk:@(rowId) parentPk:_pk parentPkPath:_pkPath];
    
    return answer;
    
    
}

#pragma mark - bool




-(BOOL)getBoolWithKey:(NSString*)key atIndex:(NSNumber*)index error:(NSError**)error {
    
    
    NSNumber* answer = nil;
    
    [self getPropertyWithKey:key atIndex:index booleanValue:&answer integerValue:nil realValue:nil stringValue:nil error:error];
    
    if( nil != *error ) {
        return false;
    }
    
    if( nil == answer ) {
        
        
        *error = ErrorBuilder_errorForFailure( @"nil == answer" );
        return false;
    }
    
    return [answer boolValue];
    
}

-(BOOL)getBoolWithKey:(NSString*)key atIndex:(NSNumber*)index defaultValue:(BOOL)defaultValue;
{
    
    NSError* error = nil;
    BOOL answer = [self getBoolWithKey:key atIndex:index error:&error];
    
    if( nil != error ) {
        return defaultValue;
    }
    
    return  answer;
    
}


- (void)removeBoolWithKeyAtIndex:(int64_t)index;
{
    [self removeProperyAtIndex:index];
}

- (void)removeBoolWithKey:(NSString*)key;
{
    [self removeProperyWithKey:key];
}

- (void)removeBoolWithKey:(NSString*)key atIndex:(NSNumber*)index;
{
    [self removeProperyWithKey:key atIndex:index];
}






-(void)setBool:(BOOL)value atIndex:(sqlite_int64)index;
{
    
    [self setBool:value withKey:nil atIndex:@(index)];
    
    
}

-(void)setBool:(BOOL)value withKey:(NSString*)key;
{
    
    [self setBool:value withKey:key atIndex:nil];
    
}

-(void)setBool:(BOOL)value withKey:(NSString*)key atIndex:(NSNumber*)index;
{

    [self insertOrReplacePropertyWithKey:key atIndex:index booleanValue:@(value) integerValue:nil realValue:nil stringValue:nil];

}





#pragma mark - integer





-(int64_t)getIntegerWithKey:(NSString*)key atIndex:(NSNumber*)index error:(NSError**)error {
    
    
    NSNumber* answer = nil;
    
    [self getPropertyWithKey:key atIndex:index booleanValue:nil integerValue:&answer realValue:nil stringValue:nil error:error];
    
    if( nil != *error ) {
        return false;
    }
    
    if( nil == answer ) {
        
        
        *error = ErrorBuilder_errorForFailure( @"nil == answer" );
        return false;
    }
    
    return [answer longLongValue];
    
    
}

-(int64_t)getIntegerWithKey:(NSString*)key atIndex:(NSNumber*)index defaultValue:(int64_t)defaultValue;
{
    
    NSError* error = nil;
    int64_t answer = [self getIntegerWithKey:key atIndex:index error:&error];
    
    if( nil != error ) {
        return defaultValue;
    }
    
    return  answer;
    
}




- (void)removeIntegerWithKeyAtIndex:(int64_t)index;
{
    [self removeProperyAtIndex:index];
}

- (void)removeIntegerWithKey:(NSString*)key;
{
    [self removeProperyWithKey:key];
}

- (void)removeIntegerWithKey:(NSString*)key atIndex:(NSNumber*)index;
{
    [self removeProperyWithKey:key atIndex:index];
}




-(void)setInteger:(int64_t)value atIndex:(int64_t)index;
{
    
    [self setInteger:value withKey:nil atIndex:@(index)];

}


-(void)setInteger:(int64_t)value withKey:(NSString*)key {
    
    [self setInteger:value withKey:key atIndex:nil];

    
}


- (void)setInteger:(int64_t)value withKey:(NSString*)key atIndex:(NSNumber*)index {
    
    
    [self insertOrReplacePropertyWithKey:key atIndex:index booleanValue:nil integerValue:@(value) realValue:nil stringValue:nil];
    
    
}


#pragma mark - number


-(NSNumber*)getNumberWithKey:(NSString*)key atIndex:(NSNumber*)index error:(NSError**)error {
    
    
    NSNumber* answer = nil;
    
    [self getPropertyWithKey:key atIndex:index booleanValue:&answer integerValue:&answer realValue:&answer stringValue:nil error:error];
    
    if( nil != *error ) {
        return nil;
    }
    
    return answer;
    
    
}

-(NSNumber*)getNumberWithKey:(NSString*)key atIndex:(NSNumber*)index defaultValue:(NSNumber*)defaultValue;
{
    
    NSNumber* answer = nil;
    NSError* error = nil;
    
    answer = [self getNumberWithKey:key atIndex:index error:&error];
    
    if( nil != error ) {
        return nil;
    }
    
    if( nil == answer ) {
        return defaultValue;
    }
    
    return  answer;
    
}


- (void)removeNumberWithKeyAtIndex:(int64_t)index;
{
    [self removeProperyAtIndex:index];
}

- (void)removeNumberWithKey:(NSString*)key;
{
    [self removeProperyWithKey:key];
}

- (void)removeNumberWithKey:(NSString*)key atIndex:(NSNumber*)index;
{
    [self removeProperyWithKey:key atIndex:index];
}



- (void)setNumber:(NSNumber*)number atIndex:(int64_t)index;
{
    [self setNumber:number withKey:nil atIndex:@(index)];

}

- (void)setNumber:(NSNumber*)number withKey:(NSString*)key;
{
    [self setNumber:number withKey:key atIndex:nil];
    
}


- (void)setNumber:(NSNumber*)number withKey:(NSString*)key atIndex:(NSNumber*)index;
{
    
    NSNumber* booleanValue = nil;
    NSNumber* integerValue = nil;
    NSNumber* realValue = nil;
    
    if( nil != number ) {
        
        const char* objCType = [number objCType];
        
        // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        if (strcmp(objCType, @encode(BOOL)) == 0) {
            
            // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
            booleanValue = number;
        } else {
            
            // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
            CFNumberType numberType = CFNumberGetType( (CFNumberRef)number );
            // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber

            switch (numberType) {
                case kCFNumberFloat32Type:
                case kCFNumberFloat64Type:
                case kCFNumberFloatType:
                case kCFNumberDoubleType:
                case kCFNumberCGFloatType:
                    realValue = number;
                    break;
                default:
                    integerValue = number;
            }
        }
    }
    
    [self insertOrReplacePropertyWithKey:key atIndex:index booleanValue:booleanValue integerValue:integerValue realValue:realValue stringValue:nil];
    
}




#pragma mark - null


-(void)setNullAtIndex:(sqlite_int64)index;
{
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property(node_pk, edge_name, edge_index) values(?,null,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindInt64:index atIndex:2];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }

}

-(void)setNullForKey:(NSString*)key {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property(node_pk, edge_name, edge_index) values(?,?,null)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
    
    
}

- (void)setNullWithKey:(NSString*)key atIndex:(NSNumber*)index;
{
    
    
    
}




#pragma mark - real


-(void)setReal:(double)value atIndex:(sqlite_int64)index {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, real_value) values(?,null,?,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindInt64:index atIndex:2];
        [sqliteStatement bindDouble:value atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
    
}


-(void)setReal:(double)value forKey:(NSString*)key {

    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, real_value) values(?,?,null,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindDouble:value atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}


#pragma mark - string


-(NSString*)getStringWithKey:(NSString*)key throwExceptionOnNull:(bool)throwExceptionOnNull {

    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"select string_value from node_property where node_pk = ? and edge_name = ? and edge_index = null";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        
        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            NSString* answer = [sqliteStatement getTextAtColumn:0];
            
            return answer;
            
        } else if( SQLITE_DONE == resultCode ) {
            
            if( throwExceptionOnNull ) {
                
                @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"string property not found; _pk = %ld; key = '%@'", _pk, key];
                
            } else {
                return nil;
            }
        }
        
    }
    @finally {
        [sqliteStatement finalize];
    }

    
}

-(NSString*)getStringWithKey:(NSString*)key {
    
    return [self getStringWithKey:key throwExceptionOnNull:true];
    
}


-(NSString*)getStringWithKey:(NSString*)key defaultValue:(NSString*)defaultValue {
    
    NSString* answer = [self getStringWithKey:key throwExceptionOnNull:false];
    
    if( nil == answer ) {
        return defaultValue;
    }
    
    return answer;
}



-(void)setString:(NSString*)value atIndex:(sqlite_int64)index;
{
    
    
        NTSqliteConnection* connection = [_context sqliteConnection];
    
        NSString* sql = @"insert or replace into node_property(node_pk, edge_name, edge_index, string_value) values(?,null,?,?)";
        NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
        @try {
    
            [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
            [sqliteStatement bindInt64:index atIndex:2];
            [sqliteStatement bindText:value atIndex:3];
    
            [sqliteStatement step];
    
        }
        @finally {
            [sqliteStatement finalize];
        }
    
}

-(void)setString:(NSString*)value forKey:(NSString*)key {
    
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property(node_pk, edge_name, edge_index, string_value) values(?,?,null,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindText:value atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}


#pragma mark - property

// returns whether the row was found or not
-(BOOL)getPropertyWithKey:(NSString*)key atIndex:(NSNumber*)index booleanValue:(NSNumber**)booleanValue integerValue:(NSNumber**)integerValue realValue:(NSNumber**)realValue stringValue:(NSString**)stringValue error:(NSError**)error  {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* keyComparator = @"=";
    if( nil == key ) {
        keyComparator = @"is";
    }
    NSString* indexComparator = @"=";
    if( nil == index ) {
        indexComparator = @"is";
    }
    
    NSString *sql = [NSString stringWithFormat:@"select boolean_value, integer_value, real_value, string_value from node_property where node_pk = ? and edge_name %@ ? and edge_index %@ ?", keyComparator, indexComparator];
    
    NTSqliteStatement *sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindNumber:index atIndex:3];
        
        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            
            
            if( nil != booleanValue ) {
                *booleanValue = [sqliteStatement getNumberAtColumn:0 defaultTo:nil];
            }
            if( nil != integerValue ) {
                *integerValue = [sqliteStatement getNumberAtColumn:1 defaultTo:nil];
            }
            if( nil != realValue ) {
                *realValue = [sqliteStatement getNumberAtColumn:2 defaultTo:nil];
            }
            if( nil != stringValue ) {
                *stringValue = [sqliteStatement getStringAtColumn:3 defaultTo:nil];
            }
            
            return true;
            
            
        } else if( SQLITE_DONE == resultCode ) {
            
            return false;
            
        }
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}







- (void)insertOrReplacePropertyWithKey:(NSString*)key atIndex:(NSNumber*)index booleanValue:(NSNumber*)booleanValue integerValue:(NSNumber*)integerValue realValue:(NSNumber*)realValue stringValue:(NSString*)stringValue;
{
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, boolean_value, integer_value, real_value, string_value) values(?,?,?, ?,?,?,?)";
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindNumber:index atIndex:3];
        [sqliteStatement bindNumber:booleanValue atIndex:4];
        [sqliteStatement bindNumber:integerValue atIndex:5];
        [sqliteStatement bindNumber:realValue atIndex:6];
        [sqliteStatement bindText:stringValue atIndex:7];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
    
}


#pragma mark - remove property


- (void)removeAllProperties;
{
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    NSString* sql = @"delete from node_property where node_pk = ? ";
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }

}


- (void)removeProperyAtIndex:(int64_t)index;
{
    [self removeBoolWithKey:nil atIndex:@(index)];
    
}


- (void)removeProperyWithKey:(NSString*)key;
{
    
    [self removeBoolWithKey:key atIndex:nil];
}

- (void)removeProperyWithKey:(NSString*)key atIndex:(NSNumber*)index;
{
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    
    NSString* keyComparator = @"=";
    if( nil == key ) {
        keyComparator = @"is";
    }
    NSString* indexComparator = @"=";
    if( nil == index ) {
        indexComparator = @"is";
    }

    NSString* sql = [NSString stringWithFormat:@"delete from node_property where node_pk = ? and edge_name %@ ? and edge_index %@ ?", keyComparator, indexComparator];
    
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindNumber:index atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}







@end
