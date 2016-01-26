//
//  NTNodeIterator.h
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NTNode;

@interface NTNodeIterator : NSObject



- (instancetype)initWithContext:(NTNodeContext*)context;


+ (NTNodeIterator*)childrenOf:(NTNode*)node;

+ (NTNodeIterator*)immediateChildrenOf:(NTNode*)node;


// returns nil when there are no more
- (NTNode*)next;



- (void)finalize;


@end
