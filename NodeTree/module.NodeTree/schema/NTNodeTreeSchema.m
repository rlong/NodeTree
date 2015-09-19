//
//  XPSqlLiteNodeSchema.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//



#import "NTColumnDescriptor.h"
#import "NTSchemaManager.h"
#import "NTNodeTreeSchema.h"
#import "NTSqliteConnection.h"
#import "NTTableDescriptor.h"


@implementation NTNodeTreeSchema

static NTTableDescriptor* TABLES[] = { NULL, NULL, NULL };

+(void)initialize {
    
    
    {
        NTTableDescriptor* node = [[NTTableDescriptor alloc] initWithName:@"node"];
        TABLES[0] = node; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            NTColumnDescriptor* columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"pk" properties:@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"parent_pk" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"parent_pk_path" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"type_id" properties:@"INTEGER"];
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
        NTTableDescriptor* nodeProperty = [[NTTableDescriptor alloc] initWithName:@"node_property"];
        TABLES[1] = nodeProperty; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            
            NTColumnDescriptor* columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"node_pk" properties:@"INTEGER NOT NULL"];
            [properties addObject:columnDescriptor];
            

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];
            
            
            // ---------------------------------------------------------
            
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"blob_value" properties:@"BLOB"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"boolean_value" properties:@"BOOLEAN"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"integer_value" properties:@"INTEGER"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"real_value" properties:@"REAL"];
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"string_value" properties:@"TEXT"];
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
    
    NTSqliteConnection* connection = [NTSqliteConnection open:databasePath];
    {
        [NTSchemaManager buildTables:connection tables:TABLES];
    }
    [connection close];
}

+(void)dropSchema:(NSString*)databasePath {
    
    NTSqliteConnection* connection = [NTSqliteConnection open:databasePath];
    {
        [NTSchemaManager dropTables:connection tables:TABLES];
    }
    [connection close];
}



@end
