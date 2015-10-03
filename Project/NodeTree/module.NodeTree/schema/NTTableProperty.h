//
//  NDTableProperty.h
//  prototype
//
//  Created by rlong on 28/11/12.
//  Copyright (c) 2012 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTTableProperty : NSObject  {
    
    // property
	NSString* _property;
	//@property (nonatomic, retain) NSString* property;
	//@synthesize property = _property;
    
    
}



-(NSString*)toString;


#pragma mark fields



// property
//NSString* _property;
@property (nonatomic, retain) NSString* property;
//@synthesize property = _property;




@end
