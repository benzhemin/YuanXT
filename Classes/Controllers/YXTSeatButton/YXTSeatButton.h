//
//  YXTSeatButton.h
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTSeatSelController;
@class YXTSeatInfo;

typedef enum{
    //可选
    seat_can_select = 0,
    
    //本人锁定未购买
    seat_self_lock = 10,
    //本人购买
    seat_already_select = 11,
    //已售
    seat_sold
}StatusType;

#define SEL_MAX_SEAT 4

@interface YXTSeatButton : UIImageView{
    StatusType curStatus;
    YXTSeatSelController *delegateSeat;
    
    YXTSeatInfo *seatInfo;
}

@property (nonatomic, assign) YXTSeatSelController *delegateSeat;
@property (nonatomic, retain) YXTSeatInfo *seatInfo;

-(id)initStatus:(StatusType)status;
-(void)setSeatStatus:(StatusType) status;

@end

