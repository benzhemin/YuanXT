//
//  YXTSeatSelController.h
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTBasicViewController.h"
#import "YXTSeatButton.h"

@class YXTSeatService;
@class YXTShowInfo;
@class YXTSeatInfo;


@interface YXTSeatSelController : YXTBasicViewController{
    YXTSeatService *seatService;
    YXTShowInfo *showInfo;
    
    NSMutableArray *seatList;
    
    int totalCounts;
    NSMutableArray *pickList;
    
	UIView *contentView;
	
	UILabel *cinemaNameLabel;
	UILabel *hallNameLabel;
	UILabel *showDateLabel;
	
	UILabel *seatSelLabel;
	
	UIScrollView *scrollview;
}
@property (nonatomic, retain) YXTSeatService *seatService;

@property (nonatomic, retain) YXTShowInfo *showInfo;

@property (nonatomic, retain) NSMutableArray *seatList;
@property (nonatomic, retain) NSMutableArray *pickList;

@property (nonatomic, assign) int totalCounts;

@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (nonatomic, retain) IBOutlet UILabel *cinemaNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *hallNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *showDateLabel;

@property (nonatomic, retain) IBOutlet UILabel *seatSelLabel;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

-(void)requestSeatService;
-(IBAction)pressSubmitSeat:(id)sender;

-(void)selectCinemaSeat:(YXTSeatInfo *)seatInfo;
-(void)deSelectCinemaSeat:(YXTSeatInfo *)seatInfo;

@end
