//
//  YXTHotFilm.m
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTHotFilmService.h"
#import "YXTLocationService.h"
#import "YXTBasicViewController.h"
#import "OFReachability.h"
#import "YXTSettings.h"
#import "DSActivityView.h"

@implementation YXTHotFilmService

@synthesize filmList, delegateFilm, cityInfo, filmIdSet;
@synthesize changeFlag;


-(void)dealloc{
	[mReq release];
	[filmList release];
	[cityInfo release];
	[filmIdSet release];
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		filmList = [[NSMutableArray alloc] initWithCapacity:20];
	}
	return self;
}


-(void)startToFetchFilmList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateFilm setWaitingMessage:@"正在获取电影列表"];
		
		if (changeFlag) {
			[DSActivityView currentActivityView].activityLabel.text = @"正在获取电影列表";
		}else {
			[delegateFilm displayActivityView];
		}
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"hotfilm" forKey:@"METHOD"];
        
        NSMutableString *signParam = [NSMutableString string];
		
		[dict setValue:[[[YXTSettings instance] cityInfo] cityId] forKey:@"CITYID"];
        [signParam appendFormat:@"%@", [[[YXTSettings instance] cityInfo] cityId]];
        
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
        [signParam appendFormat:@"%@", [[YXTSettings instance] getSetting:@"mobile-number"]];
		
		if (self.filmIdSet) {
			[dict setValue:filmIdSet forKey:@"FILMIDSET"];
            [signParam appendFormat:@"%@", filmIdSet];
		}
        [dict setValue:[self md5:signParam] forKey:@"SIGN"];
		
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
	[filmList removeAllObjects];
    
	NSDictionary *bodyDict = (NSDictionary *)body;
	NSString *errorCode = [bodyDict objectForKey:@"ERRORCODE"];
	
	if(responseCode == 200 && [errorCode isEqualToString:@"000000"]){
		
		int recordCount = [[bodyDict objectForKey:@"RECORDAMOUNT"] intValue];
        NSArray *filmListBody = [bodyDict objectForKey:@"HOTFILMLIST"];
		
		if ([filmListBody count] != 0 && recordCount != 0) {
			
			for (NSDictionary *filmDict in filmListBody) {
				YXTFilmInfo *filmInfo = [[YXTFilmInfo alloc] init];
				filmInfo.filmId = [filmDict objectForKey:@"FILMID"];
				filmInfo.filmName = [filmDict objectForKey:@"FILMNAME"];
				filmInfo.duration = [filmDict objectForKey:@"DURATION"];
				filmInfo.director = [filmDict objectForKey:@"DIRECTOR"];
				filmInfo.mainPerformer = [filmDict objectForKey:@"MAINPERFORMER"];
				filmInfo.webPoster = [filmDict objectForKey:@"WEBPOSTER"];
				filmInfo.webPoster2 = [filmDict objectForKey:@"WEBPOSTER2"];
				filmInfo.ycTime = [filmDict objectForKey:@"YCTIME"];
				filmInfo.filmClass = [filmDict objectForKey:@"FILMCLASS"];
				filmInfo.area = [filmDict objectForKey:@"AREA"];
				filmInfo.description = [filmDict objectForKey:@"DESCRIPTION"];
				filmInfo.trailer = [filmDict objectForKey:@"TRAILER"];
				filmInfo.attention = [filmDict objectForKey:@"ATTENTION"];
				filmInfo.showCount = [filmDict objectForKey:@"SHOWCOUNT"];
				
				[self.filmList addObject:filmInfo];
				[filmInfo release];
			}
			[delegateFilm performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
			[delegateFilm performSelectorInBackground:@selector(fetchFilmListSucceed:) withObject:self.filmList];
		}else {
			[delegateFilm setResponseMessage:@"热映电影目前暂无数据"];
			if ([delegateFilm respondsToSelector:@selector(requestHasNoCount)]) {
				[delegateFilm performSelectorOnMainThread:@selector(requestHasNoCount) withObject:nil waitUntilDone:NO];
			}
			[delegateFilm performSelectorOnMainThread:@selector(displayChangeActivityView) withObject:nil waitUntilDone:NO];
		}
	}
    else{
		[delegateFilm performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
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

