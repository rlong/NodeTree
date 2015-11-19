//
//  NTNodeStream.h
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>



@class NTNode;
@protocol NTNodeTreeReaderDelegate;


@interface NTNodeTreeReader : NSObject


+ (void)readFromRoot:(NTNode*)root delegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;

@end
