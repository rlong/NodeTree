//
//  XPSqliteNodeHandle.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class NTNodeContext;

@interface NTNode : NSObject
    
    
@property (nonatomic, strong) NSNumber* pk;
@property (nonatomic, strong) NSNumber* parentPk; // can be nil for root nodes
@property (nonatomic, strong) NSString* parentPkPath; // can be nil for root nodes

@property (nonatomic, strong) NSString* edgeName; // can be nil
@property (nonatomic, strong) NSNumber* edgeIndex; // can be nil


@property (nonatomic, strong) NSNumber* typeId; // can be nil


// transient fields ... 
@property (nonatomic, readonly) NSString* pkPath;
@property (nonatomic, readonly) NTNodeContext* context;



#pragma mark - instance lifecycle


// 'parentPk' and 'parentPkPath' can be nil for root nodes
-(id)initWithContext:(NTNodeContext*)context pk:(NSNumber*)pk parentPk:(NSNumber*)parentPk parentPkPath:(NSString*)parentPkPath;


#pragma mark -

-(NTNode*)addChildWithKey:(NSString*)key;
-(NTNode*)addChildWithKey:(NSString*)key typeId:(sqlite3_int64)typeId;
-(NTNode*)addChildWithKey:(NSString*)key index:(long long)index;

-(NTNode*)addChildWithIndex:(long long)index;
-(NTNode*)addChildWithIndex:(long long)index typeId:(sqlite3_int64)typeId;

#pragma mark - bool


-(void)setBool:(BOOL)value forKey:(NSString*)key;
-(void)setBool:(BOOL)value atIndex:(sqlite_int64)index;


#pragma mark - integer

-(void)setInt:(int)value atIndex:(sqlite_int64)index;
-(void)setInt:(int)value forKey:(NSString*)key;


#pragma mark - null


-(void)setNullAtIndex:(sqlite_int64)index;
-(void)setNullForKey:(NSString*)key;


#pragma mark - real


-(void)setReal:(double)value atIndex:(sqlite_int64)index;
-(void)setReal:(double)value forKey:(NSString*)key;



#pragma mark - string

-(NSString*)getStringWithKey:(NSString*)key;
-(NSString*)getStringWithKey:(NSString*)key defaultValue:(NSString*)defaultValue;
-(void)setString:(NSString*)value atIndex:(sqlite_int64)index;
-(void)setString:(NSString*)value forKey:(NSString*)key;


#pragma mark -






@end
