//
//  YXTFilmShowOrderController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTBasicViewController.h"

@class YXTCinemaInfo;
@class YXTFilmInfo;

@interface YXTFilmShowController : YXTBasicViewController {
	YXTCinemaInfo *cinemaInfo;
	YXTFilmInfo *filmInfo;
	
	NSString *todayStr;
	NSString *tomorrowStr;
	
	UIView *contentView;
	UIImageView *cinemaImgView;
	UILabel *addressLabel;
	UILabel *onlineOrderLabel;
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;
@property (nonatomic, retain) YXTFilmInfo *filmInfo;

@property (nonatomic, copy) NSString *todayStr;
@property (nonatomic, copy) NSString *tomorrowStr;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIImageView *cinemaImgView;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *onlineOrderLabel;

@end
