//
//  SeatBackView.h
//  yuanxiantong
//
//  Created by zhe zhang on 11-4-25.
//  Copyright 2011 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXTSeatSelController;

@interface YXTSeatBackView : UIView <UIGestureRecognizerDelegate> {
    YXTSeatSelController *delegateSeat;
	
	CGRect origionRect;

	CGFloat initialscale;
}

@property (nonatomic, assign) YXTSeatSelController *delegateSeat;

- (void)addGestureRecognizersView:(UIView *)uiview;

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer ;

-(IBAction)stretchToInitial:(id)sender;
@end
