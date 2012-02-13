//
//  YXTLocation.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTLocation.h"
#import "OFReachability.h"
#import "NSNotificationCenter+OF.h"
#import "YXTBasicViewController.h"
#import "OFXPRequest.h"
#import "YXTSettings.h"

@implementation YXTLocation
	
@synthesize delegateFilm;


-(void)dealloc{
	[mReq release];
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		
	}
	return self;
}

-(void)startToFetchCityList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateFilm setWaitingMessage:@"正在获取城市信息"];
		[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:START_FADEIN_WAITING object:nil];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];

		[dict setValue:@"miscinfo" forKey:@"METHOD"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:[[YXTSettings instance] getSetting:@"sign-code"] forKey:@"SIGN"];

		
		OFXPRequest *req = [OFXPRequest postRequestWithPath:url andQuery:dict andBody:nil];
		[req onRespondJSON:self];
		[req execute];
		
		mReq = [req retain];
	}else {
		[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:START_FADEIN_NETWORK_ERROR object:nil];
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
    OFSafeRelease(mReq);
	if(responseCode == 200){
        
    }
    else{
		
	}
}

@end
