//
//  XPSqlLiteNodeSchema.m
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import "JBMemoryModel.h"


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
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"parent_pk" properties:@"INTEGER"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"parent_pk_path" properties:@"TEXT"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"type_id" properties:@"INTEGER"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            // ---------------------------------------------------------

            [node setProperties:properties];
        }
        JBRelease( properties );
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"CONSTRAINT node_edge_constraint UNIQUE( parent_pk, edge_name, edge_index) on conflict abort"];
            
            [node setConstraints:constaints];
        }
        JBRelease( constaints );
        
        

        NSMutableArray* indexes = [[NSMutableArray alloc] init];
        {
            [indexes addObject:@"CREATE INDEX if not exists node_parent_pk_path ON node ( parent_pk_path );"];
            [node setIndexes:indexes];
        }
        JBRelease( indexes );
        
    }
    
    {
        NTTableDescriptor* nodeProperty = [[NTTableDescriptor alloc] initWithName:@"node_property"];
        TABLES[1] = nodeProperty; // no need to release the `node`
        
        NSMutableArray* properties = [[NSMutableArray alloc] init];
        {
            
            NTColumnDescriptor* columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"node_pk" properties:@"INTEGER NOT NULL"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];
            

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_name" properties:@"TEXT"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"edge_index" properties:@"INTEGER"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];
            
            
            // ---------------------------------------------------------
            
            
            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"blob_value" properties:@"BLOB"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"boolean_value" properties:@"BOOLEAN"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"integer_value" properties:@"INTEGER"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"real_value" properties:@"REAL"];
            JBAutorelease( columnDescriptor );
            [properties addObject:columnDescriptor];

            columnDescriptor = [[NTColumnDescriptor alloc] initWithName:@"string_value" properties:@"TEXT"];
            [properties addObject:columnDescriptor];


            [nodeProperty setProperties:properties];
        }
        JBRelease( properties );
        
        
        NSMutableArray* constaints = [[NSMutableArray alloc] init];
        {
            [constaints addObject:@"PRIMARY KEY ( node_pk, edge_name, edge_index) on conflict abort"];
            
            [nodeProperty setConstraints:constaints];
        }
        JBRelease( constaints );

        
        
        NSMutableArray* indexes = [[NSMutableArray alloc] init];
        {
            
            [nodeProperty setIndexes:indexes];
        }
        JBRelease( indexes );
        
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
