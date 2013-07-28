//
//  requestData.m
//
//  Created by Subhash Chand on 18/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RequestData.h"

@implementation RequestData

@synthesize baseURL;
@synthesize webServiceURL;
@synthesize sender;
@synthesize requestType;
@synthesize responseDataType;
@synthesize getData;
@synthesize postData;
@synthesize putData;
@synthesize callbackObj;
@synthesize callbackFunction;
@synthesize files;
@synthesize showLoader;
@synthesize responseData;
@synthesize wasCashedDataReturned;
@synthesize responseType;
@synthesize errorForNoNetwork;
@synthesize callbackFunctionOnError;
@synthesize loaderView;
@synthesize requestSourceType;
- (id) init 
{
	self = [super init] ;

	if(self){
		self.baseURL= @"";
		self.webServiceURL=@"";
		requestSourceType=REQUEST_DATA_FROM_CACHE_AND_URL;
		self.callbackFunctionOnError = @selector(contentManagerResponseOnError:);
		self.callbackFunction=@selector(contentManagerResponse:);
		requestType=REQUEST_TYPE_GET;
		responseDataType=RESPONSE_TYPE_DICT;
		showLoader=YES;
		self.sender=nil;
		self.errorForNoNetwork=@"A network connection is required.  Please verify your network settings and try again." ;
		//loaderView=[self initLoader];
		wasCashedDataReturned=TRUE;

	}
	//Configurational vars
	

	////Dont update following vars
	
	return self;
}

-(void)dealloc {
	
	
	self.loaderView = nil;
	self.baseURL = nil;
	
	self.webServiceURL = nil;
	self.errorForNoNetwork = nil;
	self.sender = nil;
	self.getData = nil;
	self.postData = nil;
	self.putData = nil;
	self.callbackFunction = NULL;
	self.callbackFunctionOnError = NULL;
	self.responseData = nil;
	[super dealloc];
}
@end
