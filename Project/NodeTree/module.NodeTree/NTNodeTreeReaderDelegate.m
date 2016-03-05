//
//  NTNodeTreeReaderDelegate.m
//  NodeTree
//
//  Created by rlong on 15/11/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//


#import "CALog.h"


#import "NTNodeTreeReaderDelegate.h"


@interface NTNodeTreeReaderDelegate()

@property (nonatomic, assign) int offset;

@end

@implementation NTNodeTreeReaderDelegate




- (NSString*)buildOffset;
{
    NSMutableString* answer = [[NSMutableString alloc] init];
    for( int i = 0; i < self.offset; i++ ) {
        [answer appendString:@"  "];
    }
    return answer;
}

- (NSObject<NTNodeTreeReaderDelegate>*)onNodeBeginForReader:(NTNodeTreeReader*)nodeTreeReader  nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;
{
    
    Log_debugFormat( @"%@%@ {", [self buildOffset], edgeName );
    self.offset++;
    
    return self;
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withBooleanValue:(BOOL)value;
{
    Log_debugFormat( @"%@: %d", name, value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withIntegerValue:(int64_t)value;
{
    Log_debugFormat( @"%@: %d", name, value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withNullValue:(NSNull*)value;
{
    
    Log_debugFormat( @"%@: NULL", name, value );
}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withRealValue:(double)value;
{
    Log_debugFormat( @"%@: %f", name, value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withStringValue:(NSString*)value;
{
    Log_debugFormat( @"%@: %@", name, value );
}



- (void)onNodeEndForReader:(NTNodeTreeReader*)nodeTreeReader nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;
{
    self.offset--;
    Log_debugFormat( @"%@}", [self buildOffset] );
    
}

@end
