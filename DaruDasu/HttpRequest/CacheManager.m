//
//  CacheManager.m
//  Created by subhash on 16/05/10.
//  Copyright 2010 Office. All rights reserved.
//

#import "CacheManager.h"


@implementation CacheManager

-(BOOL)openConnection
{
	dbName=@"HTTPREQUESTCACHEDATA.sqlite";
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths safeObjectAtIndex:0];
	NSString *path=[documentsDirectory stringByAppendingPathComponent:dbName];
	if(sqlite3_open([path UTF8String],&database)==SQLITE_OK)
		return TRUE;
	else
		return FALSE;
}

-(void)initilize
{
	dbName=@"HTTPREQUESTCACHEDATA.sqlite";
	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths safeObjectAtIndex:0];
    DBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:DBPath];
    if (success)
	{
		return;
    }
	// The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:DBPath error:&error];
	if(!success){
		NSAssert1(0,@"Failed to create writable database file with massage '%@'.",[error localizedDescription]);
}
}
	
-(NSInteger) cacheSize
{
//	return [[[[NSFileManager defaultManager] attributesOfItemAtPath:DBPath error:nil]objectForKey:NSFileSize]intValue];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths safeObjectAtIndex:0];
    DBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
	
	NSFileManager *fileManager =	[NSFileManager defaultManager];
	NSDictionary *disc=[fileManager attributesOfItemAtPath:DBPath error:nil];
	NSInteger fileSize=[[disc objectForKey:NSFileSize]intValue];
	return fileSize;
}

-(void)deleteCacheDataForKey:(NSString*)key
{
	/*
	sqlite3_stmt *deleteStmt;
		const char *sql = "delete from cache where attributes = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSLog(@"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	
	if(key != nil)
		sqlite3_bind_text(deleteStmt, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(deleteStmt, 1, nil, -1, SQLITE_TRANSIENT);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSLog( @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
	[self vacuumData];
	 */
	
	if([self openConnection])
	{
		const char *sql = "delete from cache where attributes = ?";	
		
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){
			
			if(key != nil)
				sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 1, nil, -1, SQLITE_TRANSIENT);
			
			int success = sqlite3_step(statement);
			
			sqlite3_reset(statement);
			if (success == SQLITE_ERROR) {
				NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			}			
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
}
	
	
	
	 
	 
	
-(void)emptyCache
{
	/*
	
	sqlite3_stmt *deleteStmt;
		const char *sql = "delete from cache;";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSLog(@"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSLog( @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
	[self vacuumData];
	 */
	
	if([self openConnection])
	{
		const char *sql = "delete from cache;";
		
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){
			
			int success = sqlite3_step(statement);
			
			sqlite3_reset(statement);
			if (success == SQLITE_ERROR) {
				NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			}			
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

////internal function/////
-(void)vacuumData
{
	sqlite3_stmt *vacuumStmt;
	const char *sql = "vacuum;";
	if(sqlite3_prepare_v2(database, sql, -1, &vacuumStmt, NULL) != SQLITE_OK)
		NSLog(@"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	if (SQLITE_DONE != sqlite3_step(vacuumStmt))
		NSLog( @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(vacuumStmt);
}
/////internal function
- (NSDate*)convertToGMT:(NSDate*)sourceDate
{
    NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone* utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval gmtInterval = gmtOffset - currentGMTOffset;
	
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:sourceDate] autorelease];     
    return destinationDate;
}

-(NSDate *)lastUpdateDateForKey:(NSString *)key
{
	/*
	sqlite3_stmt *detailStmt;
	const char *sql = "Select updationTime from cache Where attributes = ?";
	if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
		NSLog(@"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	
	if(key != nil)
		sqlite3_bind_text(detailStmt, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(detailStmt, 1, nil, -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
			
	
		NSDate *updationTime = [NSDate dateWithTimeIntervalSinceNow:sqlite3_column_double(detailStmt, 0)];
		updationTime=[updationTime dateByAddingTimeInterval:-1*[updationTime timeIntervalSinceNow]];
		updationTime=[self convertToGMT:updationTime];
		sqlite3_reset(detailStmt);
		return updationTime;
	}
	else
	{
		sqlite3_reset(detailStmt);
		return nil;
	}
	 */
	
	NSDate *updationTime=nil;
	if([self openConnection])	{
		
		const char *sql = "Select updationTime from cache Where attributes = ?";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){			
			
			if(key != nil)
				sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 1, nil, -1, SQLITE_TRANSIENT);
			
			if(sqlite3_step(statement)==SQLITE_ROW) {
				
				
				updationTime = [NSDate dateWithTimeIntervalSinceNow:sqlite3_column_double(statement, 0)];
				updationTime=[updationTime dateByAddingTimeInterval:-1*[updationTime timeIntervalSinceNow]];
				updationTime=[self convertToGMT:updationTime];
			}				
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	return updationTime;	
	
}



-(BOOL)doesDataExistForKey:(NSString *)key
{
	/*
	const char *sql = "Select data from cache Where attributes = ?";
	sqlite3_stmt *detailStmt;
	if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
		NSLog(@"Error while creating statement. '%s'", sqlite3_errmsg(database));
	
	if(key != nil)
		sqlite3_bind_text(detailStmt, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(detailStmt, 1, nil, -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		sqlite3_reset(detailStmt);
		return TRUE;
	}
	else
	{	
		sqlite3_reset(detailStmt);
		return FALSE;
	}	
	 */
	BOOL isIssueExist=FALSE;
	if([self openConnection])
	{
		const char *sql = "Select data from cache Where attributes = ?";
		sqlite3_stmt *statement;
	
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){
			
			if(key != nil)
				sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 1, nil, -1, SQLITE_TRANSIENT);
			
			if (sqlite3_step(statement)==SQLITE_ROW){
				isIssueExist=TRUE;				
			}			
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	return isIssueExist;
}


-(void)setDictionary:(NSMutableDictionary *)dic forKey:(NSString *)key
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[self setData:data forKey:key];	
}

-(NSMutableDictionary *)getDictionary:(NSString *)key
{
	NSData *data=[self getDataForKey:key];	
	return  [NSKeyedUnarchiver unarchiveObjectWithData:data];;
}


-(void)setArrayInArray:(NSMutableArray *)array forKey:(NSString *)key
{	
	if([self getArray:key]!=nil)
		[array addObjectsFromArray:[self getArray:key]];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	[self setData:data forKey:key];	
}

-(void)setArray:(NSMutableArray *)array forKey:(NSString *)key
{

	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	[self setData:data forKey:key];	
}

-(NSMutableArray *)getArray:(NSString *)key
{

	NSData *arrayData=[self getDataForKey:key];	
	return  [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];;
}

-(void)setData:(NSData *)data forKey:(NSString *)key
{
	if([self doesDataExistForKey:key])
		[self updateData:data forKey:key];
	else 
		[self insertData:data forKey:key];
	//[self vacuumData];
}
-(void)updateData:(NSData *)data forKey:(NSString *)key
{
	/*
	sqlite3_stmt *updateStmt;
		const char *sql = "update cache Set data = ? Where attributes = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
			NSLog(@"Error while creating statement. '%s'", sqlite3_errmsg(database));
	
	if(data != nil)
		sqlite3_bind_blob(updateStmt, 1, [data bytes], [data length], NULL);
	else
		sqlite3_bind_blob(updateStmt, 1, nil, -1, NULL);
	
	if(key != nil)
		sqlite3_bind_text(updateStmt, 2, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(updateStmt, 2, nil, -1, SQLITE_TRANSIENT);
	
	
		
	if(SQLITE_DONE != sqlite3_step(updateStmt))
		NSLog(@"Error while updating the data. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(updateStmt);
	[self vacuumData];
	 */
	
	if([self openConnection])
	{
		const char *sql = "update cache Set data = ? Where attributes = ?";
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){
			
			if(data != nil)
				sqlite3_bind_blob(statement, 1, [data bytes], [data length], NULL);
			else
				sqlite3_bind_blob(statement, 1, nil, -1, NULL);
			
			if(key != nil)
				sqlite3_bind_text(statement, 2, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 2, nil, -1, SQLITE_TRANSIENT);
			
			
			int success = sqlite3_step(statement);
			
			sqlite3_reset(statement);
			if (success == SQLITE_ERROR) {
				NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			}			
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
	
}
-(void)insertData:(NSData *)data forKey:(NSString *)key
{
	/*
	sqlite3_stmt *addStmt;

	const char *sql = "insert into cache(attributes, data) Values(?, ?)";
	if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
		NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	
	if(data != nil)
		sqlite3_bind_blob(addStmt, 2, [data bytes], [data length], NULL);
	else
		sqlite3_bind_blob(addStmt, 2, nil, -1, NULL);
	
	if(key != nil)
		sqlite3_bind_text(addStmt, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(addStmt, 1, nil, -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSLog( @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	sqlite3_reset(addStmt);
	[self vacuumData];
	 */
	
	if([self openConnection])
	{
		const char *sql = "insert into cache(attributes, data) Values(?, ?)";
		
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){
			
			
			if(data != nil)
				sqlite3_bind_blob(statement, 2, [data bytes], [data length], NULL);
			else
				sqlite3_bind_blob(statement, 2, nil, -1, NULL);
			
			if(key != nil)
				sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 1, nil, -1, SQLITE_TRANSIENT);
			
			int success = sqlite3_step(statement);
			
			sqlite3_reset(statement);
			if (success == SQLITE_ERROR) {
				NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
			}			
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

-(NSData *)getDataForKey:(NSString *)key
{
	/*
	sqlite3_stmt *detailStmt;
	const char *sql = "Select data from cache Where attributes = ?";
	if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
		NSLog(@"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	
	if(key != nil)
		sqlite3_bind_text(detailStmt, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_text(detailStmt, 1, nil, -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		NSData *data = [[[NSData alloc] initWithBytes:sqlite3_column_blob(detailStmt, 0) length:sqlite3_column_bytes(detailStmt, 0)]autorelease];
		sqlite3_reset(detailStmt);
		
		return data;
	}
	else
	{
		sqlite3_reset(detailStmt);
		return nil;
	}
	//Reset the detail statement.
	*/
	
	NSData *data=nil;
	if([self openConnection])
	{
		
		const char *sql = "Select data from cache Where attributes = ?";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK){			
			
			if(key != nil)
				sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
			else
				sqlite3_bind_text(statement, 1, nil, -1, SQLITE_TRANSIENT);
			
			if(sqlite3_step(statement)==SQLITE_ROW)
			{
			 data = [[[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_bytes(statement, 0)]autorelease];

			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
		return data;
}

@end
