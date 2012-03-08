//
//  YXTCinemaDetailController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-27.
//  Copyright 2012 benzhemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicViewController.h"

@class YXTCinemaInfo;

@interface YXTCinemaDetailController : YXTBasicViewController {
	YXTCinemaInfo *cinemaInfo;
	
    UIView *contentView;
    
	UILabel *addressLabel;
	UILabel *cinemaBusLineLabel;
	UILabel *onlineOrderLabel;
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;

@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cinemaBusLineLabel;
@property (nonatomic, retain) IBOutlet UILabel *onlineOrderLabel;

@end
