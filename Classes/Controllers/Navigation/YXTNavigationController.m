    //
//  YXTNavigationController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTNavigationController.h"
#import "YXTBasicViewController.h"

@implementation YXTNavigationController


- (id)initWithRootViewController:(UIViewController *)rootViewController{
	if (self = [super initWithRootViewController:rootViewController]) {
		/*
		
		[self addNavigationBarImage:[UIImage imageNamed:@"bg_titlearea.png"]];
		[self addTitleLabelToViewController:rootViewController];
		[self addBackBtnToViewController:rootViewController];
		 
		*/
	}
	return self;
}

- (void) addNavigationBarImage:(UIImage *)backgroundImage {	
	CGRect bgFrame = CGRectMake(0.f, 0.f, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
	
	UIImageView * mNavBarBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	mNavBarBackgroundView.frame = bgFrame;
	mNavBarBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mNavBarBackgroundView.userInteractionEnabled = NO;
	[self.navigationBar addSubview:mNavBarBackgroundView];
	//[self.navigationBar insertSubview:mNavBarBackgroundView atIndex:0];
	//[self.navigationBar sendSubviewToBack:mNavBarBackgroundView];
	
	[mNavBarBackgroundView release];
}

- (void)addTitleLabelToViewController:(UIViewController*)viewController{
	UILabel* titleLabel = [[[UILabel alloc] init] autorelease];
	titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
	titleLabel.text = viewController.title;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.shadowColor = [UIColor lightGrayColor];
	titleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	const float shadowOffset = 1.f;
	titleLabel.shadowOffset = CGSizeMake(-shadowOffset, shadowOffset);
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = [titleLabel textRectForBounds:CGRectMake(0.f, 0.f, 250.f, 30.f) limitedToNumberOfLines:1];
	viewController.navigationItem.titleView = titleLabel;
}

-(void)addBackBtnToViewController:(UIViewController *)viewController{
	if ([viewController respondsToSelector:@selector(showNavigationBackButton)]) {
		if (![(YXTBasicViewController *)viewController showNavigationBackButton]) {
			return;
		}
	}
	
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *backImg = [UIImage imageNamed:@"btn_back.png"];
	[backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
	[backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
	[backBtn setBackgroundImage:backImg forState:UIControlStateHighlighted];
	[backBtn addTarget:self action:@selector(popUpToPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];	
	viewController.navigationItem.leftBarButtonItem = backBar;
	//viewController.navigationItem.backBarButtonItem = backBar;
	
	[backBar release];
	
	//viewController.navigationItem.hidesBackButton = YES;
}

-(void)popUpToPreviousViewController{
	NSLog(@"pop up to hall");
}

- (void)dealloc {
    [super dealloc];
}


@end
