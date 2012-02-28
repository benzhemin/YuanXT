//
//  YXTNavigationBarView.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-25.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTNavigationBarView.h"
#import "YXTSettings.h"
#import "YXTCinemaService.h"


@implementation YXTNavigationBarView

@synthesize delegateCtrl;
@synthesize cityBtn;

-(void)dealloc{
	[cityBtn release];
	[super dealloc];
}

-(id)init{
	UIImage *bgImg = [UIImage imageNamed:@"bg_titlearea.png"];
	CGRect barFrame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
	if (self=[super initWithFrame:barFrame]) {
		[self setImage:bgImg];
		self.userInteractionEnabled = YES;
	}
	return self;
}

-(void)addBackIconToBar:(UIImage *)img{
	CGRect iconFrame = CGRectMake(0.f, 0.f, img.size.width, img.size.height);
	UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[iconButton addTarget:delegateCtrl action:@selector(popToPreviousViewController:) forControlEvents:UIControlEventTouchUpInside];
	UIImageView *backImgView = [[UIImageView alloc] initWithImage:img];
	iconButton.frame = backImgView.bounds = iconFrame;
	
	[iconButton addSubview:backImgView];
	[backImgView release];
	
	iconButton.center = CGPointMake(25, self.center.y);
	[self addSubview:iconButton];
	
}

-(void)addFunctionIconToBar:(UIImage *)img{
	//strech icon width and height because the artisan not professional
	CGRect iconFrame = CGRectMake(0.f, 0.f, img.size.width+15.0, img.size.height+6.0);
	UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[iconButton addTarget:delegateCtrl action:@selector(funcToViewController:) forControlEvents:UIControlEventTouchUpInside];
	UIImageView *rightImgView = [[UIImageView alloc] initWithImage:img];
	iconButton.bounds = rightImgView.bounds = iconFrame;
	
	[iconButton addSubview:rightImgView];
	[rightImgView release];
	
	iconButton.center = CGPointMake(285, self.center.y+3.0);
	[self addSubview:iconButton];
}

-(void)addCitySwitchIconToBar{
	self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cityBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *cityImg = [UIImage imageNamed:@"dropselect.png"];
	[cityBtn setFrame:CGRectMake(0, 0, cityImg.size.width+15.0, cityImg.size.height+8.0)];
	cityBtn.center = CGPointMake(275, self.center.y);
	[cityBtn setBackgroundImage:cityImg forState:UIControlStateNormal];
	[cityBtn addTarget:delegateCtrl action:@selector(pressCitySwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
	[[cityBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2.0, -11.0, 0.0, 0.0)];
	[cityBtn setTitle:[[YXTSettings instance].cityInfo cityName] forState:UIControlStateNormal];
	
	[self addSubview:cityBtn];
}

- (void)addTitleLabelToBar:(NSString *)title{
	UILabel* titleLabel = [[[UILabel alloc] init] autorelease];
	titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
	titleLabel.text = title;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.shadowColor = [UIColor lightGrayColor];
	titleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	const float shadowOffset = 1.f;
	titleLabel.shadowOffset = CGSizeMake(-shadowOffset, shadowOffset);
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = [titleLabel textRectForBounds:CGRectMake(0.f, 0.f, 260.f, 30.f) limitedToNumberOfLines:1];
	titleLabel.center = self.center;
	[self addSubview:titleLabel];
}

@end
