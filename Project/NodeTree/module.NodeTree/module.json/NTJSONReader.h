//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "NTNodeTreeReaderDelegate.h"

@interface NTJSONReader : NSObject <NTNodeTreeReaderDelegate>

@property (nonatomic, strong) NSMutableArray* rootArray;
@property (nonatomic, strong) NSMutableDictionary* rootDictionary;

@end
