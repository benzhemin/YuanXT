//
//  YXTShowService.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTShowService.h"
#import "OFReachability.h"
#import "YXTBasicViewController.h"
#import "YXTSettings.h"
#import "YXTCinemaService.h"
#import "YXTHotFilmService.h"

@implementation YXTShowService

@synthesize cinemaInfo, filmInfo;
@synthesize delegateFilm, showList;
@synthesize dateStr;
@synthesize changeFlag;

-(void)dealloc{
	[cinemaInfo release];
	[filmInfo release];
	[showList release];
	
	[dateStr release];
	
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		showList = [[NSMutableArray alloc] initWithCapacity:20];
	}
	return self;
}

-(void)startToFetchShowList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateFilm setWaitingMessage:@"正在获取场次信息"];
		[delegateFilm displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"show" forKey:@"METHOD"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:[[YXTSettings instance] getSetting:@"sign-code"] forKey:@"SIGN"];
		
		if (self.filmInfo) {
			[dict setValue:filmInfo.filmId forKey:@"FILMID"];
		}
		
		[dict setValue:cinemaInfo.cinemaId forKey:@"CINEMAID"];
		
		[dict setValue:dateStr forKey:@"SHOWDATE"];
		
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
		
		int recordCount = [[bodyDict objectForKey:@"RECORDAMOUNT"] intValue];
        NSArray *showListBody = [bodyDict objectForKey:@"SHOWLIST"];
		
		if ([showListBody count] != 0 && recordCount != 0) {
			for (NSDictionary *showDict in showListBody) {
				YXTShowInfo *showInfo = [[YXTShowInfo alloc] init];
				showInfo.showSeqNo = [showDict objectForKey:@"SHOWSEQNO"];
				showInfo.hallName = [showDict objectForKey:@"HALLNAME"];
				showInfo.showDate = [showDict objectForKey:@"SHOWDATE"];
				showInfo.showTime = [showDict objectForKey:@"SHOWTIME"];
				showInfo.duration = [showDict objectForKey:@"DURATION"];
				showInfo.filmId = [showDict objectForKey:@"FILMID"];
				showInfo.filmName = [showDict objectForKey:@"FILMNAME"];
				showInfo.filmVer = [showDict objectForKey:@"FILMVER"];
				showInfo.ycTime = [showDict objectForKey:@"YCTIME"];
				showInfo.filmStatus = [showDict objectForKey:@"FILMSTATUS"];
				showInfo.cinemaId = [showDict objectForKey:@"CINEMAID"];
				showInfo.cinemaName = [showDict objectForKey:@"CINEMANAME"];
				showInfo.cinemaPrice = [showDict objectForKey:@"CINEMAPRICE"];
				showInfo.bestPayPrice = [showDict objectForKey:@"BESTPAYPRICE"];
				showInfo.servPrice = [showDict objectForKey:@"SERVPRICE"];
				showInfo.cityId = [showDict objectForKey:@"CITYID"];
				
				[showList addObject:showInfo];
				[showInfo release];
			}
			if (changeFlag) {
				
			}else {
				[delegateFilm performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
			}
			
			[delegateFilm performSelectorOnMainThread:@selector(showListFetchSucceed:) withObject:showList waitUntilDone:NO];
		}else {
			if ([delegateFilm respondsToSelector:@selector(requestHasNoCount)]) {
				[delegateFilm performSelectorOnMainThread:@selector(requestHasNoCount) withObject:nil waitUntilDone:NO];
			}
			[delegateFilm setResponseMessage:@"场次信息目前暂无数据"];
			[delegateFilm performSelectorOnMainThread:@selector(displayChangeActivityView) withObject:nil waitUntilDone:NO];
		}
	}
    else{
		[delegateFilm performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
}

@end

@implementation YXTShowInfo

@synthesize showSeqNo, hallName, showDate;
@synthesize showTime, duration, filmId;
@synthesize filmName, filmVer, ycTime;
@synthesize filmStatus, cinemaId, cinemaName;
@synthesize cinemaPrice, bestPayPrice, servPrice, cityId;

-(void)dealloc{
	[showSeqNo release];
	[hallName release];
	[showDate release];
	[showTime release];
	[duration release];
	[filmId release];
	[filmName release];
	[filmVer release];
	[ycTime release];
	[filmStatus release];
	[cinemaId release];
	[cinemaName release];
	[cinemaPrice release];
	[bestPayPrice release];
	[servPrice release];
	[cityId release];
	[super dealloc];
}

@end

