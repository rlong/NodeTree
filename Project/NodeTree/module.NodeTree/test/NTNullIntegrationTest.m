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
