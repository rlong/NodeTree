//
//  XPIntegerEncoder.m
//  vlc_amigo
//
//  Created by rlong on 4/05/13.
//
//

#import "JBMemoryModel.h"

#import "NTIntegerEncoder.h"

@implementation NTIntegerEncoder




// vvv http://tools.ietf.org/html/rfc4648#section-5


static NSString* BASE64_DIGITS[] = {
                                @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",
                                @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",
                                @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                                @"-", @"_"
};


// ^^^ http://tools.ietf.org/html/rfc4648#section-5


+(NSString*)base64Encode:(long long)integer {


    NSMutableString* answer = [[NSMutableString alloc] init];
    JBAutorelease( answer );
    
    do {
        
        int index = (int)(integer % 64);
        
        [answer insertString:BASE64_DIGITS[index] atIndex:0];

        integer /= 64;

        
    } while( integer > 0);
    
    return answer;
    
}


@end
