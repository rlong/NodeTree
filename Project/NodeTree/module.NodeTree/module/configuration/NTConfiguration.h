//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@class NTNodeContext;
#import "NTNodeTreeReaderDelegate.h"


@interface NTConfiguration : NSObject <NTNodeTreeReaderDelegate>

#pragma mark - instance lifecycle

-(instancetype)initWith:(NTNodeContext*)context name:(NSString*)name;


#pragma mark - bool

-(BOOL)boolValueForKey:(NSString*)key withDefaultValue:(BOOL)defaultValue;
-(void)setBoolValue:(BOOL)value forKey:(NSString *)key;


@end
