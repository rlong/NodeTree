//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class NTNode;

@interface NTJSONWriter : NSObject




+ (void)addJSONDictionary:(NSDictionary*)json toNode:(NTNode*)node;

@end
