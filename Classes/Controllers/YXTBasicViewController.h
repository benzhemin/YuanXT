//
//  YXTBasicViewController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-11.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>


#define START_FADEIN_WAITING @"START_FADEIN_WAITING"
#define START_FADEOUT_WAITING @"START_FADEOUT_WAITING"
#define START_FADEIN_NETWORK_ERROR @"START_FADEIN_NETWORK_ERROR"

@interface YXTBasicViewController : UIViewController {
	UIView *waitingView;
	UILabel *waitingLabel;
}

-(BOOL) showNavigationBackButton;

-(void)setWaitingMessage:(NSString *)message;

-(void)startFadeInWaitingView;
-(void)startFadeOutWaitingView;

@end

