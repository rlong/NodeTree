//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
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

#pragma mark - instance lifecycle


-(id)initWithDatabasePath:(NSString*)databasePath;

#pragma mark - 


+ (NSString*)databaseVersion;

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


@end
