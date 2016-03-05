//
//  XPAddStringIntegrationTest.m
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


@interface NTStringIntegrationTest : XCTestCase
@end


@implementation NTStringIntegrationTest

-(NSString*)getRootName {
    
    srand((unsigned int)clock());
    
    NSString* answer = [NSString stringWithFormat:@"%@.%d", NSStringFromClass([NTStringIntegrationTest class]), rand()];
    return answer;
    
}

-(void)test1 {
    
    Log_enteredMethod();
    
}

-(void)testAddString {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:[self getRootName]];
        [node setString:@"string_value" forKey:@"string_key"];
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];
    
}

-(void)testGetString {

    NSString* rootName = [self getRootName];
    Log_debugString( rootName );
    
    NSString* expectedValue = @"string_value";

    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setString:expectedValue forKey:@"testGetString"];
    }
    {
        NTNode* node = [nodeContext getRootWithKey:rootName];
        XCTAssert( nil != node );
        
        NSString* actualValue = [node getStringWithKey:@"testGetString"];
        Log_debugString( actualValue );
        XCTAssertTrue(  [expectedValue isEqualToString:actualValue]);
        
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

}


-(void)testUpdateString {
    
    NSString* rootName = [self getRootName];
    Log_debugString( rootName );
    
    NSString* expectedValue = @"secondValue";

    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:rootName];
        [node setString:@"firstValue" forKey:@"testUpdateString"];
        [node setString:expectedValue forKey:@"testUpdateString"];
        NSString* actualValue = [node getStringWithKey:@"testUpdateString"];
        Log_debugString( actualValue );
        XCTAssertTrue( [expectedValue isEqualToString:actualValue] );
    }

    [nodeContext commit];

    [testContext closeContext:nodeContext];

    
    
}

@end
