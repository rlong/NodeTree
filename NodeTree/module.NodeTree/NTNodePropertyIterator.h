//
//  NTNodePropertyIterator.h
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTNodeProperty;

@interface NTNodePropertyIterator : NSObject


+ (NTNodePropertyIterator*)propertiesOf:(NTNode*)node;

- (NTNodeProperty*)next;

@end
