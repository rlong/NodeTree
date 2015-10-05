//
//  XPAddIntegerIntegrationTest.m
//  vlc_amigo
//
//  Created by rlong on 6/05/13.
//
//


#import <XCTest/XCTest.h>


#import "FALog.h"

#import "NTNodeTree.h"
#import "NTTestContext.h"
#import "NTNode.h"
#import "NTNodeContext.h"

@interface NTIntegerIntegrationTest : XCTestCase
@end


@implementation NTIntegerIntegrationTest

-(NSString*)getRootName {
    
    srand((unsigned int)clock());

    NSString* answer = [NSString stringWithFormat:@"%@.%d", NSStringFromClass([NTIntegerIntegrationTest class]), rand()];
    return answer;
    
}

-(void)test1 {
    
    Log_enteredMethod();
    
}

-(void)testAddInteger {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:[self getRootName]];
        [node setInteger:1 withKey:@"integer_key"];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

    
}


- (void)testGetInteger;
{
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    
    NSString* rootName = [self getRootName];
    
    // write
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setInteger:42 withKey:@"testGetInteger"];
    }
    [nodeContext commit];
    
    // read
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        int64_t actualValue = [node getIntegerWithKey:@"testGetInteger" atIndex:nil defaultValue:0];
        XCTAssertTrue( 42 == actualValue );
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];
    
    
}


- (void)testRemoveInteger;
{
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    
    NSString* rootName = [self getRootName];
    
    // write
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setInteger:42 withKey:@"testRemoveInteger"];
    }
    [nodeContext commit];
    
    
    // read
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        int64_t actualValue = [node getIntegerWithKey:@"testRemoveInteger" atIndex:nil defaultValue:0];
        XCTAssertTrue( 42 == actualValue );
    }
    [nodeContext commit];
    
    
    // remove
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        [node removeIntegerWithKey:@"testRemoveInteger"];
    }
    [nodeContext commit];
    
    // read, expect to fall back on the default value
    [nodeContext begin];
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssertNotNil( node );
        int64_t actualValue = [node getIntegerWithKey:@"testRemoveInteger" atIndex:nil defaultValue:0];
        XCTAssertTrue( 0 == actualValue );
    }
    [nodeContext commit];
    
    
    
    [testContext closeContext:nodeContext];
    
    
}


@end
