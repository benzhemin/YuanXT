//
//  YXTFilmShowOrderController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTBasicViewController.h"
#import "ImageDownLoader.h"

@class YXTHotFilmService;
@class YXTShowService;
@class YXTCinemaInfo;
@class YXTFilmInfo;
@class ASINetworkQueue;

@interface YXTFilmShowController : YXTBasicViewController <ImageDownLoadDelegate, UITableViewDelegate, UITableViewDataSource>{
	YXTCinemaInfo *cinemaInfo;
	
	YXTShowService *showService;
	YXTHotFilmService *hotFilmService;
	
	ASINetworkQueue *imageQueue;
	
	NSMutableArray *filmList;
	NSMutableArray *showList;
	//retain download film image
	NSMutableArray *filmImageList;

	
	NSString *todayStr;
	NSString *tomorrowStr;
	UILabel *todayLabel;
	UILabel *tomorrowLabel;
	
	UIImage *filmBgImg;
	UIView *contentView;
	UITableView *filmTableView;
	UIImageView *cinemaImgView;
	UILabel *addressLabel;
	UILabel *onlineOrderLabel;
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;

@property (nonatomic, retain) YXTHotFilmService *hotFilmService;
@property (nonatomic, retain) YXTShowService *showService;

@property (nonatomic, retain) ASINetworkQueue *imageQueue;

@property (nonatomic, retain) NSMutableArray *filmList;
@property (nonatomic, retain) NSMutableArray *showList;

@property (nonatomic, retain) NSMutableArray *filmImageList;

@property (nonatomic, copy) NSString *todayStr;
@property (nonatomic, copy) NSString *tomorrowStr;

@property (nonatomic, retain) UILabel *todayLabel;
@property (nonatomic, retain) UILabel *tomorrowLabel;

@property (nonatomic, retain) UIImage *filmBgImg;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) UITableView *filmTableView;
@property (nonatomic, retain) IBOutlet UIImageView *cinemaImgView;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *onlineOrderLabel;

@end
