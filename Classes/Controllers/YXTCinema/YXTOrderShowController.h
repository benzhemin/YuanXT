//
//  YXTOrderShowController.h
//  YuanXT
//
//  Created by benzhemin on 12-3-1.
//  Copyright (c) 2012年 Ideal Information Industry. All rights reserved.
//

#import "YXTBasicViewController.h"
#import "YXTFilmShowController.h"

@class YXTCinemaInfo;
@class YXTFilmInfo;
@class YXTShowService;

@interface YXTOrderShowController : YXTBasicViewController <UITableViewDelegate, UITableViewDataSource>{
	YXTCinemaInfo *cinemaInfo;
	YXTFilmInfo *filmInfo;
	
	YXTShowService *showService;
	
	NSMutableArray *showList;
	
	UIView *contentView;
	
    UIImage *seatImg;
	UITableView *orderTableView;
	
	UILabel *cinemaLabel;
	UILabel *filmLabel;
	
	enum Film_Date_Tag dateTag;
	UIImageView *dateSegImgView;
	NSString *selectDateStr;
	NSString *todayStr;
	NSString *tomorrowStr;
	UILabel *todayLabel;
	UILabel *tomorrowLabel;
	
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;
@property (nonatomic, retain) YXTFilmInfo *filmInfo;

@property (nonatomic, retain) YXTShowService *showService;

@property (nonatomic, retain) NSMutableArray *showList;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UILabel *cinemaLabel;
@property (nonatomic, retain) IBOutlet UILabel *filmLabel;

@property (nonatomic, retain) UIImage *seatImg;
@property (nonatomic, retain) UITableView *orderTableView;

@property (nonatomic, retain) UIImageView *dateSegImgView; 
@property (nonatomic, copy) NSString *selectDateStr;
@property (nonatomic, copy) NSString *todayStr;
@property (nonatomic, copy) NSString *tomorrowStr;

@property (nonatomic, retain) UILabel *todayLabel;
@property (nonatomic, retain) UILabel *tomorrowLabel;

-(IBAction)pushToFilmDetailController:(id)sender;
-(void)requestShowService;

@end
