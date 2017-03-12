//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "NTConfiguration.h"
#import "NTNodeContext.h"
#import "NTNode.h"
#import "NTNodeTreeReader.h"

@implementation NTConfiguration {
    
    NTNodeContext* _context;
    NSString* _name;
    NTNode* _node;
    NSMutableDictionary* _values;
    

}



#pragma mark - instance lifecycle

-(instancetype)initWith:(NTNodeContext*)context name:(NSString*)name;
{
    
    self = [super init];
    
    if( self ) {
        _context = context;
        _name = name;
        _node = [_context getRootWithKey:name createIfNeeded:true];
        _values = [NSMutableDictionary new];
        [self loadValues];
    }
    
    return self;
    
}


#pragma mark -

- (void)loadValues;
{
    
    [NTNodeTreeReader readFromRoot:_node delegate:self];
    
}



#pragma mark - <NTNodeTreeReaderDelegate>



- (NSObject<NTNodeTreeReaderDelegate>*)onNodeBeginForReader:(NTNodeTreeReader*)nodeTreeReader  nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;
{
    
    Log_warnString( edgeName );
    
    return self;
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withBooleanValue:(BOOL)value;
{
    Log_debugFormat( @"%@[%d]: %d", name, [edgeIndex integerValue], value );
    [_values setObject:@(value) forKey:name];
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withIntegerValue:(int64_t)value;
{
    Log_debugFormat( @"%@[%d]: %d", name, [edgeIndex integerValue], value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withNullValue:(NSNull*)value;
{
    
    Log_debugFormat( @"%@[%d]: NULL", name, [edgeIndex integerValue], value );
}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withRealValue:(double)value;
{
    Log_debugFormat( @"%@[%d]: %f", name, [edgeIndex integerValue], value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withStringValue:(NSString*)value;
{
    Log_debugFormat( @"%@[%d]: %@", name, [edgeIndex integerValue], value );
}



- (void)onNodeEndForReader:(NTNodeTreeReader*)nodeTreeReader nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;
{
    Log_warnString( edgeName );
    
}


#pragma mark - bool




-(BOOL)boolValueForKey:(NSString*)key withDefaultValue:(BOOL)defaultValue;
{
    
    
    id value = [_values objectForKey:key];
    
    if( nil == value ) {
        return defaultValue;
    }
    
    if( ![value isKindOfClass:[NSNumber class]] ) {
        Log_warnFormat( @"_name: '%@'; key: '%@'; NSStringFromClass([value class]): '%@'", _name, key, NSStringFromClass([value class]));
        return defaultValue;
    }
    
    NSNumber* number = (NSNumber*)value;
    
    // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    
    const char* objCType = [number objCType];
    
    if (strcmp(objCType, @encode(BOOL)) != 0) {

        // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        Log_warnFormat( @"_name: '%@'; key: '%@'; objCType: '%s'", _name, key, objCType);
        return defaultValue;

    } else {
        
        BOOL answer = [number boolValue];
        Log_debugFormat( @"_name: '%@'; key: '%@'; answer = %d", _name, key, answer );
        return answer;
        
    }
    
    return defaultValue;
}

-(void)setBoolValue:(BOOL)value forKey:(NSString *)key;
{
    [_context begin];
    
    [_node setBool:value withKey:key]; // update db
    
    [_context commit];

    [_values setObject:@(value) forKey:key]; // update memory

    
}

-(int64_t)integerValueForKey:(NSString*)key withDefaultValue:(int64_t)defaultValue;
{
    
    
    id value = [_values objectForKey:key];
    
    if( nil == value ) {
        return defaultValue;
    }
    
    if( ![value isKindOfClass:[NSNumber class]] ) {
        Log_warnFormat( @"_name: '%@'; key: '%@'; NSStringFromClass([value class]): '%@'", _name, key, NSStringFromClass([value class]));
        return defaultValue;
    }
    
    NSNumber* number = (NSNumber*)value;
    
    // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    
    const char* objCType = [number objCType];
    
    if (strcmp(objCType, @encode(int64_t)) != 0) {
        
        // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        Log_warnFormat( @"_name: '%@'; key: '%@'; objCType: '%s'", _name, key, objCType);
        return defaultValue;
        
    } else {
        
        int64_t answer = [number integerValue];
        Log_debugFormat( @"_name: '%@'; key: '%@'; answer = %d", _name, key, answer );
        return answer;
        
    }
    
    return defaultValue;
}



-(void)setIntegerValue:(int64_t)value forKey:(NSString *)key;
{

    [_context begin];
    
    [_node setInteger:value withKey:key]; // update db

    [_context commit];
    
    [_values setObject:@(value) forKey:key]; // update memory
}


@end
