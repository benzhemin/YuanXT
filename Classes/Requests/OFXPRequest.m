//
//  YXTRequest.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "OFXPRequest.h"
#import "OFASIHTTPRequest.h"
#import "OFASIFormDataRequest.h"
#import "YXTSettings.h"
#import "JSON.h"
#import "YXTBasicViewController.h"
#import "NSNotificationCenter+OF.h"

@interface OFXPRequest ()

@property (nonatomic, retain) OFASIHTTPRequest* request;
@property (nonatomic, retain) id<OFXPResponseText> responseText;
@property (nonatomic, retain) id<OFXPResponseData> responseData;
@property (nonatomic, retain) id<OFXPResponseJSON> responseJSON;
@property (nonatomic, retain) NSString* responseAsString;
@property (nonatomic, retain) NSObject* responseAsJson;
@property (nonatomic, retain) NSData* responseAsData;
@property (nonatomic, retain) NSString* path;
- (void)failWithExceptionClass:(NSString*)className error:(NSString*)errorMessage responseCode:(unsigned int)responseCode;
- (void)requestFinishedOnRequestThread;

@end

@interface ExtendedGetRequest : OFASIHTTPRequest <ExtendedRequest>{
    OFXPRequest* xpRequest;
}
@end

@implementation ExtendedGetRequest
- (void)setXPRequest:(OFXPRequest*)_request{
    [xpRequest release];
    xpRequest = [_request retain];
}
- (void)requestFinished{
    [xpRequest requestFinishedOnRequestThread]; 
    [super requestFinished]; 
}
@end

@interface ExtendedFormRequest : OFASIFormDataRequest <ExtendedRequest>{
    OFXPRequest* xpRequest;
}
@end

@implementation ExtendedFormRequest
- (void)setXPRequest:(OFXPRequest*)_request{
    [xpRequest release];
    xpRequest = [_request retain];
}
- (void)requestFinished{
    [xpRequest requestFinishedOnRequestThread]; 
    [super requestFinished]; 
}
@end


static NSString* uriEncode(NSString* str){
	return [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8) autorelease];
}

@protocol ArgBuilder
- (void)addArgument:(id)arg forKey:(NSString*)key;
@end

static void buildDict(id<ArgBuilder> builder, NSDictionary* body, NSString* prefix);

static void buildArr(id<ArgBuilder> builder, NSArray* arr, NSString* key)
{
	NSString* fullKey = [NSString stringWithFormat:@"%@[]", key];
	for (id o in arr){
		if ([o isKindOfClass:[NSDictionary class]]){
			buildDict(builder, (NSDictionary*)o, fullKey);
		} 
		else if ([o isKindOfClass:[NSArray class]]){
			buildArr(builder, (NSArray*)o, fullKey);
		}
		else{
			[builder addArgument:o forKey:fullKey];
		}
	}
}

static void buildDict(id<ArgBuilder> builder, NSDictionary* body, NSString* prefix){
	for (NSString* k in [body allKeys]){
		id v = [body objectForKey:k];
		NSString* fullKey = prefix ? [NSString stringWithFormat:@"%@[%@]", prefix, k] : k;
		if ([v isKindOfClass:[NSDictionary class]]){
			buildDict(builder, (NSDictionary*)v, fullKey);
		} 
		else if ([v isKindOfClass:[NSArray class]]){
			buildArr(builder, (NSArray*)v, fullKey);
		}
		else{
			[builder addArgument:v forKey:fullKey];
		}
	}
}

static void buildRoot(id<ArgBuilder> builder, NSDictionary* body) {
	buildDict(builder, body, NULL);
}

@interface FormBuilder : NSObject<ArgBuilder>{
	OFASIFormDataRequest* request;
}

- (void)addArgument:(id)arg forKey:(NSString*)key;
+ (FormBuilder*)builderForRequest:(OFASIFormDataRequest*)request;

@property (nonatomic, retain) OFASIFormDataRequest* request;
@end

@implementation FormBuilder
@synthesize request;
- (void)addArgument:(id)arg forKey:(NSString*)key {
	[self.request addPostValue:arg forKey:key];
}

+ (FormBuilder*)builderForRequest:(OFASIFormDataRequest*)request{
	FormBuilder* rv = [[self new] autorelease];
	rv.request = request;
	return rv;
}

- (void)dealloc{
    self.request = nil;
    [super dealloc];
}
@end

@interface QueryBuilder : NSObject<ArgBuilder>{
	NSMutableString* accum;
}

- (void)addArgument:(id)arg forKey:(NSString*)key;
- (NSString*)queryString;
@end

@implementation QueryBuilder
- (void)addArgument:(id)arg forKey:(NSString*)key{
	if (accum)
	{
		[accum appendFormat:@"&%@=%@", uriEncode(key), uriEncode(arg)];
	}
	else
	{
		accum = [NSMutableString stringWithFormat:@"%@=%@", uriEncode(key), uriEncode(arg)];
	}
}
- (NSString*)queryString{
	return accum;
}	
@end

@implementation OFXPRequest

@synthesize responseText = mResponseText;
@synthesize responseData = mResponseData;
@synthesize responseJSON = mResponseJSON;

@synthesize responseAsString = mResponseAsString;
@synthesize responseAsJson = mResponseAsJSON;
@synthesize responseAsData = mResponseAsData;

@synthesize path = mPath;

- (void)setRequest:(OFASIHTTPRequest*)request{
	// Cleanup existing
	mRequest.delegate = nil;
    [(OFASIHTTPRequest<ExtendedRequest>*)mRequest setXPRequest:nil];
    [mRequest release];
	
	//setup new.    
	mRequest = [request retain];
	request.delegate = self;
    [(OFASIHTTPRequest<ExtendedRequest>*)mRequest setXPRequest:self];
}

- (id)init{
	self = [super init];
    if (self != nil){
    }
	return self;
}

- (void)dealloc
{	
    self.path = nil;
	self.request = nil;	
	[super dealloc];
}

#pragma mark -
#pragma mark Creation Methods
#pragma mark -

- (void)genRequestWithURL:(NSURL*)url andASIClass:(Class)asiHttpRequestSubclass{
    OFASIHTTPRequest* req = [[asiHttpRequestSubclass alloc] initWithURL:url];
	// setup our config
	req.timeOutSeconds = 20.f;
	req.numberOfTimesToRetryOnTimeout = 2;
	
	
	//set https protocal for YXT project
	[req setValidatesSecureCertificate:NO];
	
	
	self.request = req;
    [req release];
}

- (void)genRequestWithPath:(NSString*)path andASIClass:(Class)asiHttpRequestSubclass{
    static NSString* sServerURL = nil;
    if(!sServerURL)
    {
        sServerURL = [[[[NSURL URLWithString:[[YXTSettings instance] getSetting:@"server-url"]] standardizedURL] absoluteString] retain];
    }
    
	if ([path hasPrefix:@"/"])
	{
		path = [path substringFromIndex:1];
	}
	
	[self genRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", sServerURL, path]] andASIClass:(Class)asiHttpRequestSubclass];
}

+ (NSString*)embedQueryInPath:(NSString*)path andQuery:(NSDictionary*)query{
	QueryBuilder* queryBuilder = [QueryBuilder new];
	buildRoot(queryBuilder, query);
	NSString* queryString = [queryBuilder queryString];
	[queryBuilder release];
	if (queryString) 
	{
		path = [NSString stringWithFormat:@"%@?%@", path, queryString];
	}
	return path;
}

- (OFASIHTTPRequest*)request{
	return mRequest;
}


+ (id)request{
	return [[[self alloc] init] autorelease];
}

+ (id)requestWithPath:(NSString*)_path andASIClass:(Class)asiHttpRequestSubclass{
	OFXPRequest *req = [self request];
    req.path = _path;
    [req genRequestWithPath:_path andASIClass:asiHttpRequestSubclass];
	return req;
}


+ (id)getRequestWithPath:(NSString*)path{
	return [self requestWithPath:path andASIClass:[ExtendedGetRequest class]];
}

+ (id)getRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query{
	return [self getRequestWithPath:[self embedQueryInPath:path andQuery:query]];
}

+ (id)getRequestWithPath:(NSString*)path andQueryString:(NSString*)queryString{
	return [self getRequestWithPath:[NSString stringWithFormat:@"%@?%@", path, queryString]];
}


+ (id)putRequestWithPath:(NSString*)path andBody:(NSDictionary*)body{
	OFXPRequest* req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"PUT";
	buildRoot([FormBuilder builderForRequest:(OFASIFormDataRequest*)req->mRequest], body);
	return req;
}

+ (id)putRequestWithPath:(NSString*)path andBodyString:(NSString*)bodyString{
	OFXPRequest* req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"PUT";
	// quick hack
    [req.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    req.request.postBody = [NSMutableData dataWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	return req;
}

+ (id)postRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query andBody:(NSDictionary *)body{
	OFXPRequest* req = [self requestWithPath:[self embedQueryInPath:path andQuery:query] 
								 andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"POST";
	buildRoot([FormBuilder builderForRequest:(OFASIFormDataRequest*)req.request], body);
	return req;
}

+ (id)postRequestWithPath:(NSString*)path andBody:(NSDictionary*)body{
	OFXPRequest* req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"POST";
	buildRoot([FormBuilder builderForRequest:(OFASIFormDataRequest*)req.request], body);
	return req;
}

+ (id)postRequestWithPath:(NSString*)path andBodyString:(NSString*)bodyString{
	OFXPRequest* req = [self requestWithPath:path andASIClass:[ExtendedFormRequest class]];
    req.request.requestMethod = @"POST";
	// quick hack
    [req.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    req.request.postBody = [NSMutableData dataWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	return req;
}

+ (id)postRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query{    
	QueryBuilder* queryBuilder = [QueryBuilder new];
	buildRoot(queryBuilder, query);
	NSString* queryString = [queryBuilder queryString];
	[queryBuilder release];
	return [self postRequestWithPath:path andBodyString:queryString];
}

+ (id)deleteRequestWithPath:(NSString*)path{
	OFXPRequest* req = [self requestWithPath:path andASIClass:[ExtendedGetRequest class]];
    req.request.requestMethod = @"DELETE";
	return req;
}

+ (id)deleteRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query{
	return [self deleteRequestWithPath:[self embedQueryInPath:path andQuery:query]];
}

// And here is the super deluxe generic deal.
+ (id)requestWithPath:(NSString *)path andMethod:(NSString*)method andArgs:(NSDictionary*)args{
	if ([method isEqualToString:@"GET"])
		return [self getRequestWithPath:path andQuery:args];
	
	if ([method isEqualToString:@"POST"])
		return [self postRequestWithPath:path andBody:args];
	
	if ([method isEqualToString:@"PUT"])
		return [self putRequestWithPath:path andBody:args];
	
	if ([method isEqualToString:@"DELETE"])
		return [self deleteRequestWithPath:path];
	
	return nil;
}

+ (id)requestWithPath:(NSString *)path andMethod:(NSString*)method andArgString:(NSString*)args{
	if ([method isEqualToString:@"GET"])
		return [self getRequestWithPath:path andQueryString:args];
	
	if ([method isEqualToString:@"POST"])
		return [self postRequestWithPath:path andBodyString:args];
	
	if ([method isEqualToString:@"PUT"])
		return [self putRequestWithPath:path andBodyString:args];
	
	if ([method isEqualToString:@"DELETE"])
		return [self deleteRequestWithPath:path];
	
	return nil;
}


#pragma mark -
#pragma mark Response Delegate Methods
#pragma mark -

// If you call this, you'll get notified when the request succeeds or fails,
// with the plain text of the body.  This returns self, so you can chain.
- (id)onRespondText:(id<OFXPResponseText>)responseBlock{
	self.responseText = responseBlock;
	return self;
}

// If you call this, you'll get notified when the request succeeds or fails,
// with the plain data of the body.  This returns self, so you can chain.
- (id)onRespondData:(id<OFXPResponseData>)responseBlock;{
	self.responseData = responseBlock;
	return self;
}

// If you call this, you'll get notified when the request succeeds or fails,
// with the body all JSON-parsed just for you.  This returns self, so you can chain.
- (id)onRespondJSON:(id<OFXPResponseJSON>)responseBlock;{
	self.responseJSON = responseBlock;
	return self;
}


#pragma mark -
#pragma mark Execution
#pragma mark -

// This generates and starts executing the request.  Make sure you set the success/failure blocks before
// calling this.
- (void)execute{
    [mRequest startAsynchronous];
}

- (void)cancel{
    if (mRequest) {
        mRequest.delegate = nil;
        [mRequest cancel];
    }
}

- (void)retry{
	self.request = [[mRequest copy] autorelease];
    [self execute];
}


#pragma mark -
#pragma mark Response Methods
#pragma mark -

- (void)failWithExceptionClass:(NSString*)className error:(NSString*)errorMessage responseCode:(unsigned int)responseCode{
	//[mResponseText onResponseText:asString withResponseCode:responseCode];
	//[mResponseData onResponseData:[asString dataUsingEncoding:NSUTF8StringEncoding] withResponseCode:responseCode];
	//[mResponseJSON onResponseJSON:exc withResponseCode:responseCode];
	NSLog(@"server encounter with error");
	[mResponseText onResponseText:mResponseAsString withResponseCode:mRequest.responseStatusCode];
	[mResponseData onResponseData:mResponseAsData withResponseCode:mRequest.responseStatusCode];
	[mResponseJSON onResponseJSON:mResponseAsJSON withResponseCode:mRequest.responseStatusCode];
}

- (void)forceFailure:(unsigned int)responseCode{
	[self failWithExceptionClass:@"SessionFailure" error:@"Request failed due to device/user session failure." responseCode:responseCode];
}

- (void)requestFinishedOnRequestThread{
	// If we have any of these callbacks, we're going to need the data in string format.
	if (mResponseText || mResponseJSON){
		NSStringEncoding encoding = [mRequest responseEncoding];
		if (!encoding) encoding = NSUTF8StringEncoding;
		NSData* d = [mRequest responseData];
		mResponseAsString = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:encoding];
		if (!mResponseAsString){
			// @HACK we are being bitten by the fact that the server doesn't really know what the encoding is.
			// it's probably straight ASCII in the database.  We need to fix this server-side in the long run
			// and make sure the output encoding is correctly translating data coming out of the db.  For now
			// though, we can just use ASCII iff the response encoding fails.
			mResponseAsString = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSASCIIStringEncoding];
		}
	}
	
	// same for json...
	if (mResponseJSON)
	{
		self.responseAsJson = [mResponseAsString JSONValue];
	}
	
	// same for data.
	if (mResponseData)
	{
		self.responseAsData = [mRequest responseData];
	}
}

// This relies on -requestFinishedOnRequestThread being called first.
- (void)requestFinished:(OFASIHTTPRequest *)request{
	if (401 == request.responseStatusCode ) {
		//haven't authenticate
		return;
	}
	
	[mResponseText onResponseText:mResponseAsString withResponseCode:mRequest.responseStatusCode];
	[mResponseData onResponseData:mResponseAsData withResponseCode:mRequest.responseStatusCode];
	[mResponseJSON onResponseJSON:mResponseAsJSON withResponseCode:mRequest.responseStatusCode];
	
	// we're done here
	self.request = nil;
}

- (void)requestFailed:(OFASIHTTPRequest *)request{
	NSLog(@"request failed!");
	[[NSNotificationCenter defaultCenter] postNotificationName:START_SHOW_REQUEST_FAILED_ERROR object:nil userInfo:nil];
	// we're done here
	self.request = nil;
}


@end
