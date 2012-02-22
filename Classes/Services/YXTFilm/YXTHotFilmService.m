//
//  YXTHotFilm.m
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTHotFilmService.h"
#import "YXTLocationService.h"
#import "YXTBasicViewController.h"
#import "OFReachability.h"
#import "YXTSettings.h"

@implementation YXTHotFilmService

@synthesize filmList, delegateFilm, cityInfo;

-(void)dealloc{
	[mReq release];
	[filmList release];
	[cityInfo release];
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		self.filmList = [[NSMutableArray alloc] initWithCapacity:20];
	}
	return self;
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
		[dict setValue:@"a6126169c99301f105e742b57df63fb9" forKey:@"SIGN"];
		
		
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
			[delegateFilm setResponseMessage:@"目前暂无数据"];
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
