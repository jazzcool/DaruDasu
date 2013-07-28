//
//  CacheManager.h
//  
//
//  Created by subhash on 16/05/10.
//  Copyright 2009 Office. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface CacheManager : NSObject {
	sqlite3 *database;
	NSString *dbName;
	NSString *DBPath;
}
-(BOOL)openConnection;
-(void)initilize;
-(NSInteger) cacheSize;
-(void)deleteCacheDataForKey:(NSString*)key;
-(void)emptyCache;
-(void)vacuumData;
-(NSDate *)lastUpdateDateForKey:(NSString *)key;
-(BOOL)doesDataExistForKey:(NSString *)key;
-(void)setData:(NSData *)data forKey:(NSString *)key;
-(void)updateData:(NSData *)data forKey:(NSString *)key;
-(void)insertData:(NSData *)data forKey:(NSString *)key;
-(NSData *)getDataForKey:(NSString *)key;
-(void)setArray:(NSMutableArray *)array forKey:(NSString *)key;
-(NSMutableArray *)getArray:(NSString *)key;
-(void)setArrayInArray:(NSMutableArray *)array forKey:(NSString *)key;
-(void)setDictionary:(NSMutableDictionary *)dic forKey:(NSString *)key;
-(NSMutableDictionary *)getDictionary:(NSString *)key;
	
@end
