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
#define START_SHOW_REQUEST_FAILED_ERROR @"START_SHOW_REQUEST_FAILED_ERROR"

@interface YXTBasicViewController : UIViewController {
	
	NSString *waitingMessage;
	NSUInteger waitingWidth;
	NSString *responseMessage;
	
	BOOL useBezelStyle;
    BOOL useKeyboardStyle;
    BOOL showKeyboard;
    BOOL coverNavBar;
    BOOL useNetworkActivity;	
}

@property (nonatomic, copy) NSString *waitingMessage;
@property (nonatomic) NSUInteger waitingWidth;
@property (nonatomic, copy) NSString *responseMessage;
@property (nonatomic) BOOL useBezelStyle;
@property (nonatomic) BOOL useKeyboardStyle;
@property (nonatomic) BOOL showKeyboard;
@property (nonatomic) BOOL coverNavBar;
@property (nonatomic) BOOL useNetworkActivity;

-(BOOL) showNavigationBackButton;


-(void)displayServerErrorActivityView;
-(void)displayNetWorkErrorActivityView;
-(void)displayRequestFailedActivityView;
-(void)displayActivityView;
- (void)displayChangeActivityView;
-(void)removeActivityView;

@end

