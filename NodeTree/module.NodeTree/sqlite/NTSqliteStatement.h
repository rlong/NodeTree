//
//  XPSqlLiteStatement.h
//  vlc_amigo
//
//  Created by rlong on 5/05/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NTSqliteStatement : NSObject {
    
    

    sqlite3_stmt *_statement;
    
}

-(void)bindDouble:(double)value atIndex:(int)index;
-(void)bindInt:(int)value atIndex:(int)index;
-(void)bindInt64:(sqlite3_int64)value atIndex:(int)index;
-(void)bindText:(NSString*)text atIndex:(int)index;

-(void)finalize;

-(long long)getInt64AtColumn:(int)columnIndex;

- (NSNumber*)getNumberAtColumn:(int)columnIndex defaultTo:(NSNumber*)defaultValue;

- (NSString*)getStringAtColumn:(int)columnIndex defaultTo:(NSString*)defaultValue;

-(NSString*)getTextAtColumn:(int)columnIndex;

-(int)step;

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithStatement:(sqlite3_stmt*)statement;

@end
