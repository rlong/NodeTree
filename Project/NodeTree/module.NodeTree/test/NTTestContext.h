//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class NTNodeContext;

@interface NTTestContext : NSObject


+ (NTTestContext*)defaultContext;

- (void)closeContext:(NTNodeContext*)context;
- (NTNodeContext*)openContext;


@end
