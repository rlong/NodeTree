//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <XCTest/XCTest.h>


#import "CALog.h"


#import "NTNodeTree.h"
#import "NTTestContext.h"
#import "NTNodeContext.h"
#import "NTNode.h"

@interface NTBooleanIntegrationTest : XCTestCase
@end


@implementation NTBooleanIntegrationTest


-(NSString*)getRootName {
    
    srand((unsigned int)clock());

    NSString* answer = [NSString stringWithFormat:@"%@.%d", NSStringFromClass([NTBooleanIntegrationTest class]), rand()];
    return answer;
    
}

-(void)test1 {
    
    Log_enteredMethod();
    
}

-(void)testAddBoolean {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:[self getRootName]];
        [node setBool:false withKey:@"key.false"];
        [node setBool:true withKey:@"key.true"];
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];
}


- (void)testGetBoolean;
{
 
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    
    NSString* rootName = [self getRootName];
    
    // write
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setBool:true withKey:@"testGetBoolean"];
    }
    [nodeContext commit];
    
    // read
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        BOOL expectTrue = [node getBoolWithKey:@"testGetBoolean" atIndex:nil defaultValue:false];
        XCTAssertTrue( expectTrue );
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];

    
}


- (void)testRemoveBoolean;
{
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    
    NSString* rootName = [self getRootName];
    
    // write
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setBool:true withKey:@"testGetBoolean"];
    }
    [nodeContext commit];
    
    
    // read
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        BOOL expectTrue = [node getBoolWithKey:@"testGetBoolean" atIndex:nil defaultValue:false];
        XCTAssertTrue( expectTrue );
    }
    [nodeContext commit];
    
    
    // remove
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        [node removeProperyWithKey:@"testGetBoolean"];
    }
    [nodeContext commit];
    
    // read, expect to fall back on the default value
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        BOOL expectFalse = [node getBoolWithKey:@"testGetBoolean" atIndex:nil defaultValue:false];
        XCTAssertFalse( expectFalse);
    }
    [nodeContext commit];
    

    
    [testContext closeContext:nodeContext];
    
    
}

@end
