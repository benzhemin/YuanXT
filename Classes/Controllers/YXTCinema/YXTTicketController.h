//
//  YXTTicketController.h
//  YuanXT
//
//  Created by zhe zhang on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTBasicViewController.h"

@class YXTOrderInfo;
@class YXTShowInfo;

@interface YXTTicketController : YXTBasicViewController{
    YXTOrderInfo *orderInfo;
    YXTShowInfo *showInfo;
    
    NSMutableArray *pickList;
    
    UIView *contentView;
    
	UILabel *partnerNameLabel;
	UILabel *filmNameLabel;
	UILabel *cinemaNameLabel;
	UILabel *showSeqLabel;
	UILabel *seatStrLabel;
	UILabel *goodsCountLabel;
	UILabel *ticketPriceLabel;
	UILabel *ratingLabel;
	UILabel *txnAmountLabel;
}

@property (nonatomic, retain) YXTOrderInfo *orderInfo;
@property (nonatomic, retain) YXTShowInfo *showInfo;

@property (nonatomic, retain) NSMutableArray *pickList;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UILabel *partnerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *filmNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *cinemaNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *showSeqLabel;
@property (nonatomic, retain) IBOutlet UILabel *seatStrLabel;
@property (nonatomic, retain) IBOutlet UILabel *goodsCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *ticketPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *ratingLabel;
@property (nonatomic, retain) IBOutlet UILabel *txnAmountLabel;

@end
