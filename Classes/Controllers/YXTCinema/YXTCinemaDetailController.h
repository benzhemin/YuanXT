//
//  YXTCinemaDetailController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-27.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTCinemaInfo;

@interface YXTCinemaDetailController : UIViewController {
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
