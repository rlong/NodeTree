//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
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
