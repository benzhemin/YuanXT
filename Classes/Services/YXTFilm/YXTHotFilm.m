//
//  YXTHotFilm.m
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTHotFilm.h"
#import "YXTLocation.h"
#import "YXTBasicViewController.h"
#import "OFReachability.h"
#import "YXTSettings.h"

@implementation YXTHotFilm

@synthesize filmList, delegateFilm, cityInfo;

-(void)dealloc{
	[mReq release];
	[filmList release];
	[cityInfo release];
	[super dealloc];
}


-(void)startToFetchFilmList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateFilm setWaitingMessage:@"正在获取电影列表"];
		[delegateFilm displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"hotfilm" forKey:@"METHOD"];
		[dict setValue:[cityInfo cityId] forKey:@"CITYID"];
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
}

@end

@implementation YXTFilmInfo

@synthesize filmId, filmName, duration, director, mainPerformer;
@synthesize webPoster, webPoster2, ycTime, filmClass, area;
@synthesize description, trailer, attention, showCount;

-(void)dealloc{
	[filmId release];
	[filmName release];
	[duration release];
	[director release];
	[mainPerformer release];
	[webPoster release];
	[webPoster2 release];
	[ycTime release];
	[filmClass release];
	[area release];
	[description release];
	[trailer release];
	[attention release];
	[showCount release];
	
	[super dealloc];
}

@end

