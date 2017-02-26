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

#import "HLDataEntity.h"
#import "HLEntityHelper.h"
#import "HLHttpMethod.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLRequestHandler.h"


#import "NTJSONWriter.h"
#import "NTJSONReader.h"
#import "NTNode.h"
#import "NTNodeContext.h"
#import "NTNodeTree.h"
#import "NTNodeTreeReader.h"



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

-(HLHttpResponse*)processGet:(HLHttpRequest*)request {



    HLDataEntity* dataEntity;
    [_nodeContext begin];
    {
        NSString* rootKey = [request requestUri];
        Log_debugString( rootKey );
        NTNode* rootNode = [_nodeContext getRootWithKey:rootKey createIfNeeded:false];
        
        // bad name ...
        if( nil == rootNode ) {
            
            Log_errorFormat( @"nil == rootNode; rootKey = '%@'", rootKey );
            @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
        }
        
        NTJSONReader* delegate = [[NTJSONReader alloc] init];
        [NTNodeTreeReader readFromRoot:rootNode delegate:delegate];
        NSMutableDictionary* rootDictionary = [delegate rootDictionary];
        
        NSJSONWritingOptions options = 0;
        NSError* error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:rootDictionary options:options error:&error];
        
        if( nil != error ) {
            
            Log_errorError( error );
            @throw  [HLHttpErrorHelper internalServerError500FromOriginator:self line:__LINE__];
        }

        dataEntity = [[HLDataEntity alloc] initWithData:data];
    }
    [_nodeContext commit];
    
    return [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:dataEntity];
    

}


-(HLHttpResponse*)processPost:(HLHttpRequest*)request {
    
    id<HLEntity> entity = [request entity];
    
    if( _MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength] ) {
        Log_errorFormat( @"_MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength]; _MAXIMUM_REQUEST_ENTITY_LENGTH = %d; [entity getContentLength] = %d", _MAXIMUM_REQUEST_ENTITY_LENGTH, [entity getContentLength]);
        @throw  [HLHttpErrorHelper requestEntityTooLarge413FromOriginator:self line:__LINE__];
    }
    
    
    NSData* jsonData = [HLEntityHelper toData:entity];
    Log_debugData( jsonData );
    
    NSJSONReadingOptions options = 0;
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:options error:&error];
    
    if( nil != error ) {
        
        Log_errorError( error );
        @throw  [HLHttpErrorHelper internalServerError500FromOriginator:self line:__LINE__];
    }
    
    [_nodeContext begin];
    {
        NSString* rootKey = [request requestUri];
        Log_debugString( rootKey );
        
        NTNode* rootNode = [_nodeContext getRootWithKey:rootKey createIfNeeded:false];
        
        // remove the old ...
        if( nil != rootNode ) {
            [rootNode remove];
        }
        
        rootNode = [_nodeContext addRootWithKey:rootKey];
        [NTJSONWriter addJSONDictionary:json toNode:rootNode];
    }
    [_nodeContext commit];
    
    return [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200];

}


-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    if( [HLHttpMethod GET] == [request method] ) {
        return [self processGet:request];
    }
    
    if( [HLHttpMethod POST] == [request method] ) {
        return [self processPost:request];
    }

    Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
    @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];

}



@end
