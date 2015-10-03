//
//  NDTableDescriptor.h
//  prototype
//
//  Created by rlong on 4/12/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTTableDescriptor : NSObject {
    
    
    
    
    // constraints
    NSArray* _constraints;
    //@property (nonatomic, retain) NSArray* constraints;
    //@synthesize constraints = _constraints;

    
    // indexes
	NSArray* _indexes;
	//@property (nonatomic, retain) NSArray* indexes;
	//@synthesize indexes = _indexes;

    // name
	NSString* _name;
	//@property (nonatomic, retain) NSString* name;
	//@synthesize name = _name;

    // properties
	NSArray* _properties;
	//@property (nonatomic, retain) NSArray* properties;
	//@synthesize properties = _properties;
    

}


#pragma mark instance lifecycle


-(id)initWithName:(NSString*)name;

#pragma mark fields


// constraints
//NSArray* _constraints;
@property (nonatomic, retain) NSArray* constraints;
//@synthesize constraints = _constraints;

// name
//NSString* _name;
@property (nonatomic, retain) NSString* name;
//@synthesize name = _name;

// indexes
//NSArray* _indexes;
@property (nonatomic, retain) NSArray* indexes;
//@synthesize indexes = _indexes;


// properties
//NSArray* _properties;
@property (nonatomic, retain) NSArray* properties;
//@synthesize properties = _properties;


@end
