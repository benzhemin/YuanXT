//
//  YXTHotFilm.h
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicService.h"

@class YXTCityInfo;
@class YXTBasicViewController;

@interface YXTHotFilmService : YXTBasicService<OFXPResponseJSON> {
	YXTBasicViewController *delegateFilm;
	YXTCityInfo *cityInfo;
	NSMutableString *filmIdSet;
	
	BOOL changeFlag;
	
	OFXPRequest *mReq;
	NSMutableArray *filmList;
}

@property (nonatomic, assign) YXTBasicViewController *delegateFilm;
@property (nonatomic, retain) NSMutableArray *filmList;

@property (nonatomic, assign) BOOL changeFlag;

@property (nonatomic, retain) YXTCityInfo *cityInfo;
@property (nonatomic, copy) NSMutableString *filmIdSet;

-(void)startToFetchFilmList;

@end


@interface YXTFilmInfo : NSObject{
	NSString *filmId;
	NSString *filmName;
	NSString *duration;
	NSString *director;
	NSString *mainPerformer;
	NSString *webPoster;
	NSString *webPoster2;
	NSString *ycTime;
	NSString *filmClass;
	NSString *area;
	NSString *description;
	NSString *trailer;
	NSString *attention;
	NSString *showCount;
}

@property (nonatomic, copy) NSString *filmId;
@property (nonatomic, copy) NSString *filmName;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *mainPerformer;
@property (nonatomic, copy) NSString *webPoster;
@property (nonatomic, copy) NSString *webPoster2;
@property (nonatomic, copy) NSString *ycTime;
@property (nonatomic, copy) NSString *filmClass;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *trailer;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *showCount;

@end


















