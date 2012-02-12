    //
//  YXTBasicViewController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-11.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTBasicViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation YXTBasicViewController

-(void)dealloc{
	[waitingView release];
	[waitingLabel release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

-(id)init{
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(startFadeInWaitingView) 
													 name:START_FADEIN_WAITING
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(startFadeOutWaitingView) 
													 name:START_FADEOUT_WAITING
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setWaitingViewNetWorkError) 
													 name:START_FADEIN_NETWORK_ERROR
												   object:nil];
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	waitingView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)] ;
	waitingView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	waitingView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 45);
	waitingView.alpha = 0.0;
	waitingView.clipsToBounds = YES;
	if ([waitingView.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) waitingView.layer setCornerRadius: 10];
	
	waitingLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 5, waitingView.bounds.size.width, 15)];
	waitingLabel.backgroundColor = [UIColor clearColor];
	waitingLabel.textColor = [UIColor whiteColor];
	waitingLabel.textAlignment = UITextAlignmentCenter;
	waitingLabel.font = [UIFont boldSystemFontOfSize: 15];
	[waitingView addSubview:waitingLabel];
	
	UIActivityIndicatorView	*spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	spinner.center = CGPointMake(waitingView.bounds.size.width / 2, waitingView.bounds.size.height / 2 + 10);
	[waitingView addSubview: spinner];
	[self.view addSubview: waitingView];
	[spinner startAnimating];
}

-(BOOL) showNavigationBackButton{
	return YES;
}

-(void)setWaitingMessage:(NSString *)message{
	waitingLabel.text = message;
}

#define GROW_ANIMATION_STARTLOAD_DURATION_SECONDS 1.5
-(void)startFadeInWaitingView{
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:GROW_ANIMATION_STARTLOAD_DURATION_SECONDS];
	waitingView.alpha = 1.0;
	[UIView commitAnimations];
}

#define GROW_ANIMATION_FINISHLOAD_DURATION_SECONDS 1.5
-(void)startFadeOutWaitingView{
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration:GROW_ANIMATION_FINISHLOAD_DURATION_SECONDS];
	waitingView.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)setWaitingViewNetWorkError{
	waitingLabel.text = @"网络错误，请检查网络";
	
	[self startFadeInWaitingView];
	waitingView.alpha = 0.0;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	NSLog(@"did receive memory warning");
    // Release any cached data, images, etc. that aren't in use.
}

@end
