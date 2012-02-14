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


@implementation YXTCityInfo

@synthesize provinceId, cityId, cityName;

-(NSString *)infoDescription{
	return cityName;
}

-(void)dealloc{
	[provinceId release];
	[cityId release];
	[cityName release];
	[super dealloc];
}

@end


@implementation YXTLocation
	
@synthesize delegateFilm, cityList;


-(void)dealloc{
	[mReq release];
	self.cityList = nil;
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		self.cityList = [[NSMutableArray alloc] initWithCapacity:20];
	}
	return self;
}

-(void)startToFetchCityList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateFilm setWaitingMessage:@"正在获取城市信息"];
		[delegateFilm displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];

		[dict setValue:@"miscinfo" forKey:@"METHOD"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:[[YXTSettings instance] getSetting:@"sign-code"] forKey:@"SIGN"];

		
		OFXPRequest *req = [OFXPRequest postRequestWithPath:url andBody:dict];
		[req onRespondJSON:self];
		[req execute];
		
		mReq = [req retain];
	}else {
		[delegateFilm displayNetWorkErrorActivityView];
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
	
    OFSafeRelease(mReq);
	
	NSDictionary *bodyDict = (NSDictionary *)body;
	NSString *errorCode = [bodyDict objectForKey:@"ERRORCODE"];
	
	if(responseCode == 200 && [errorCode isEqualToString:@"000000"]){
		
        NSArray *cityListBody = [bodyDict objectForKey:@"CITYLIST"];
		//NSLog(@"%@", cityListBody);
		
		for (NSDictionary *cityDict in cityListBody) {
			YXTCityInfo *cityInfo = [[YXTCityInfo alloc] init];
			cityInfo.provinceId = [cityDict objectForKey:@"PROVINCEID"];
			cityInfo.cityId = [cityDict objectForKey:@"CITYID"];
			cityInfo.cityName = [cityDict objectForKey:@"CITYNAME"];

			[cityList addObject:cityInfo];
			[cityInfo release];
		}
		
		[delegateFilm performSelectorOnMainThread:@selector(popUpCityChangePicker:) withObject:cityList waitUntilDone:NO];
    }
    else{
		[delegateFilm performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
	
	[delegateFilm performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
}

@end
