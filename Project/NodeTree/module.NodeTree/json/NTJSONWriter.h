//
//  NTJSONWriter.h
//  NodeTree
//
//  Created by rlong on 12/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTNode;

@interface NTJSONWriter : NSObject




+ (void)addJSONDictionary:(NSDictionary*)json toNode:(NTNode*)node;

@end
