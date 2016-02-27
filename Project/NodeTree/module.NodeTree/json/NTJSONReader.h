//
//  NTJSONReader.h
//  NodeTree
//
//  Created by rlong on 17/12/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTNodeTreeReaderDelegate.h"

@interface NTJSONReader : NSObject <NTNodeTreeReaderDelegate>

@property (nonatomic, strong) NSMutableArray* rootArray;
@property (nonatomic, strong) NSMutableDictionary* rootDictionary;

@end
