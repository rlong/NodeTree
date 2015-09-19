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
        [node setInt:1 forKey:@"integer_key"];
    }
    [nodeContext commit];

    [testContext closeContext:nodeContext];

    
}


@end
