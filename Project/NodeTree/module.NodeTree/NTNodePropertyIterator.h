//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class NTNodeProperty;

@interface NTNodePropertyIterator : NSObject


+ (NTNodePropertyIterator*)propertiesOf:(NTNode*)node;

- (NTNodeProperty*)next;

@end
