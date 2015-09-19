//
//  XPIntegerEncoder.h
//  vlc_amigo
//
//  Created by rlong on 4/05/13.
//
//

#import <Foundation/Foundation.h>

@interface NTIntegerEncoder : NSObject

+(NSString*)base64EncodeLongLong:(long long)integer;
+(NSString*)base64EncodeNumber:(NSNumber*)number;


@end
