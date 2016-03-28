//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@interface NTNodeTreeSchema : NSObject

+(void)buildSchema:(NSString*)databasePath;
+(void)dropSchema:(NSString*)databasePath;

@end
