//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class NTNode;
@class CASqliteConnection;

@interface NTNodeContext : NSObject

-(NTNode*)addRootWithKey:(NSString*)key;

-(void)begin;
-(void)close;
-(void)commit;

// can return nil */
-(NTNode*)getRootWithKey:(NSString*)key;


// can return nil if 'createIfNeeded' is false */
-(NTNode*)getRootWithKey:(NSString*)key createIfNeeded:(bool)createIfNeeded;


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSqliteConnection:(CASqliteConnection*)sqliteConnection;

#pragma mark -
#pragma mark fields

// sqliteConnection
//XPSqliteConnection* _sqliteConnection;
@property (nonatomic, readonly) CASqliteConnection* sqliteConnection;
//@property (nonatomic, retain, readwrite) XPSqliteConnection* sqliteConnection;
//@synthesize sqliteConnection = _sqliteConnection;
@end
