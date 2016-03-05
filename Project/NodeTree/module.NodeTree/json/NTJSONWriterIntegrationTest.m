//
//  NTJSONWriterIntegrationTest.m
//  NodeTree
//
//  Created by rlong on 12/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


#import "CALog.h"

#import "JBBaseException.h"
#import "JBExceptionHelper.h"

#import "NTJSONWriter.h"
#import "NTTestContext.h"
#import "NTNodeContext.h"


@interface NTJSONWriterIntegrationTest : XCTestCase

@end

@implementation NTJSONWriterIntegrationTest


+ (void)initialize {
    
    srand((unsigned int)clock());

}

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



-(void)testWriteVLCPlayingStatus {
    

    NSDictionary* json = nil;
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"NTJSONWriterIntegrationTest.testWriteVLCPlayingStatus.json" ofType:nil];
        XCTAssertNotNil( path );
        
        
        NSData* jsonData = nil;
        {
            NSDataReadingOptions options = 0;
            NSError* error = nil;
            jsonData = [NSData dataWithContentsOfFile:path options:options error:&error];
            
            XCTAssertNil( error );
            XCTAssertNotNil( jsonData );
            
        }
        
        {
            NSJSONReadingOptions options = NSJSONReadingMutableContainers;
            NSError* error = nil;
            json = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
            
            XCTAssertNil( error );
            XCTAssertNotNil( json );
            
        }
        
    }
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    [nodeContext begin];
    {
        NSString* rootName = [NSString stringWithFormat:@"NTJSONWriterIntegrationTest.testWriteVLCPlayingStatus.%d", rand()];
        Log_debugString( rootName );

        NTNode* rootNode = [nodeContext addRootWithKey:rootName];
        [NTJSONWriter addJSONDictionary:json toNode:rootNode];
        
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];

    
}

@end
