//
//  YXTSeatButton.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTSeatButton.h"
#import "YXTSeatSelController.h"
#import "YXTSeatService.h"

@implementation YXTSeatButton

@synthesize seatInfo;
@synthesize delegateSeat;

-(void)dealloc{
    [seatInfo release];
    [super release];
}

-(id)initStatus:(StatusType)status{
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, 11, 18);
        [self setSeatStatus:status];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void)setSeatStatus:(StatusType) status{
    curStatus = status;
    switch (status) {
        case seat_can_select:
            [self setImage:[UIImage imageNamed:@"icon_keshou.png"]];
            break;
        case seat_self_lock:
        case seat_already_select:
            [self setImage:[UIImage imageNamed:@"icon_xuanzhong.png"]];
            break;
        case seat_sold:
        default:
            [self setImage:[UIImage imageNamed:@"icon_yishou.png"]];
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //CGPoint point = [self convertPoint:self.center toView:[self superview]];
    
    if (curStatus == seat_can_select) {
        
        if (delegateSeat.totalCounts >= SEL_MAX_SEAT) {
            [delegateSeat setWaitingMessage:@"最多只能选4个座位"];
            [delegateSeat displayActivityView];
            [delegateSeat performSelector:@selector(removeActivityView) withObject:nil afterDelay:1.5];
            return ;
        }
        [self setSeatStatus:seat_already_select];
        [delegateSeat selectCinemaSeat:seatInfo];
        
    }else if (curStatus == seat_already_select){

        if (delegateSeat.totalCounts <=0) {
            NSLog(@"count error");
        }
        [self setSeatStatus:seat_can_select];
        [delegateSeat deSelectCinemaSeat:seatInfo];
        
    }else if (curStatus == seat_sold){
        
    }
}

@end
