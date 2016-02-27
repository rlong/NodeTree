//
//  NTJSONReaderIntegrationTest.m
//  NodeTree
//
//  Created by rlong on 13/02/2016.
//  Copyright © 2016 com.hexbeerium. All rights reserved.
//

#import <XCTest/XCTest.h>


#import "CALog.h"

#import "JBBaseException.h"
#import "JBExceptionHelper.h"

#import "NTJSONReader.h"
#import "NTNodeTreeReader.h"
#import "NTJSONWriter.h"
#import "NTTestContext.h"
#import "NTNodeContext.h"
#import "NTJSONReader.h"


@interface NTJSONReaderIntegrationTest : XCTestCase

@end

@implementation NTJSONReaderIntegrationTest

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
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NTJSONReaderIntegrationTest.buildRoot.json" ofType:nil];
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
        NSString* rootName = [NSString stringWithFormat:@"NTJSONReaderIntegrationTest.buildRoot.%d", rand()];
        Log_debugString( rootName );
        
        answer = [nodeContext addRootWithKey:rootName];
        [NTJSONWriter addJSONDictionary:json toNode:answer];
        
    }
    [nodeContext commit];
    
    return answer;
    
}


- (void)testReadVLCPlayingStatus {
    
    Log_enteredMethod();
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    NTNode* root = [self buildRoot:nodeContext];
    XCTAssertNotNil( root );
    
    NTJSONReader* delegate = [[NTJSONReader alloc] init];
    [NTNodeTreeReader readFromRoot:root delegate:delegate];
    
    NSArray* rootArray = [delegate rootArray];
    XCTAssertNil( rootArray );
    
    NSMutableDictionary* rootDictionary = [delegate rootDictionary];
    XCTAssertNotNil( rootDictionary );
    
    XCTAssertTrue( 20 == rootDictionary.count );

   
}


@end
