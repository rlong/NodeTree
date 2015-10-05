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
- (id)initWithContext:(NTNodeContext*)context pk:(NSNumber*)pk parentPk:(NSNumber*)parentPk parentPkPath:(NSString*)parentPkPath;


#pragma mark -

- (NTNode*)addChildWithKey:(NSString*)key;
- (NTNode*)addChildWithKey:(NSString*)key typeId:(sqlite3_int64)typeId;
- (NTNode*)addChildWithKey:(NSString*)key index:(long long)index;

- (NTNode*)addChildWithIndex:(long long)index;
- (NTNode*)addChildWithIndex:(long long)index typeId:(sqlite3_int64)typeId;

#pragma mark - bool


-(BOOL)getBoolWithKey:(NSString*)key atIndex:(NSNumber*)index defaultValue:(BOOL)defaultValue;

- (void)removeBoolWithKeyAtIndex:(int64_t)index;
- (void)removeBoolWithKey:(NSString*)key;
- (void)removeBoolWithKey:(NSString*)key atIndex:(NSNumber*)index;

- (void)setBool:(BOOL)value atIndex:(int64_t)index;
- (void)setBool:(BOOL)value withKey:(NSString*)key;
- (void)setBool:(BOOL)value withKey:(NSString*)key atIndex:(NSNumber*)index;


#pragma mark - integer

-(int64_t)getIntegerWithKey:(NSString*)key atIndex:(NSNumber*)index defaultValue:(int64_t)defaultValue;

- (void)removeIntegerWithKeyAtIndex:(int64_t)index;
- (void)removeIntegerWithKey:(NSString*)key;
- (void)removeIntegerWithKey:(NSString*)key atIndex:(NSNumber*)index;


- (void)setInteger:(int64_t)value atIndex:(int64_t)index;
- (void)setInteger:(int64_t)value withKey:(NSString*)key;
- (void)setInteger:(int64_t)value withKey:(NSString*)key atIndex:(NSNumber*)index;


#pragma mark - null

- (void)setNullAtIndex:(sqlite_int64)index;
- (void)setNullForKey:(NSString*)key;


#pragma mark - real


- (void)setReal:(double)value atIndex:(sqlite_int64)index;
- (void)setReal:(double)value forKey:(NSString*)key;



#pragma mark - string

- (NSString*)getStringWithKey:(NSString*)key;
- (NSString*)getStringWithKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (void)setString:(NSString*)value atIndex:(sqlite_int64)index;
- (void)setString:(NSString*)value forKey:(NSString*)key;


#pragma mark - remove property

- (void)removeProperyAtIndex:(sqlite3_int64)index;
- (void)removeProperyWithKey:(NSString*)key;
- (void)removeProperyWithKey:(NSString*)key atIndex:(NSNumber*)index;






@end
