//
//  ContentManager.m
//
//  Created by Subhash chand on 17/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ContentManager.h"

@implementation ContentManager

@synthesize cacheManager;

static ContentManager *sharedInstance;

+ (ContentManager *)sharedInstance {
    @synchronized(self) {
        if (!sharedInstance)
			[[ContentManager alloc] initilize];              
    }
    return sharedInstance;
}

+(id)alloc {
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

-(void)initilize
{
	cacheManager=[CacheManager alloc];
	[cacheManager initilize];
}


///internal
-(void)showLoader:(NSTimer *)timer
{
}


//internal
-(void)hideLoader:(NSTimer *)timer
{
	[[timer userInfo] removeFromSuperview];
}


- (void)getContentForRequestObject:(RequestData *)requestData
{
    if(requestData.putData.length>0){
    
        [self getDataForResponseObjectUsingJsonPutData:requestData];
        return;
    }
    
    
	NSLog(@"%@->Enter->getContentForRequestObject %@",self,requestData.baseURL);

	[self validateRequestData:requestData];

	if(requestData.showLoader)
	{
		[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self  selector: @selector(showLoader:) userInfo:requestData.loaderView repeats: NO];
	}
	
	NSString *attributeStr=[self createKeyUsingRequestData:requestData];
	
	if(requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_UPDATE_CACHE_IN_BACKGROUND || requestData.requestSourceType == REQUEST_DATA_FROM_URL || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_URL || requestData.requestSourceType == REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE|| (![cacheManager doesDataExistForKey:attributeStr] && requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_IF_FAIL_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE))
	{
		if(requestData.requestType == REQUEST_TYPE_GET)
			[self getDataForResponseObjectUsingGet:requestData];
		else if(requestData.requestType == REQUEST_TYPE_POST)
			[self getDataForResponseObjectUsingPost:requestData];
		else if(requestData.requestType == REQUEST_TYPE_PUT)
			[self getDataForResponseObjectUsingPut:requestData];
	}
    
	if(requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_UPDATE_CACHE_IN_BACKGROUND || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_URL  || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_IF_FAIL_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE)
	{
		[self getDataFromCacheForRequestObject:requestData];
	}
	//NSLog(@"getContentForRequestObject -> [requestData retainCount] %d",[requestData retainCount]);

}

-(void)getDataFromCacheForRequestObject:(RequestData *)requestData
{
	requestData.responseType=RESPONSE_DATA_TYPE_CACHE;
	NSString *attributeStr=[self createKeyUsingRequestData:requestData];
	
	NSData *responseData=[cacheManager getDataForKey:attributeStr];
	if(responseData == nil)
	{
		requestData.wasCashedDataReturned=FALSE;
		if((requestData.requestSourceType == REQUEST_DATA_FROM_CACHE ) && requestData.showLoader)
		{
			[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self  selector: @selector(hideLoader:) userInfo:requestData.loaderView repeats: NO];
		}
		return;
	}
	
	NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];	
	NSMutableDictionary *responseDataObj=[[NSMutableDictionary alloc]init];
	[responseDataObj setObject:requestData forKey:@"reqMetaData"];
	[responseDataObj setObject:responseString forKey:@"responseString"];
	[responseDataObj setObject:responseData forKey:@"responseData"];
	
	[self respondeToCaller:responseDataObj];
	[responseString release];
	[responseDataObj release];//Surinder
	if((requestData.requestSourceType!=REQUEST_DATA_FROM_CACHE_AND_URL ) && requestData.showLoader)
	{
		[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self  selector: @selector(hideLoader:) userInfo:requestData.loaderView repeats: NO];
	}
	
	//if ([requestData retainCount] > 1) {//Surinder
//		[requestData release];//Surinder
//	}
	
     // [responseDataObj release];//Surinder
	//[requestData release];
}

-(void)validateRequestData:(RequestData *)requestData
{
	if(requestData.sender == nil)
		NSLog(@"Sender is not set");
	[self checkAllFilesExistsFromNSDictionary:requestData.files];
}
-(void)checkAllFilesExistsFromNSDictionary:(NSDictionary *)dict
{
	for (NSString *key in [dict allKeys])
	{
        NSString *path = [dict valueForKey:key];
		[self doesFileExistsAtPath:path];
	}
	
}


-(void)doesFileExistsAtPath:(NSString*)path
{
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if(!fileExists)
		NSLog(@"Missing file at path %@",path);
}


-(void)getDataForResponseObjectUsingPut:(RequestData *)requestData
{
	NSURL *url=[self createURLUsingRequestDataObject:requestData];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setReqMetaData:requestData];
    
    [request setTimeOutSeconds:180];
	[request appendPostData:[requestData.putData dataUsingEncoding:NSUTF8StringEncoding]];
	[request setRequestMethod:@"PUT"];
    [request setValidatesSecureCertificate:YES];
    //request.shouldAttemptPersistentConnection=NO;
	
	ASINetworkQueue *queue=[[ASINetworkQueue alloc] init];
	[queue setDelegate:self];
	[queue setRequestDidFinishSelector:@selector(requestFinished:)];
	[queue setRequestDidFailSelector:@selector(requestFailed:)];
	
	[queue addOperation:request]; 
	[queue go];
}

-(void)getDataForResponseObjectUsingJsonPutData:(RequestData *)requestData
{
    NSData *requestData2 = [NSData dataWithBytes:[requestData.putData UTF8String] length:[requestData.putData length]];
    //NSURL *url2 = [NSURL URLWithString:@"http://xml-test.secure-reservation.com/rezwsr/json/services/ReservationService"];
	NSURL *url=[self createURLUsingRequestDataObject:requestData];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:180];
	[request setReqMetaData:requestData];
	[request appendPostData:[requestData.putData dataUsingEncoding:NSUTF8StringEncoding]];
    request.shouldAttemptPersistentConnection=NO;
	[request setRequestMethod:@"POST"];
    [request setValidatesSecureCertificate:YES];
    
    [request addRequestHeader:@"Accept" value:@"application/json"];
     [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [requestData2 length]]];
    
    if(requestData.isNeedKeyForQueryString)
    {
       [request addRequestHeader:requestData.key value:requestData.putData];
    }
    else
      [request addRequestHeader:@"Query-string" value:requestData.putData];
    [request setPostBody:(NSMutableData*)requestData2];
	
	ASINetworkQueue *queue=[[ASINetworkQueue alloc] init];
	[queue setDelegate:self];
	[queue setRequestDidFinishSelector:@selector(requestFinished:)];
	[queue setRequestDidFailSelector:@selector(requestFailed:)];
	
	[queue addOperation:request];
	[queue go];
    /*
    responseData = [[NSMutableData alloc] init];
    
    //PREPARE the request
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //Prepare data which will contain the json request string.
    
    //Set the propreties of the request
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request2 setValue:[NSString stringWithFormat:@"%d", [requestData2 length]] forHTTPHeaderField:@"Content-Length"];
    [request2 setValue:requestData.putData forHTTPHeaderField:@"Query-string"];
    //set the data prepared
    [request2 setHTTPBody: requestData2];
    
    //Initialize the connection with request
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    //Start the connection
    //[connection start];
     
     */
    
}
#pragma mark NSURLConnection delegate methods
//WHen receiving the response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@" Did receive respone");
    //[responseData setLength:0];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //While receiving the response data
   // [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //When failed just log
    NSLog(@"Connection failed!");
    NSLog(@"Error %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //When the response data is downloaded
    // NSLog(@" Data obtained %@", responseData);
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // NSLog(@" Response String %@", responseString);
    //converted response json string to a simple NSdictionary
    //If the response string is really JSONABLE I will have the data u sent me displayed succefully
   
}


-(void)getDataForResponseObjectUsingPost:(RequestData *)requestData
{
	NSURL *url=[self createURLUsingRequestDataObject:requestData];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setReqMetaData:requestData];
	for (NSString *key in [requestData.postData allKeys])
		[request setPostValue:[requestData.postData valueForKey:key] forKey:key];
	for (NSString *key in [requestData.files allKeys])
		[request setFile:[requestData.files valueForKey:key] forKey:key];

	ASINetworkQueue *queue=[[ASINetworkQueue alloc] init];
	[queue setDelegate:self];
	[queue setRequestDidFinishSelector:@selector(requestFinished:)];
	[queue setRequestDidFailSelector:@selector(requestFailed:)];

	[queue addOperation:request]; 
	[queue go];
}


-(void)getDataForResponseObjectUsingGet:(RequestData *)requestData
{
	NSURL *url=[self createURLUsingRequestDataObject:requestData];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setTimeOutSeconds:180];
    
		[request setReqMetaData:requestData];
	[request setDelegate:self];
	[request startAsynchronous];
	
}


-(NSURL *)createURLUsingRequestDataObject:(RequestData *)requestData
{
    NSString *getString =@"";
    if (requestData.getData!=nil) {
      getString=[self createKeyUsingNSDictionary:requestData.getData];  
    }
	
	NSString *requestURL=[NSString stringWithFormat:@"%@%@%@",requestData.baseURL,requestData.webServiceURL,getString];
	requestURL=[requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:requestURL];
	return url;
}

-(NSString *) createKeyUsingNSDictionary:(NSDictionary *)dict
{
	NSString *getString=@"?";
	NSInteger keysCounter=0;
	for (NSString *key in [dict allKeys])
	{
        NSString *val = [dict valueForKey:key];
		if(keysCounter == 0)
			getString=[NSString stringWithFormat:@"%@%@=%@",getString,key,val];
		else
			getString=[NSString stringWithFormat:@"%@&%@=%@",getString,key,val];
		keysCounter++;
	}
	return getString;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self processResponseReceivedFromServer:request];
}

-(NSString *)createKeyUsingRequestData :(RequestData *)requestData
{
	
    NSString *getString=[self createKeyUsingNSDictionary:requestData.getData];
	NSString *putString=requestData.putData;
    NSString *fileStr=[self createKeyUsingNSDictionary:requestData.files];
	NSString *postString=[self createKeyUsingNSDictionary:requestData.postData];
    NSString *attributeStr=[NSString stringWithFormat:@"%@%@%@%@%@%@",requestData.baseURL ,requestData.webServiceURL,getString,postString,putString,fileStr];
	return attributeStr;
}

-(void)processResponseReceivedFromServer:(ASIHTTPRequest *)request
{
	//NSLog(@"%@",[request responseString]);
	RequestData *requestData=request.reqMetaData;

	NSString *attributeStr=[self createKeyUsingRequestData:requestData];

	if(requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_UPDATE_CACHE_IN_BACKGROUND || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_UPDATE_CACHE_IN_BACKGROUND  || requestData.requestSourceType == REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE  || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_URL || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_IF_FAIL_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE)
		[cacheManager setData:[request responseData] forKey:attributeStr];
	
	if(requestData.showLoader)
	{
		[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self  selector: @selector(hideLoader:) userInfo:requestData.loaderView repeats: NO];
	}
	
		
	requestData.responseType=RESPONSE_DATA_TYPE_LIVE;
	NSMutableDictionary *responseData=[[NSMutableDictionary alloc]init];
	[responseData setObject:requestData forKey:@"reqMetaData"];
	[responseData setObject:[request responseString] forKey:@"responseString"];
	[responseData setObject:[request responseData] forKey:@"responseData"];	

	if(requestData.requestSourceType == REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_URL  || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_AND_URL || (!requestData.wasCashedDataReturned && (requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_IF_FAIL_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE || requestData.requestSourceType == REQUEST_DATA_FROM_CACHE_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE)))
	{
		[self respondeToCaller:responseData];
	}
	[responseData release];
}


-(void)respondeToCaller:(NSMutableDictionary *)request
{
	RequestData *reqData=[request objectForKey:@"reqMetaData"];
	id requestSenderObj=reqData.sender;
	SEL requestSenderSelecter=reqData.callbackFunction;
	
	if(reqData.responseDataType == RESPONSE_TYPE_DICT)
	{
		NSString *responseString= [request objectForKey:@"responseString"];
	//	SBJSON *json = [[SBJSON new] autorelease]; //Surinder
		SBJSON *json = [[SBJSON alloc] init];      //Surinder
		NSError *error;
		
		NSMutableDictionary *searchData = [json objectWithString:responseString error:&error];
		if(json){
            [json release];
        }//Surinder
		json=nil;
		reqData.responseData=searchData;
		
		if ([requestSenderObj respondsToSelector:requestSenderSelecter]) {
			[requestSenderObj performSelector:requestSenderSelecter withObject:reqData];	
			
			
		}
		searchData=nil;
		//RELEASE(json);  //Surinder
	}
	
	else if( reqData.responseDataType == RESPONSE_TYPE_DATA)
	{
				RequestData *reqData =[request objectForKey:@"reqMetaData"];
		reqData.responseData=[request objectForKey:@"responseData"];
		if ([requestSenderObj respondsToSelector:requestSenderSelecter]) {
			[requestSenderObj performSelector:requestSenderSelecter withObject:reqData];
			
		}
	}
	
	else if(reqData.responseDataType == RESPONSE_TYPE_STR)
	{
		
		RequestData *reqData =[request objectForKey:@"reqMetaData"];
		reqData.responseData=[request objectForKey:@"responseString"];
		if ([requestSenderObj respondsToSelector:requestSenderSelecter]) {
			[requestSenderObj performSelector:requestSenderSelecter withObject:reqData];
			
		}
	}
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	RequestData *reqData=request.reqMetaData;

	NSLog(@"ERROR----------------------------- %@",error);
	[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self  selector: @selector(hideLoader:) userInfo:reqData.loaderView repeats: NO];
	if ([reqData.sender respondsToSelector:reqData.callbackFunctionOnError])
	{
		[reqData.sender performSelector:reqData.callbackFunctionOnError withObject:error];
	}
	
}



@end
