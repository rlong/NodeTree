//
//  NTNodeTreeReaderIntegrationTest.m
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//

#import <XCTest/XCTest.h>



#import "FALog.h"

#import "JBBaseException.h"
#import "JBExceptionHelper.h"

#import "NTJSONWriter.h"
#import "NTTestContext.h"
#import "NTNodeContext.h"
#import "NTNodeTreeReader.h"
#import "NTNodeTreeReaderDelegate.h"


@interface NTNodeTreeReaderIntegrationTest : XCTestCase

@end

@implementation NTNodeTreeReaderIntegrationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



- (NTNode*)buildRoot:(NTNodeContext*)nodeContext;
{

    NSString* path = [[NSBundle mainBundle] pathForResource:@"NTNodeTreeReaderIntegrationTest.json" ofType:nil];
    XCTAssertNotNil( path );
    
    
    NSData* jsonData = nil;
    {
        NSDataReadingOptions options = 0;
        NSError* error = nil;
        jsonData = [NSData dataWithContentsOfFile:path options:options error:&error];
        
        XCTAssertNil( error );
        XCTAssertNotNil( jsonData );
        
    }
    
    NSDictionary* json = nil;
    {
        NSJSONReadingOptions options = NSJSONReadingMutableContainers;
        NSError* error = nil;
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
        
        XCTAssertNil( error );
        XCTAssertNotNil( json );
        
    }
    
    
    NTNode* answer;
    [nodeContext begin];
    {
        NSString* rootName = [NSString stringWithFormat:@"NTNodeTreeReaderIntegrationTest.testTreeRead.%d", rand()];
        Log_debugString( rootName );
        
        answer = [nodeContext addRootWithKey:rootName];
        [NTJSONWriter addJSONDictionary:json toNode:answer];
        
    }
    [nodeContext commit];
    
    return answer;

}


-(void)testTreeRead {
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    
    NTNode* root = [self buildRoot:nodeContext];
    XCTAssertNotNil( root );
    
    NTNodeTreeReaderDelegate* delegate = [[NTNodeTreeReaderDelegate alloc] init];
    [NTNodeTreeReader readFromRoot:root delegate:delegate];
    
    
}
@end
