//
//  XPSqliteNodeContext.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
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
