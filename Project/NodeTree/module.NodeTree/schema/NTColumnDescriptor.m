//
//  NDColumnDescriptor.m
//  prototype
//
//  Created by rlong on 29/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import "NTColumnDescriptor.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface NTColumnDescriptor ()
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation NTColumnDescriptor


-(NSString*)toString {
    return [NSString stringWithFormat:@"%@ %@", _name, _properties];
}

#pragma mark -
#pragma mark instance lifecycle



-(id)initWithName:(NSString*)name properties:(NSString*)properties {

    NTColumnDescriptor* answer = [super init];
    
    if( nil != answer ) {
        
        
        [answer setName:name];
        [answer setProperties:properties];
        
        
    }
    
    return answer;
    
}



-(void)dealloc {
	
	[self setName:nil];
	
	
}

#pragma mark -
#pragma mark fields

// name
//NSString* _name;
//@property (nonatomic, retain) NSString* name;
@synthesize name = _name;


// properties
//NSString* _properties;
//@property (nonatomic, retain) NSString* properties;
@synthesize properties = _properties;

@end
