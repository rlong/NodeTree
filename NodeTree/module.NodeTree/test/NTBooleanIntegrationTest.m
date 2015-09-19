//
//  XPAddBooleanIntegrationTest.m
//  vlc_amigo
//
//  Created by rlong on 6/05/13.
//
//



#import <XCTest/XCTest.h>


#import "FALog.h"


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
        [node setBool:false forKey:@"key.false"];
        [node setBool:true forKey:@"key.true"];
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];


}

@end
