//
//  XPSqlLiteNodeSchema.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//



#import "CAColumnDescriptor.h"
#import "CASchemaManager.h"
#import "NTNodeTreeSchema.h"
#import "CASqliteConnection.h"
#import "CATableDescriptor.h"


@implementation NTNodeTreeSchema

static CATableDescriptor* TABLES[] = { NULL, NULL, NULL };

+(void)initialize {
    
    
    {
        CATableDescriptor* node = [[CATableDescriptor alloc] initWithName:@"node"];
        TABLES[0] = node; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            CAColumnDescriptor* columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"pk" properties:@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"parent_pk" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"parent_pk_path" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"type_id" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            // ---------------------------------------------------------

            [node setProperties:properties];
        }
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"CONSTRAINT node_edge_constraint UNIQUE( parent_pk, edge_name, edge_index) on conflict abort"];
            
            [node setConstraints:constaints];
        }
        
        

        NSMutableArray* indexes = [[NSMutableArray alloc] init];
        {
            [indexes addObject:@"CREATE INDEX if not exists node_parent_pk_path ON node ( parent_pk_path );"];
            [node setIndexes:indexes];
        }
        
    }
    
    {
        CATableDescriptor* nodeProperty = [[CATableDescriptor alloc] initWithName:@"node_property"];
        TABLES[1] = nodeProperty; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            
            CAColumnDescriptor* columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"node_pk" properties:@"INTEGER NOT NULL"];
            [properties addObject:columnDescriptor];
            

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];
            
            
            // ---------------------------------------------------------
            
            
            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"blob_value" properties:@"BLOB"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"boolean_value" properties:@"BOOLEAN"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"integer_value" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"real_value" properties:@"REAL"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[CAColumnDescriptor alloc] initWithName:@"string_value" properties:@"TEXT"];
            [properties addObject:columnDescriptor];


            [nodeProperty setProperties:properties];
        }
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"PRIMARY KEY ( node_pk, edge_name, edge_index) on conflict abort"];
            
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
