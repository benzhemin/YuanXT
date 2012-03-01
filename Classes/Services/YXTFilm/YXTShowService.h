//
//  YXTShowService.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"

@class YXTCinemaInfo;
@class YXTFilmInfo;
@class YXTBasicViewController;

@interface YXTShowService : NSObject<OFXPResponseJSON> {
	YXTCinemaInfo *cinemaInfo;
	YXTFilmInfo *filmInfo;
	YXTBasicViewController *delegateFilm;
	NSMutableArray *showList;
	
	NSString *dateStr;
	
	BOOL changeFlag;
	
	OFXPRequest *mReq;
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;
@property (nonatomic, retain) YXTFilmInfo *filmInfo;
@property (nonatomic, assign) YXTBasicViewController *delegateFilm;
@property (nonatomic, retain) NSMutableArray *showList;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) BOOL changeFlag;

-(void)startToFetchShowList;

@end

@interface YXTShowInfo : NSObject{
	NSString *showSeqNo;
	NSString *hallName;
	NSString *showDate;
	NSString *showTime;
	NSString *duration;
	NSString *filmId;
	NSString *filmName;
	NSString *filmVer;
	NSString *ycTime;
	NSString *filmStatus;
	NSString *cinemaId;
	NSString *cinemaName;
	NSString *cinemaPrice;
	NSString *bestPayPrice;
	NSString *servPrice;
	NSString *cityId;
}
	
@property (nonatomic, copy) NSString *showSeqNo;
@property (nonatomic, copy) NSString *hallName;
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, copy) NSString *showTime;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *filmId;
@property (nonatomic, copy) NSString *filmName;
@property (nonatomic, copy) NSString *filmVer;
@property (nonatomic, copy) NSString *ycTime;
@property (nonatomic, copy) NSString *filmStatus;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *cinemaPrice;
@property (nonatomic, copy) NSString *bestPayPrice;
@property (nonatomic, copy) NSString *servPrice;
@property (nonatomic, copy) NSString *cityId;

@end

