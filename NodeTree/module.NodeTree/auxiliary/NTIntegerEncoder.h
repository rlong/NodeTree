//
//  XPIntegerEncoder.h
//  vlc_amigo
//
//  Created by rlong on 4/05/13.
//
//

#import <Foundation/Foundation.h>

@interface NTIntegerEncoder : NSObject

+(NSString*)base64Encode:(long long)integer;

@end
