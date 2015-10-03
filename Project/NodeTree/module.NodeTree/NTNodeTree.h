//
//  NDNodeDatabase.h
//  prototype
//
//  Created by rlong on 27/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTNodeContext;
@class NTNode;


@interface NTNodeTree : NSObject {
    
    // databasePath
    NSString* _databasePath;
    //@property (nonatomic, retain) NSString* databasePath;
    //@synthesize databasePath = _databasePath;

}

//+(NBNodeBarn*)open:(NSString*)databaseFilename;
//-(NBNode*)addRootToContext:(NBNodeContext*)context withKey:(NSString*)key;


// can return nil */
//-(NBNode*)getRootFromContext:(NBNodeContext*)context withKey:(NSString*)key;

// can return nil if 'createIfNeeded' is false */
//-(NBNode*)getRootFromContext:(NBNodeContext*)context withKey:(NSString*)key createIfNeeded:(bool)createIfNeeded;


//-(void)begin:(NBNodeContext*)context;
//-(void)commit:(NBNodeContext*)context;

-(NTNodeContext*)openContext;
-(void)closeContext:(NTNodeContext*)context;

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithDatabasePath:(NSString*)databasePath;

@end
