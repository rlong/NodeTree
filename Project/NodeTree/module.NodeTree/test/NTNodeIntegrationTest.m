//
//  XPAddNodeIntegrationTest.m
//  vlc_amigo
//
//  Created by rlong on 6/05/13.
//
//

#import <XCTest/XCTest.h>

#import "CALog.h"


#import "NTNodeTree.h"
#import "NTTestContext.h"
#import "NTNode.h"
#import "NTNodeContext.h"


@interface NTNodeIntegrationTest : XCTestCase
@end


@implementation NTNodeIntegrationTest


-(NSString*)getRootName {
    
    srand((unsigned int)clock());

    NSString* answer = [NSString stringWithFormat:@"%@.%d", NSStringFromClass([NTNodeIntegrationTest class]), rand()];
    return answer;
    
}

-(void)test1 {
    
    Log_enteredMethod();
    
}

-(void)testAdd1 {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* parentNode = [nodeContext addRootWithKey:[self getRootName]];
        NTNode* childNode = [parentNode addChildWithKey:@"child_node"];
        [childNode setString:@"value" forKey:@"string_key"];
        [childNode setBool:true withKey:@"boolean_key"];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

}

-(void)testAdd2 {
    
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* rootNode = [nodeContext addRootWithKey:[self getRootName]];
        NTNode* parentNode = [rootNode addChildWithKey:@"parentNode"];
        [parentNode addChildWithKey:@"childNode"];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

}

-(void)testAdd3 {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* rootNode = [nodeContext addRootWithKey:[self getRootName]];
        NTNode* parentNode = [rootNode addChildWithKey:@"parentNode"];
        NTNode* childNode = [parentNode addChildWithKey:@"childNode"];
        [childNode setString:@"childNodeValue" forKey:@"childNodeProperty"];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

}

-(void)testAddThenRemove {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    [nodeContext begin];
    {
        NTNode* rootNode = [nodeContext addRootWithKey:[self getRootName]];
        [rootNode setString:@"rootNode.value" forKey:@"key"];
        
        NTNode* parentNode = [rootNode addChildWithKey:@"parentNode"];
        [parentNode setString:@"parentNode.value" forKey:@"key"];
        
        NTNode* childNode = [parentNode addChildWithKey:@"childNode"];
        [childNode setString:@"childNode.value" forKey:@"key"];
        
        [rootNode remove]; // removes the node it's properties, all properties of the children and the children nodes
        
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];
    
}



-(void)testAddRoot {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        [nodeContext addRootWithKey:[self getRootName]];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

}



@end
