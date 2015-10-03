//
//  XPTestConfiguration.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import <Foundation/Foundation.h>

@class NTNodeContext;

@interface NTTestContext : NSObject


+ (NTTestContext*)defaultContext;

- (void)closeContext:(NTNodeContext*)context;
- (NTNodeContext*)openContext;


@end
