//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@class NTConfiguration;

@interface NTConfigurationSet : NSObject


- (NTConfiguration*)getConfigurationWithName:(NSString*)name;


@end
