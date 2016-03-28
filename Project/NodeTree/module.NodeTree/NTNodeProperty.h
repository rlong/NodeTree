//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface NTNodeProperty : NSObject


@property (nonatomic, strong) NSNumber* nodePk;

@property (nonatomic, strong) NSString* edgeName;
@property (nonatomic, strong) NSNumber* edgeIndex;

@property (nonatomic, strong) NSNumber* booleanValue;
@property (nonatomic, strong) NSNumber* integerValue;
@property (nonatomic, strong) NSNumber* realValue;

@property (nonatomic, strong) NSString* stringValue;


@end
