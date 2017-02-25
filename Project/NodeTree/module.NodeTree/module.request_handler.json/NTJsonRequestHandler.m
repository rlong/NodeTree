//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2017 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CABaseException.h"
#import "CALog.h"
#import "CAJsonDataInput.h"
#import "CAJsonObject.h"
#import "CAJsonObjectHandler.h"

#import "HLEntityHelper.h"
#import "HLHttpMethod.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLRequestHandler.h"


#import "NTJSONWriter.h"
#import "NTNodeTree.h"
#import "NTNodeContext.h"


#import "NTJsonRequestHandler.h"


@implementation NTJsonRequestHandler

static int _MAXIMUM_REQUEST_ENTITY_LENGTH = (32 * 1024);

NTNodeTree* _nodeTree;
NTNodeContext* _nodeContext;



#pragma mark - instance lifecycle

-(instancetype)init {
    
    self = [super init];
    
    if( self ) {
        
        _nodeTree = [[NTNodeTree alloc] initWithDatabasePath:@"/tmp/NTJsonRequestHandler.db"];
        _nodeContext = [_nodeTree openContext];
    }
    
    return self;
}


#pragma mark - <HLRequestHandler> implementation


-(NSString*)getProcessorUri {
    
    return @"/NTJsonRequestHandler";
    
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    
    if( [HLHttpMethod POST] != [request method] ) {
        Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    id<HLEntity> entity = [request entity];
    
    if( _MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength] ) {
        Log_errorFormat( @"_MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength]; _MAXIMUM_REQUEST_ENTITY_LENGTH = %d; [entity getContentLength] = %d", _MAXIMUM_REQUEST_ENTITY_LENGTH, [entity getContentLength]);
        @throw  [HLHttpErrorHelper requestEntityTooLarge413FromOriginator:self line:__LINE__];
    }
    
    
    NSData* jsonData = [HLEntityHelper toData:entity];
    Log_debugData( jsonData );
    
//    NSJSONReadingOptions options = NSJSONReadingMutableContainers;
    NSJSONReadingOptions options = 0;
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
    
    Log_debugPointer( (void*)json );
    Log_debugPointer( (void*)json );
    Log_debugPointer( (void*)json );
    if( nil != error ) {
        
        Log_errorError( error );
        @throw  [HLHttpErrorHelper internalServerError500FromOriginator:self line:__LINE__];
    }

    [_nodeContext begin];
    {
        NSString* requestUri = [request requestUri];
        Log_debugString( requestUri );
        
        NTNode* rootNode = [_nodeContext addRootWithKey:requestUri];
        [NTJSONWriter addJSONDictionary:json toNode:rootNode];
    }
    [_nodeContext commit];
    
    return [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200];

}



@end
