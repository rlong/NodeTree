//
//  NTJSONReaderIntegrationTest.m
//  NodeTree
//
//  Created by rlong on 19/09/2015.
//  Copyright (c) 2015 com.hexbeerium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


#import "FALog.h"

#import "NTJSONReader.h"
#import "NTJSONWriter.h"
#import "NTNodeContext.h"
#import "NTNodeIterator.h"
#import "NTTestContext.h"

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



- (NSString*)setupTestDataWithContext:(NTNodeContext*)nodeContext {
    
    NSString* rootNodeName = @"[NTJSONReaderIntegrationTest setupTestDataWithContext:]";
    
    NTNode* node = [nodeContext getRootWithKey:rootNodeName];
    if( nil != node ) {
        Log_debug( @"nil != node" );
        return rootNodeName; // nothing to do
    }
    

    ///////////////////////////////////////////////////////////////////////
    
    
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
    
    NSDictionary* json = nil;
    {
        NSJSONReadingOptions options = NSJSONReadingMutableContainers;
        NSError* error = nil;
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
        
        XCTAssertNil( error );
        XCTAssertNotNil( json );
        
    }

    
    NTNode* rootNode = [nodeContext addRootWithKey:rootNodeName];
    [NTJSONWriter addJSONDictionary:json toNode:rootNode];
    
    return rootNodeName;


    
    
}

- (void)testIterateOverDatabase {
    
    Log_enteredMethod();
    
    NTTestContext* testContext = [NTTestContext defaultContext];
    NTNodeContext* nodeContext = [testContext openContext];
    
    [nodeContext begin];
    {
        
        NSString* rootNodeName = [self setupTestDataWithContext:nodeContext];
        NTNode* rootNode = [nodeContext getRootWithKey:rootNodeName];
        XCTAssertNotNil( rootNode );
        
        NSDictionary* rootDictionary = [NTJSONReader readJSONDictionaryForNode:rootNode];
        
        Log_debugInt( [rootDictionary count] );
        XCTAssertTrue( 0 != [rootDictionary count] );
        
    }
    [nodeContext commit];
    
    [testContext closeContext:nodeContext];

    
    
}

@end
