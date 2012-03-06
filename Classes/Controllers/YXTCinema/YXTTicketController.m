//
//  YXTTicketController.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTTicketController.h"
#import "YXTOrderService.h"
#import "YXTShowService.h"
#import "YXTNavigationBarView.h"
#import "YXTSeatService.h"

@implementation YXTTicketController

@synthesize orderInfo, showInfo;
@synthesize pickList;
@synthesize contentView;
@synthesize partnerNameLabel, filmNameLabel, cinemaNameLabel, showSeqLabel;
@synthesize seatStrLabel, goodsCountLabel, ticketPriceLabel, ratingLabel, txnAmountLabel;

-(void)dealloc{
    [orderInfo release];
    [showInfo release];
    
    [pickList release];
    
    [contentView release];
    
	[partnerNameLabel release];
	[filmNameLabel release];
	[cinemaNameLabel release];
	[showSeqLabel release];
	
	[seatStrLabel release];
	[goodsCountLabel release];
	[ticketPriceLabel release];
	[ratingLabel release];
	[txnAmountLabel release];
	
	[super dealloc];
}

-(id)init{
    if (self=[super init]) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
    [naviView addTitleLabelToBar:@"票务详情"];
    [naviView addFunctionIconToBar:[UIImage imageNamed:@"btn_zhifu.png"]];
    [self.view addSubview:naviView];
	[naviView release];
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];

    
    partnerNameLabel.text = orderInfo.partnerName;
    filmNameLabel.text = showInfo.filmName;
    cinemaNameLabel.text = showInfo.cinemaName;
    showSeqLabel.text = [NSString stringWithFormat:@"%@ %@  %@", showInfo.showDate, showInfo.showTime, showInfo.hallName];
    
    NSMutableString *pickStr = [NSMutableString string];
    for (YXTSeatInfo *seatInfo in pickList) {
        [pickStr appendFormat:@"%@排%@座  ", seatInfo.rowId, seatInfo.columnId];
    }
    
    seatStrLabel.text = pickStr;
    goodsCountLabel.text = orderInfo.goodsCount;
    ticketPriceLabel.text = showInfo.bestPayPrice;
    ratingLabel.text = orderInfo.rating;
    txnAmountLabel.text = orderInfo.txnAmount;
    
    [super viewDidLoad];
}

-(IBAction)popToPreviousViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)funcToViewController:(id)sender{
	
}


@end
