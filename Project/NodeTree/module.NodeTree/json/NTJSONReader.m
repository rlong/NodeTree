//
//  NTJSONReader.m
//  NodeTree
//
//  Created by rlong on 17/12/2015.
//  Copyright © 2015 com.hexbeerium. All rights reserved.
//


#import "JBLog.h"
#import "NTJSONReader.h"

@implementation NTJSONReader {
    
    
    NSMutableArray* _stack;
    NSMutableArray* _currentArray;
    NSMutableDictionary* _currentDictionary;
    

}

- (instancetype)init {
    
    self = [super init];
    if( self ) {
        _stack = [[NSMutableArray alloc] init];
    }
    
    return self;
}


+ (void)addObject:(NSObject*)object toArray:(NSMutableArray*)array atIndex:(NSNumber*)edgeIndex  {

    NSInteger index = [edgeIndex intValue];
    
    if( array.count == index ) {
        
        [array addObject:object];
        
    } else if( array.count > index ) {
        
        [array setObject:object atIndexedSubscript:index];
        
    } else { // array < index
        
        NSInteger fillerCount = index - array.count;
        
        // fill space with nils ...
        for( int i = 0; i < fillerCount; i++ ) {
            [array addObject:[NSNull null]];
        }
        [array addObject:object];
    }

    
}

- (NSObject<NTNodeTreeReaderDelegate>*)onNodeBeginForReader:(NTNodeTreeReader*)nodeTreeReader  nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId {
    
    
//    if( nil != edgeName ) {
//        Log_debugString( edgeName );
//    }
    
    NSMutableArray* nextArray = nil;
    NSMutableDictionary* nextDictionary = nil;
    NSObject* nextObject = nil;
    
    // object ?
    if( nil == typeId ) {
        
        nextDictionary = [NSMutableDictionary new];
        nextObject = nextDictionary;
        
    } else if( 91 == [typeId intValue] ) { // array; 91 == '['
        
        nextArray = [NSMutableArray new];
        nextObject = nextArray;
        
    } else { // something else
        
        Log_warnInt( [typeId intValue] );
        return self;
        
    }
    
    [_stack addObject:nextObject];

    
    if( nil == _rootDictionary && nil == _rootArray ) {
        _rootArray = _currentArray = nextArray;
        _rootDictionary = _currentDictionary = nextDictionary;
        return self;
    }

    
    if( nil != _currentDictionary) {
        
        [_currentDictionary setObject:nextObject forKey:edgeName];
        
    } else if( nil != _currentArray ) {
        
        [NTJSONReader addObject:nextObject toArray:_currentArray atIndex:edgeIndex];
        
    } else {
        Log_warn( @"unexpected code path" );
    }
    
    _currentArray = nextArray;
    _currentDictionary = nextDictionary;
    return self;
}



- (void)onPropertyWithEdgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex withValue:(NSObject*)value {

    
//    if( nil != edgeName ) {
//        Log_debugString( edgeName );
//    }

    if( nil != _currentDictionary ) {
        [_currentDictionary setObject:value forKey:edgeName];
        
    } else {
        [NTJSONReader addObject:value toArray:_currentArray atIndex:edgeIndex];
    }
    
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withBooleanValue:(BOOL)value {
    
    [self onPropertyWithEdgeName:name edgeIndex:edgeIndex withValue:[NSNumber numberWithBool:value]];
    
}

- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withIntegerValue:(int64_t)value {
    
    [self onPropertyWithEdgeName:name edgeIndex:edgeIndex withValue:[NSNumber numberWithLongLong:value]];
}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withNullValue:(NSNull*)value {

    [self onPropertyWithEdgeName:name edgeIndex:edgeIndex withValue:value];

}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withRealValue:(double)value {
    
    [self onPropertyWithEdgeName:name edgeIndex:edgeIndex withValue:[NSNumber numberWithDouble:value]];
}


- (void)onPropertyWithEdgeName:(NSString*)name edgeIndex:(NSNumber*)edgeIndex withStringValue:(NSString*)value {

    [self onPropertyWithEdgeName:name edgeIndex:edgeIndex withValue:value];
}



- (void)onNodeEndForReader:(NTNodeTreeReader*)nodeTreeReader nodePk:(NSNumber*)nodePk nodePath:(NSString*)nodePath edgeName:(NSString*)edgeName edgeIndex:(NSNumber*)edgeIndex typeId:(NSNumber*)typeId {
    
    
//    if( nil != edgeName ) {
//        Log_debugString( edgeName );
//    }

    
    [_stack removeLastObject];
    NSObject* topObject = [_stack lastObject];
    
    if( [topObject isKindOfClass:[NSMutableDictionary class]] ) {
        
        _currentArray = nil;
        _currentDictionary = (NSMutableDictionary*)topObject;
        
    } else {
        _currentArray = (NSMutableArray*)topObject;
        _currentDictionary = nil;
    }
    
}

@end
