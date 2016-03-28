//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>



@class NTNode;
@protocol NTNodeTreeReaderDelegate;


@interface NTNodeTreeReader : NSObject


+ (void)readFromRoot:(NTNode*)root delegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;

@end
