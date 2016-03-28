//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
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
    Log_debugFormat( @"%@[%d]: %d", name, [edgeIndex integerValue], value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withIntegerValue:(int64_t)value;
{
    Log_debugFormat( @"%@[%d]: %d", name, [edgeIndex integerValue], value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withNullValue:(NSNull*)value;
{
    
    Log_debugFormat( @"%@[%d]: NULL", name, [edgeIndex integerValue], value );
}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withRealValue:(double)value;
{
    Log_debugFormat( @"%@[%d]: %f", name, [edgeIndex integerValue], value );
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withStringValue:(NSString*)value;
{
    Log_debugFormat( @"%@[%d]: %@", name, [edgeIndex integerValue], value );
}



- (void)onNodeEndForReader:(NTNodeTreeReader*)nodeTreeReader nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId;
{
    self.offset--;
    Log_debugFormat( @"%@}", [self buildOffset] );
    
}

@end
