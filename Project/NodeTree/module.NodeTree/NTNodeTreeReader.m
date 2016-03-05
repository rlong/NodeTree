//
//  NTNodeStream.m
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//



#import "CALog.h"

#import "NTNode.h"
#import "NTNodeIterator.h"
#import "NTNodeTreeReader.h"
#import "NTNodeTreeReaderDelegate.h"
#import "NTNodeProperty.h"
#import "NTNodePropertyIterator.h"



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



- (void)readPropertiesFor:(NTNode*)node withDelegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate {
    
    NTNodePropertyIterator* nodePropertyIterator = [NTNodePropertyIterator propertiesOf:node];
    
    for( NTNodeProperty* nodeProperty = [nodePropertyIterator next]; nil != nodeProperty; nodeProperty = [nodePropertyIterator next] ) {
        
        NSNumber* booleanValue = [nodeProperty booleanValue];
        if( nil != booleanValue ) {
            [delegate onPropertyWithEdgeName:[nodeProperty edgeName] edgeIndex:[nodeProperty edgeIndex] withBooleanValue:[booleanValue boolValue]];
            continue;

        }
        
        NSNumber* integerValue = [nodeProperty integerValue];
        if( nil != integerValue ) {
            [delegate onPropertyWithEdgeName:[nodeProperty edgeName] edgeIndex:[nodeProperty edgeIndex] withIntegerValue:[integerValue longLongValue]];
            continue;
            
        }
        NSNumber* realValue = [nodeProperty realValue];
        if( nil != realValue ) {
            [delegate onPropertyWithEdgeName:[nodeProperty edgeName] edgeIndex:[nodeProperty edgeIndex] withRealValue:[realValue doubleValue]];
            continue;
            
        }
        NSString* stringValue = [nodeProperty stringValue];
        if( nil != stringValue ) {
            [delegate onPropertyWithEdgeName:[nodeProperty edgeName] edgeIndex:[nodeProperty edgeIndex] withStringValue:stringValue];
            continue;
            
        }
        
        [delegate onPropertyWithEdgeName:[nodeProperty edgeName] edgeIndex:[nodeProperty edgeIndex] withNullValue:[NSNull null]];
    }
    
}

- (void)walk:(NTNode*)node withDelegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;
{

    [delegate onNodeBeginForReader:self nodePk:node.pk nodePath:node.pkPath edgeName:node.edgeName edgeIndex:node.edgeIndex typeId:node.typeId];
    
    [self readPropertiesFor:node withDelegate:delegate];
    
    NTNodeIterator* nodeIterator = [NTNodeIterator immediateChildrenOf:node];

    NTNode* child = [nodeIterator next];
    Log_debugString( child.edgeName);
    while( child != nil ) {
        
        [self walk:child withDelegate:delegate];
        
        child = [nodeIterator next];
    }
    
    [delegate onNodeEndForReader:self nodePk:node.pk nodePath:node.pkPath edgeName:node.edgeName edgeIndex:node.edgeIndex typeId:node.typeId];
    

}


+ (void)readFromRoot:(NTNode*)root delegate:(NSObject<NTNodeTreeReaderDelegate>*)delegate;
{
    
    
    NTNodeTreeReader* reader = [[NTNodeTreeReader alloc] init];
//    reader.nodeIterator = [NTNodeIterator childrenOf:root];
    reader.nodeIterator = [NTNodeIterator immediateChildrenOf:root];
    
    [reader walk:root withDelegate:delegate];
    
    
//    [NTNodeTreeReader walk:node withDelegate:delegate];
//    NTNodeTreeReader* reader = [[NTNodeTreeReader alloc] init];
//    reader.delegate = delegate;
//    [reader walk:root];
    
}



@end
