//
//  NTJSONWriter.m
//  NodeTree
//
//  Created by rlong on 12/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//


#import "FALog.h"

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
        
        const char* objCType = [number objCType];
        
        // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        if (strcmp(objCType, @encode(BOOL)) == 0) {
            
            // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
            
            [node setBool:[number boolValue] forKey:key];
            return;
        }
        
        // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        CFNumberType numberType = CFNumberGetType( (CFNumberRef)number );
        // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        switch (numberType) {
            case kCFNumberFloat32Type:
            case kCFNumberFloat64Type:
            case kCFNumberFloatType:
            case kCFNumberDoubleType:
            case kCFNumberCGFloatType:
                [node setReal:[number doubleValue] forKey:key];
                return;
            default:
                [node setInt:[number intValue] forKey:key];
                return;
        }
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
        
        const char* objCType = [number objCType];
        
        // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        if (strcmp(objCType, @encode(BOOL)) == 0) {
            
            // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
            
            [node setBool:[number boolValue] atIndex:index];
            return;
        }
        
        // vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        CFNumberType numberType = CFNumberGetType( (CFNumberRef)number );
        // ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        switch (numberType) {
            case kCFNumberFloat32Type:
            case kCFNumberFloat64Type:
            case kCFNumberFloatType:
            case kCFNumberDoubleType:
            case kCFNumberCGFloatType:
                [node setReal:[number doubleValue] atIndex:index];
                return;
            default:
                [node setInt:[number intValue] atIndex:index];
                return;
        }
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
