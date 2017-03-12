//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "NTJSONWriter.h"
#import "NTNode.h"


// 0x5b '['
#define TYPE_ID_ARRAY 0x5b


@implementation NTJSONWriter {
    

    
}



+ (void)addBlob:(id)blob withkey:(NSString*)key toNode:(NTNode*)node  {

    
    
    
    if( [blob isKindOfClass:[NSArray class]] ) {
        
        NTNode* child = [node addChildWithKey:key typeId:TYPE_ID_ARRAY];
        NSArray* array = (NSArray*)blob;
        [self addJSONArray:array toNode:child];
        return;
        
    }

    
    if( [blob isKindOfClass:[NSDictionary class]] ) {
        
        NTNode* child = [node addChildWithKey:key];
        NSDictionary* dictionary = (NSDictionary*)blob;
        [self addJSONDictionary:dictionary toNode:child];
        return;
    }
    

    if( [blob isKindOfClass:[NSNull class]] ) {
        [node setNullForKey:key];
        return;
    }

    
    if( [blob isKindOfClass:[NSNumber class]]) {
        
        NSNumber* number = (NSNumber*)blob;
        [node setNumber:number withKey:key];
        return;
        
    }
    
    if( [blob isKindOfClass:[NSString class]] ) {
        
        NSString* value = (NSString*)blob;
        [node setString:value forKey:key];
        return;
    }
    
    
    
    
    Log_warnFormat( @"unhandled type; NSStringFromClass([blob class]) = '%@'", NSStringFromClass([blob class]) );
    
}


+ (void)addBlob:(id)blob atIndex:(sqlite_int64)index toNode:(NTNode*)node  {
    
    
    
    if( [blob isKindOfClass:[NSArray class]] ) {
        
        NTNode* child = [node addChildWithIndex:index typeId:TYPE_ID_ARRAY];
        NSArray* array = (NSArray*)blob;
        [self addJSONArray:array toNode:child];
        return;
    }

    if( [blob isKindOfClass:[NSDictionary class]] ) {
        
        NTNode* child = [node addChildWithIndex:index];
        NSDictionary* dictionary = (NSDictionary*)blob;
        [self addJSONDictionary:dictionary toNode:child];
        return;
    }
    
    if( [blob isKindOfClass:[NSNull class]] ) {
        [node setNullAtIndex:index];
        return;
    }
    
    if( [blob isKindOfClass:[NSNumber class]]) {
        
        NSNumber* number = (NSNumber*)blob;
        [node setNumber:number atIndex:index];
        return;
        
    }
    
    if( [blob isKindOfClass:[NSString class]] ) {
        
        NSString* value = (NSString*)blob;
        [node setString:value atIndex:index];
        return;
    }
    
    
    
    Log_warnFormat( @"unhandled type; NSStringFromClass([blob class]) = '%@'", NSStringFromClass([blob class]) );
    
}



+ (void)addJSONDictionary:(NSDictionary*)json toNode:(NTNode*)node;
{
    
    for( NSString* key in json ) {
        
        id blob = [json objectForKey:key];
        [self addBlob:blob withkey:key toNode:node];

    }
}

+ (void)addJSONArray:(NSArray*)json toNode:(NTNode*)node;
{
    for( NSUInteger i = 0, count = [json count]; i < count; i++ ) {
        id blob = [json objectAtIndex:i];
        [self addBlob:blob atIndex:i toNode:node];
    }
}




@end
