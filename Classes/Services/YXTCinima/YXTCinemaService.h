//
//  YXTCinimaService.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-20.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicViewController.h"
#import "BasicInfo.h"
#import "YXTHotFilmService.h"
#import "YXTBasicService.h"

@interface YXTCinemaService : YXTBasicService <OFXPResponseJSON>{
	YXTBasicViewController *delegateCinema;
	OFXPRequest *mReq;
	YXTFilmInfo *filmInfo;
	
	NSMutableArray *rawCinemaList;
	NSMutableArray *cinemaDistrictList;
}

@property (nonatomic, assign) YXTBasicViewController *delegateCinema;

@property (nonatomic, retain) YXTFilmInfo *filmInfo;

@property (nonatomic, retain) NSMutableArray *rawCinemaList;
@property (nonatomic, retain) NSMutableArray *cinemaDistrictList;

-(void)startToFetchCinimaList;
-(void)orderCinemaByDistrict;

@end

@interface YXTDistrict : NSObject<BasicInfo>{
	NSMutableArray *cinemaList;
	NSString *districtId;
	NSString *distName;
	
	//tag used for tree
	BOOL isExpand;
}

@property (nonatomic, retain) NSMutableArray *cinemaList;

@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *distName;

@property (nonatomic, assign) BOOL isExpand;

@end


@interface YXTCinemaInfo : NSObject<BasicInfo>{
	NSString *cinemaId;
	NSString *cinemaName;
	NSString *address;
	NSString *cityId;
	NSString *cityName;
	NSString *hallCount;
	NSString *cinemaBusLine;
	NSString *description;
	NSString *cinemaPhoto;
	NSString *districtId;
	NSString *distName;
	NSString *couponOrder;
	NSString *onlineOrder;
	NSString *partnerId;
	NSString *partnerName;
	NSString *partnerPicId;
	
	UIImage *cinemaImage;
}

@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *hallCount;
@property (nonatomic, copy) NSString *cinemaBusLine;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *cinemaPhoto;
@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *distName;
@property (nonatomic, copy) NSString *couponOrder;
@property (nonatomic, copy) NSString *onlineOrder;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *partnerName;
@property (nonatomic, copy) NSString *partnerPicId;

@property (nonatomic, retain) UIImage *cinemaImage;

@end
