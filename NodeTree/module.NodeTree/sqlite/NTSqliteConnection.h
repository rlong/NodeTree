//
//  XPSqliteConnection.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@class NTSqliteStatement;

@interface NTSqliteConnection : NSObject {
    
    sqlite3* _connection;

}

-(void)begin;
-(void)close;
-(void)commit;
-(void)exec:(NSString*)statement;
-(long long)last_insert_rowid;
+(NTSqliteConnection*)open:(NSString*)filename;

-(NTSqliteStatement*)prepare:(NSString*)sql;

@end
