//
//  XPAddNullIntegrationTest.m
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

@interface NTNullIntegrationTest : XCTestCase
@end


@implementation NTNullIntegrationTest

-(NSString*)getRootName {
    
    srand((unsigned int)clock());

    NSString* answer = [NSString stringWithFormat:@"%@.%d", NSStringFromClass([NTNullIntegrationTest class]), rand()];
    return answer;
    
}
-(void)test1 {
    
    Log_enteredMethod();
    
}

-(void)testAddNull {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];

    [nodeContext begin];
    {
        NTNode* node = [nodeContext addRootWithKey:[self getRootName]];
        [node setNullForKey:@"key.null"];
    }
    [nodeContext commit];
    
    
    [testContext closeContext:nodeContext];
    
}






@end
