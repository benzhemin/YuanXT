//
//  YXTCinimaService.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-20.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTCinemaService.h"
#import "OFXPRequest.h"
#import "OFReachability.h"
#import "YXTSettings.h"

@implementation YXTCinemaService

@synthesize delegateCinema, cinemaList;

-(void)dealloc{
	[mReq release];
	self.cinemaList = nil;
	[super dealloc];
}

-(void)startToFetchCinimaList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateCinema setWaitingMessage:@"正在获取影院列表"];
		[delegateCinema displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"cinema" forKey:@"METHOD"];
		
		[dict setValue:[[[YXTSettings instance] cityInfo] cityId] forKey:@"CITYID"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:@"a6126169c99301f105e742b57df63fb9" forKey:@"SIGN"];
		
		
		OFXPRequest *req = [OFXPRequest postRequestWithPath:url andBody:dict];
		[req onRespondJSON:self];
		[req execute];
		
		mReq = [req retain];
	}else {
		[delegateCinema displayNetWorkErrorActivityView];
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
	
    OFSafeRelease(mReq);
	
	NSDictionary *bodyDict = (NSDictionary *)body;
	NSString *errorCode = [bodyDict objectForKey:@"ERRORCODE"];
	
	if(responseCode == 200 && [errorCode isEqualToString:@"000000"]){
		
		int recordCount = [[bodyDict objectForKey:@"RECORDAMOUNT"] intValue];
        NSArray *cinemaListBody = [bodyDict objectForKey:@"CINEMALIST"];
		
		if ([cinemaListBody count] != 0 && recordCount != 0) {
			for (NSDictionary *cinemaDict in cinemaListBody) {
				YXTCinemaInfo *cinemaInfo = [[YXTCinemaInfo alloc] init];
				cinemaInfo.cinemaId = [cinemaDict objectForKey:@"CINEMAID"];
				cinemaInfo.cinemaName = [cinemaDict objectForKey:@"CINEMANAME"];
				cinemaInfo.address = [cinemaDict objectForKey:@"ADDRESS"];
				cinemaInfo.cityId = [cinemaDict objectForKey:@"CITYID"];
				cinemaInfo.cityName = [cinemaDict objectForKey:@"CITYNAME"];
				cinemaInfo.hallCount = [cinemaDict objectForKey:@"HALLCOUNT"];
				cinemaInfo.cinemaBusLine = [cinemaDict objectForKey:@"CINEMABUSLINE"];
				cinemaInfo.description = [cinemaDict objectForKey:@"DESCRIPTION"];
				cinemaInfo.cinemaPhoto = [cinemaDict objectForKey:@"CINEMAPHOTO"];
				cinemaInfo.districtId = [cinemaDict objectForKey:@"DISTRICTID"];
				cinemaInfo.couponOrder = [cinemaDict objectForKey:@"COUPONORDER"];
				cinemaInfo.distName = [cinemaDict objectForKey:@"DISTNAME"];
				cinemaInfo.onlineOrder = [cinemaDict objectForKey:@"ONLINEORDER"];
				cinemaInfo.partnerId = [cinemaDict objectForKey:@"PARTNERID"];
				cinemaInfo.partnerName = [cinemaDict objectForKey:@"PARTNERNAME"];
				cinemaInfo.partnerPicId = [cinemaDict objectForKey:@"PARTNERPICID"];
			
				
				[cinemaList addObject:cinemaInfo];
				[cinemaInfo release];
			}
			[self orderCinemaByDistrict];
		}else {
			[delegateCinema setResponseMessage:@"目前暂无数据"];
			[delegateCinema performSelectorOnMainThread:@selector(displayChangeActivityView) withObject:nil waitUntilDone:NO];
		}
	}
    else{
		[delegateCinema performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
}

-(void)orderCinemaByDistrict{
	[delegateCinema performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
	[delegateCinema performSelectorOnMainThread:@selector(popUpCityChangePicker:) withObject:nil waitUntilDone:NO];
}

@end

@implementation YXTCinemaInfo

@synthesize cinemaId, cinemaName, address, hallCount;
@synthesize cityId, cityName, cinemaBusLine, description;
@synthesize cinemaPhoto, districtId, distName, couponOrder;
@synthesize onlineOrder, partnerId, partnerName, partnerPicId;

-(NSString *)infoDescription{
	return @"";
}

-(void)dealloc{
	[cinemaId release];
	[cinemaName release];
	[address release];
	[hallCount release];
	[cityId release];
	[cityName release];
	[cinemaBusLine release];
	[description release];
	[cinemaPhoto release];
	[districtId release];
	[distName release];
	[couponOrder release];
	[onlineOrder release];
	[partnerId release];
	[partnerName release];
	[partnerPicId release];
	[super dealloc];
}

@end
