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
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* keyComparator = @"=";
    if( nil == key ) {
        keyComparator = @"is";
    }
    NSString* indexComparator = @"=";
    if( nil == index ) {
        indexComparator = @"is";
    }
    
    NSString *sql = [NSString stringWithFormat:@"select boolean_value from node_property where node_pk = ? and edge_name %@ ? and edge_index %@ ?", keyComparator, indexComparator];
    
    NTSqliteStatement *sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindNumber:index atIndex:3];
        
        int resultCode = [sqliteStatement step];
        if( SQLITE_ROW == resultCode ) {
            
            
            BOOL answer = [sqliteStatement getBoolAtColumn:0 error:error];
            
            return answer;
            
        } else if( SQLITE_DONE == resultCode ) {
            
            *error = ErrorBuilder_errorForFailure( @"SQLITE_DONE == resultCode" );
            return nil;
        }
    }
    @finally {
        [sqliteStatement finalize];
    }
    
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


- (void)removeBoolWithKeyAtIndex:(sqlite_int64)index;
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

    int intValue = 0;
    if( value ) {
        intValue = 1;
    }
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, boolean_value, integer_value, real_value, string_value) values(?,?,?, ?,null,null,null)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindNumber:index atIndex:3];
        [sqliteStatement bindInt:intValue atIndex:4];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }

}





#pragma mark - integer



-(void)setInt:(int)value atIndex:(sqlite_int64)index;
{
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, integer_value) values(?,null,?,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindInt64:index atIndex:2];
        [sqliteStatement bindInt:value atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
}


-(void)setInt:(int)value forKey:(NSString*)key {
    
    NTSqliteConnection* connection = [_context sqliteConnection];
    
    NSString* sql = @"insert or replace into node_property (node_pk, edge_name, edge_index, integer_value) values(?,?,null,?)";
    NTSqliteStatement* sqliteStatement = [connection prepare:sql];
    
    @try {
        
        [sqliteStatement bindInt64:[_pk longLongValue] atIndex:1];
        [sqliteStatement bindText:key atIndex:2];
        [sqliteStatement bindInt:value atIndex:3];
        
        [sqliteStatement step];
        
    }
    @finally {
        [sqliteStatement finalize];
    }
    
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


#pragma mark - remove property

- (void)removeProperyAtIndex:(sqlite3_int64)index;
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
