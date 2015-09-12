//
//  NDTableProperty.m
//  prototype
//
//  Created by rlong on 28/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//


#import "JBMemoryModel.h"

#import "NTTableProperty.h"

@implementation NTTableProperty


-(NSString*)toString {
    return _property;
}

#pragma mark instance lifecycle


-(id)initWithProperty:(NSString*)property {
    
    NTTableProperty* answer = [super init];
    
    if( nil != answer) {
        
        [answer setProperty:property];
        
    }
    
    return answer;
    
}


-(void)dealloc {
	
	[self setProperty:nil];

    JBSuperDealloc();
	
}


#pragma mark fields


// property
//NSString* _property;
//@property (nonatomic, retain) NSString* property;
@synthesize property = _property;


@end
