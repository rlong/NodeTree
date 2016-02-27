//
//  XPSqlLiteNodeSchema.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import <Foundation/Foundation.h>


@interface NTNodeTreeSchema : NSObject

+(void)buildSchema:(NSString*)databasePath;
+(void)dropSchema:(NSString*)databasePath;

@end
