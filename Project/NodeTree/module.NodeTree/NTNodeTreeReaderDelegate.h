//
//  NTNodeTreeReaderDelegate.h
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NTNode;
@class NTNodeTreeReader;
@protocol NTNodePropertyDelegate;


@protocol NTNodeTreeReaderDelegate <NSObject>


- (NSObject<NTNodeTreeReaderDelegate>*)onNodeBeginForReader:(NTNodeTreeReader*)nodeTreeReader  nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;

- (void)onNodeEndForReader:(NTNodeTreeReader*)nodeTreeReader nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;


@end

@interface NTNodeTreeReaderDelegate : NSObject <NTNodeTreeReaderDelegate>

@end
