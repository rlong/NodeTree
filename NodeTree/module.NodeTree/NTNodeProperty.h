//
//  NTNodeProperty.h
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
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
