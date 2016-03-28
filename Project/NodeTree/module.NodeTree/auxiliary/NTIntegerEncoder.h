//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface NTIntegerEncoder : NSObject

+(NSString*)base64EncodeLongLong:(long long)integer;
+(NSString*)base64EncodeNumber:(NSNumber*)number;


@end
