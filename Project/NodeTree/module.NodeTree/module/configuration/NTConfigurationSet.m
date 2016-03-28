//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CAFolderUtilities.h"
#import "CALog.h"

#import "NTConfiguration.h"
#import "NTConfigurationSet.h"
#import "NTNodeTree.h"
#import "NTNodeContext.h"
#import "NTNodeTreeSchema.h"


@implementation NTConfigurationSet {
    
    
    NTNodeContext* _context;
    NTNodeTree* _nodeTree;
    
}


-(instancetype)init {
    
    self = [super init];
    
    if( self ) {
        
        NSString* databasePath = [NTConfigurationSet DATABASE_PATH];
        [NTNodeTreeSchema buildSchema:databasePath];
        _nodeTree = [[NTNodeTree alloc] initWithDatabasePath:databasePath];
        _context = [_nodeTree openContext];
    
    }
    return self;
    

}

-(void)dealloc {
    
    [_nodeTree closeContext:_context];
    
}


#pragma mark - 


+(NSString*)DATABASE_PATH {
 
    
    NSString* directory = [CAFolderUtilities getApplicationSupportDirectory];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    directory = [NSString stringWithFormat:@"%@/%@", directory, bundleIdentifier];
    [CAFolderUtilities mkdirs:directory];
    
    Log_debugString( directory );

#ifdef DEBUG
    
    directory = @"/tmp";
    
#endif
    
    NSString* answer = [NSString stringWithFormat:@"%@/NTConfigurationSet.%@.db", directory, [NTNodeTree databaseVersion] ];
    
    Log_debugString( answer );
    return answer;
    
}


- (NTConfiguration*)getConfigurationWithName:(NSString*)name;
{
    
    NTConfiguration* answer = [[NTConfiguration alloc] initWith:_context name:name];
    return answer;
    
}





@end
