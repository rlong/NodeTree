//
//  NTNodeStream.m
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//



#import "FALog.h"

#import "NTNode.h"
#import "NTNodeIterator.h"
#import "NTNodeTreeReader.h"
#import "NTNodeTreeReaderDelegate.h"
#import "NTNodePropertyDelegate.h"



@interface NTNodeTreeReader()


@property (nonatomic, strong) NTNode* nextNode;
@property (nonatomic, strong) NTNodeIterator* nodeIterator;
@property (nonatomic, strong) NSMutableArray* pkStack;
@property (nonatomic, strong) NSNumber* topPk;


@end





@implementation NTNodeTreeReader

- (instancetype)init {
    
    self = [super init];
    
    
    if( self ) {
        self.pkStack = [[NSMutableArray alloc] init];
    }
    
    return self;
}



//- (NSNumber*)peek;
//{
//    return (NSNumber*)[self.pkStack lastObject];
//}
//
//- (NSNumber*)pop;
//{
//    
//}



//- (NTNode*)handleChildrenOf:(NTNode*)node withDelegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;
//{
//    
//    NTNode* nextNode = [self.nodeIterator next];
//    
//    while ( nil != nextNode && [node.pk isEqualToNumber:[nextNode parentPk]] ) {
//            
//            [self walk:nextNode withDelegate:delegate];
//            nextNode = [self.nodeIterator next]; // next child (maybe)
//    }
//    
//    return nextNode;
//}


// returns unhandled nodes (those that are not direct descendents (ie siblngs, or aunts or uncles)
- (NTNode*)walk:(NTNode*)node withDelegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;
{

    [delegate onNodeBeginForReader:self nodePk:node.pk nodePath:node.pkPath edgeName:node.edgeName edgeIndex:node.edgeIndex typeId:node.typeId];
    
    NTNode* nextNode = [self.nodeIterator next];
    Log_debugString( nextNode.edgeName);
    // while `nextNode` is a direct child ...
    while( nextNode != nil && [node.pk isEqualToNumber:[nextNode parentPk]] ) {
        
        nextNode = [self walk:nextNode withDelegate:delegate];
        
    }
    NTNode* unhandledNode = nextNode;
    
    [delegate onNodeEndForReader:self nodePk:node.pk nodePath:node.pkPath edgeName:node.edgeName edgeIndex:node.edgeIndex typeId:node.typeId];
    
    return unhandledNode;

}


// + (NTNodeIterator*)childrenOf:(NTNode*)node;

+ (void)readFromRoot:(NTNode*)root delegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;
{
    
    
    NTNodeTreeReader* reader = [[NTNodeTreeReader alloc] init];
    reader.nodeIterator = [NTNodeIterator childrenOf:root];
    
    [reader walk:root withDelegate:delegate];
    
    
//    [NTNodeTreeReader walk:node withDelegate:delegate];
//    NTNodeTreeReader* reader = [[NTNodeTreeReader alloc] init];
//    reader.delegate = delegate;
//    [reader walk:root];
    
}



@end
