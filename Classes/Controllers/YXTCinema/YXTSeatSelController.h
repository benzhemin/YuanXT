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
@class YXTOrderService;
@class YXTShowInfo;
@class YXTSeatInfo;
@class YXTSeatBackView;


@interface YXTSeatSelController : YXTBasicViewController<UIScrollViewDelegate>{
    YXTSeatService *seatService;
    YXTOrderService *orderService;
    
    YXTShowInfo *showInfo;
    
    NSMutableArray *seatList;
    
    int totalCounts;
    NSMutableArray *pickList;
    
	UIView *contentView;
    YXTSeatBackView *seatBackView;
	
	UILabel *cinemaNameLabel;
	UILabel *hallNameLabel;
	UILabel *showDateLabel;
	
	UILabel *seatSelLabel;
	
	UIScrollView *scrollview;
}
@property (nonatomic, retain) YXTSeatService *seatService;
@property (nonatomic, retain) YXTOrderService *orderService;

@property (nonatomic, retain) YXTShowInfo *showInfo;

@property (nonatomic, retain) NSMutableArray *seatList;
@property (nonatomic, retain) NSMutableArray *pickList;

@property (nonatomic, assign) int totalCounts;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) YXTSeatBackView *seatBackView;

@property (nonatomic, retain) IBOutlet UILabel *cinemaNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *hallNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *showDateLabel;

@property (nonatomic, retain) IBOutlet UILabel *seatSelLabel;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

-(void)requestSeatService;
-(IBAction)pressSubmitSeat:(id)sender;

-(void)selectCinemaSeat:(YXTSeatInfo *)seatInfo;
-(void)deSelectCinemaSeat:(YXTSeatInfo *)seatInfo;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end
