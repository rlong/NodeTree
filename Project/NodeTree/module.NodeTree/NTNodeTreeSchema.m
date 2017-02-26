//  https://github.com/rlong/cocoa.lib.NodeTree
//
//  Copyright (c) 2015 Richard Long
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAColumnDescriptor.h"
#import "CASchemaManager.h"
#import "CASqliteConnection.h"
#import "CATableDescriptor.h"

#import "NTNodeTreeSchema.h"


@implementation NTNodeTreeSchema

static CATableDescriptor* TABLES[] = { NULL, NULL, NULL };

+(void)initialize {
    
    
    {
        CATableDescriptor* node = [[CATableDescriptor alloc] initWithName:@"node"];
        TABLES[0] = node; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            CAColumnDescriptor* columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"NodeId" properties:@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"ParentId" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"ParentPath" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"EdgeName" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"EdgeIndex" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"Tag" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            // ---------------------------------------------------------

            [node setProperties:properties];
        }
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"CONSTRAINT node_edge_constraint UNIQUE( ParentId, EdgeName, EdgeIndex) on conflict abort"];
            
            [node setConstraints:constaints];
        }
        
        

        NSMutableArray* indexes = [[NSMutableArray alloc] init];
        {
            [indexes addObject:@"CREATE INDEX if not exists node_ParentPath ON node ( ParentPath );"];
            [node setIndexes:indexes];
        }
        
    }
    
    {
        CATableDescriptor* nodeProperty = [[CATableDescriptor alloc] initWithName:@"NodeProperty"];
        TABLES[1] = nodeProperty; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            
            CAColumnDescriptor* columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"NodeId" properties:@"INTEGER NOT NULL"];
            [properties addObject:columnDescriptor];
            

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"EdgeName" properties:@"TEXT"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"EdgeIndex" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];
            
            
            // ---------------------------------------------------------
            
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"BlobValue" properties:@"BLOB"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"BooleanValue" properties:@"BOOLEAN"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"IntegerValue" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"RealValue" properties:@"REAL"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"TextValue" properties:@"TEXT"];
            [properties addObject:columnDescriptor];


            [nodeProperty setProperties:properties];
        }
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"PRIMARY KEY ( NodeId, EdgeName, EdgeIndex) on conflict abort"];
            
            [nodeProperty setConstraints:constaints];
        }

        
        NSMutableArray* indexes = [[NSMutableArray alloc] init];
        {
            
            [nodeProperty setIndexes:indexes];
        }
        
    }
	
}

+(void)buildSchema:(NSString*)databasePath {
    
    CASqliteConnection* connection = [CASqliteConnection open:databasePath];
    {
        [CASchemaManager buildTables:connection tables:TABLES];
    }
    [connection close];
}

+(void)dropSchema:(NSString*)databasePath {
    
    CASqliteConnection* connection = [CASqliteConnection open:databasePath];
    {
        [CASchemaManager dropTables:connection tables:TABLES];
    }
    [connection close];
}



@end
