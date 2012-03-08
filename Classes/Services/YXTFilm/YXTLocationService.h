//
//  YXTLocation.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicViewController.h"
#import "BasicInfo.h"
#import "YXTBasicService.h"

@interface YXTLocationService : YXTBasicService <OFXPResponseJSON>{
	YXTBasicViewController *delegateFilm;
	OFXPRequest *mReq;
	NSMutableArray *cityList;
}

@property (nonatomic, assign) YXTBasicViewController *delegateFilm;
@property (nonatomic, retain) NSMutableArray *cityList;

-(void)startToFetchCityList;

@end


@interface YXTCityInfo : NSObject<BasicInfo>{
	NSString *provinceId;
	NSString *cityId;
	NSString *cityName;
}

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;


@end