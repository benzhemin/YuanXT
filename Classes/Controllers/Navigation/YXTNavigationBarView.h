//
//  YXTNavigationBarView.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-25.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXTNavigationBarView : UIImageView {
	id delegateCtrl;
	
	UIButton *cityBtn;
}

@property (nonatomic, assign) id delegateCtrl;
@property (nonatomic, retain) UIButton *cityBtn;

-(void)addBackIconToBar:(UIImage *)img;
-(void)addFunctionIconToBar:(UIImage *)img;
-(void)addCitySwitchIconToBar;
- (void)addTitleLabelToBar:(NSString *)title;

@end
