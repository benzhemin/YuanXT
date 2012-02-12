//
//  YXTRequest.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OFXPRequest, ASIHTTPRequest;

@protocol OFXPResponseText <NSObject>
- (void)onResponseText:(NSString*)body withResponseCode:(unsigned int)responseCode;
@end

@protocol OFXPResponseData <NSObject>
- (void)onResponseData:(NSData*)body withResponseCode:(unsigned int)responseCode;
@end

@protocol OFXPResponseJSON <NSObject>
- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode;
@end

@protocol ExtendedRequest
- (void)setXPRequest:(OFXPRequest*)_request;
@end

@interface OFXPRequest : NSObject {
	id<OFXPResponseText> mResponseText;
	id<OFXPResponseData> mResponseData;
	id<OFXPResponseJSON> mResponseJSON;
	ASIHTTPRequest* mRequest;
	NSString* mResponseAsString;
	NSObject* mResponseAsJSON;
	NSData* mResponseAsData;
	
	NSString* mPath;
}

// Here's the basic deal.
+ (id)requestWithPath:(NSString*)path andASIClass:(Class)asiHttpRequestSubclass;

// Here are specific deals.
+ (id)getRequestWithPath:(NSString*)path;
+ (id)getRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query;
+ (id)getRequestWithPath:(NSString*)path andQueryString:(NSString*)queryString;

+ (id)putRequestWithPath:(NSString*)path andBody:(NSDictionary*)body;
+ (id)putRequestWithPath:(NSString*)path andBodyString:(NSString*)bodyString;

//adapt for YXT
+ (id)postRequestWithPath:(NSString *)path andQuery:(NSDictionary *)query andBody:(NSDictionary *)body;

+ (id)postRequestWithPath:(NSString*)path andBody:(NSDictionary*)body;
+ (id)postRequestWithPath:(NSString*)path andBodyString:(NSString*)bodyString;
+ (id)postRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query;

+ (id)deleteRequestWithPath:(NSString*)path;
+ (id)deleteRequestWithPath:(NSString*)path andQuery:(NSDictionary*)query;


// And here is the super deluxe generic deal.
+ (id)requestWithPath:(NSString *)path andMethod:(NSString*)method andArgs:(NSDictionary*)args;
+ (id)requestWithPath:(NSString *)path andMethod:(NSString*)method andArgString:(NSString*)args;

// If you call this, you'll get notified when the request succeeds or fails,
// with the plain text of the body.  This returns self, so you can chain.
- (id)onRespondText:(id<OFXPResponseText>)responseBlock;

// If you call this, you'll get notified when the request succeeds or fails,
// with the plain data of the body.  This returns self, so you can chain.
- (id)onRespondData:(id<OFXPResponseData>)responseBlock;

// If you call this, you'll get notified when the request succeeds or fails,
// with the body all JSON-parsed just for you.  This returns self, so you can chain.
- (id)onRespondJSON:(id<OFXPResponseJSON>)responseBlock;

// This starts executing the request.  Make sure you set the success/failure blocks before
// calling this.
- (void)execute;

// Cancel the request
- (void)cancel;

@property (nonatomic, retain, readonly) ASIHTTPRequest* request;

@end
