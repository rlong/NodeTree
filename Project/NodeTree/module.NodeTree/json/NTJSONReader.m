//
//  NTJSONReader.m
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//


#import "FALog.h"

#import "NTJSONReader.h"
#import "NTNode.h"
#import "NTNodeIterator.h"
#import "NTNodeProperty.h"
#import "NTNodePropertyIterator.h"


#define TYPE_ID_ARRAY 0x5b

@implementation NTJSONReader


+ (void)setBlob:(id)blob atIndex:(long)index inArray:(NSMutableArray*)array {
    
    long offsetFromEnd = index - [array count];
    
    if( offsetFromEnd < [array count] ) {
        
        [array setObject:blob atIndexedSubscript:index];
        
    } else {
        for( long i = 0; i < offsetFromEnd; i++ ) {
            [array addObject:[NSNull null]];
        }
        [array addObject:blob];
    }
    
}

+ (void)addPropertiesFor:(NTNode*)node toJSONObject:(NSMutableDictionary*)jsonObject {
    
    
    
    NTNodePropertyIterator* nodePropertyIterator = [NTNodePropertyIterator propertiesOf:node];
    
    for( NTNodeProperty* nodeProperty = [nodePropertyIterator next]; nil != nodeProperty; nodeProperty = [nodePropertyIterator next] ) {
    
        if( nil != [nodeProperty booleanValue] ) {
            [jsonObject setObject:[nodeProperty booleanValue] forKey:[nodeProperty edgeName]];
            continue;
        }
        
        if( nil != [nodeProperty integerValue] ) {
            [jsonObject setObject:[nodeProperty integerValue] forKey:[nodeProperty edgeName]];
            continue;
            
        }
        if( nil != [nodeProperty realValue] ) {
            [jsonObject setObject:[nodeProperty realValue] forKey:[nodeProperty edgeName]];
            continue;
            
        }
        if( nil != [nodeProperty stringValue] ) {
            [jsonObject setObject:[nodeProperty stringValue] forKey:[nodeProperty edgeName]];
            continue;
            
        }
        [jsonObject setObject:[NSNull null] forKey:[nodeProperty edgeName]];
    }
    
}

+ (NSDictionary*)readJSONDictionaryForNode:(NTNode*)rootNode;
{

    Log_enteredMethod();
    
    NSMutableDictionary* answer = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary* allJSONObjects = [[NSMutableDictionary alloc] init];
    NSMutableArray* allNodes = [[NSMutableArray alloc] init];
    
    
    [allJSONObjects setObject:answer forKey:[rootNode pk]];
    
    
    NTNodeIterator* iterator = [NTNodeIterator childrenOf:rootNode];
    
    // build all the objects
    for( NTNode* descendant = [iterator next]; nil != descendant; descendant = [iterator next] ) {

        if( TYPE_ID_ARRAY == [[descendant typeId] longLongValue] ) {
            
            [allJSONObjects setObject:[[NSMutableArray alloc] init] forKey:[descendant pk]];

        } else {
            
            [allJSONObjects setObject:[[NSMutableDictionary alloc] init] forKey:[descendant pk]];

        }
        [allNodes addObject:descendant];
    }
    
    
    // connect all the objects ...
    {
        for( NTNode* descendantNode in allNodes ) {
            
            NSString* edgeName = [descendantNode edgeName];
            NSNumber* edgeIndex = [descendantNode edgeIndex];
            
            id descendantJSONObject = [allJSONObjects objectForKey:[descendantNode pk]];
            
            
            id parent = [allJSONObjects objectForKey:[descendantNode parentPk]];
            
            if( [parent isKindOfClass:[NSMutableArray class]] ) {
                NSMutableArray* parentArray = (NSMutableArray*)parent;
                [self setBlob:descendantJSONObject atIndex:[edgeIndex longValue] inArray:parentArray];
            } else {
                NSMutableDictionary* parentDictionary = (NSMutableDictionary*)parent;
                [parentDictionary setObject:descendantJSONObject forKey:edgeName];
            }
        }
    }
    
    // get all the properties ...
    {
        [self addPropertiesFor:rootNode toJSONObject:answer];
        
        for( NTNode* descendantNode in allNodes ) {
            
            id descendantBlob = [allJSONObjects objectForKey:[descendantNode pk]];
            if( [descendantBlob isKindOfClass:[NSMutableArray class]] ) {
                Log_warn( @"unimplemented" );
            } else {
                NSMutableDictionary* descendantJSONObject = (NSMutableDictionary*)descendantBlob;
                [self addPropertiesFor:descendantNode toJSONObject:descendantJSONObject];
            }
        }
    }
    
    return answer;
    
}



@end
