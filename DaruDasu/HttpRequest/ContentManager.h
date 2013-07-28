//
//  ContentManager.h
//
//  Created by Subhash chand on 17/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CacheManager.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

#import "RequestData.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
//#import "ASINSStringAdditions.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"


@interface ContentManager : NSObject {

	CacheManager *cacheManager;
     //NSMutableData *responseData;
}
@property(nonatomic,retain) CacheManager *cacheManager;

+ (ContentManager *)sharedInstance;
+(id)alloc;
-(void)initilize;
-(void)hideLoader:(NSTimer *)timer;
-(void)showLoader:(NSTimer *)timer;
- (void)getContentForRequestObject:(RequestData *)requestData;
-(void)checkAllFilesExistsFromNSDictionary:(NSDictionary *)dict;
-(void)doesFileExistsAtPath:(NSString*)path;
-(void)validateRequestData:(RequestData *)requestData;
-(void)getDataFromCacheForRequestObject:(RequestData *)requestData;
-(void)getDataForResponseObjectUsingPut:(RequestData *)requestData;
-(void)getDataForResponseObjectUsingPost:(RequestData *)requestData;
-(void)getDataForResponseObjectUsingGet:(RequestData *)requestData;
-(NSURL *)createURLUsingRequestDataObject:(RequestData *)requestData;
-(NSString *) createKeyUsingNSDictionary:(NSDictionary *)dict;
- (void)requestFinished:(ASIHTTPRequest *)request;
-(void)processResponseReceivedFromServer:(ASIHTTPRequest *)request;
-(void)respondeToCaller:(NSMutableDictionary *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
-(NSString *)createKeyUsingRequestData :(RequestData *)requestData;

@end
