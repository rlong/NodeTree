//
//  NDColumnDescriptor.h
//  prototype
//
//  Created by rlong on 29/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTColumnDescriptor : NSObject {
    
    // name
	NSString* _name;
	//@property (nonatomic, retain) NSString* name;
	//@synthesize name = _name;
    
    // properties
	NSString* _properties;
	//@property (nonatomic, retain) NSString* properties;
	//@synthesize properties = _properties;


}

-(NSString*)toString;

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithName:(NSString*)name properties:(NSString*)properties;


#pragma mark -
#pragma mark fields

// name
//NSString* _name;
@property (nonatomic, retain) NSString* name;
//@synthesize name = _name;


// properties
//NSString* _properties;
@property (nonatomic, retain) NSString* properties;
//@synthesize properties = _properties;

@end
