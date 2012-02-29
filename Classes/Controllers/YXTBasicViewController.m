    //
//  YXTBasicViewController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-11.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTBasicViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DSActivityView.h"

@implementation YXTBasicViewController

@synthesize useBezelStyle, useKeyboardStyle;
@synthesize responseMessage, waitingMessage, waitingWidth;
@synthesize showKeyboard, coverNavBar, useNetworkActivity;


-(void)dealloc{
	[waitingMessage release];
	[responseMessage release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

-(id)init{
	if (self = [super init]) {
		[self setUseNetworkActivity:YES];
		self.useBezelStyle = YES;
		//self.coverNavBar = YES;
		self.waitingWidth = 150.0;
	
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(displayRequestFailedActivityView) 
													 name:START_SHOW_REQUEST_FAILED_ERROR
												   object:nil];
		
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
}

-(BOOL) showNavigationBackButton{
	return YES;
}

-(void)displayServerErrorActivityView{
	self.waitingMessage = @"服务端出错，请稍候重试";
	
	self.useBezelStyle = YES;
	//self.coverNavBar = YES;
	
	[self performSelector:@selector(displayActivityView)];
	[self performSelector:@selector(removeActivityView) withObject:nil afterDelay:2.0];
}

-(void)displayNetWorkErrorActivityView{
	self.waitingMessage = @"网络错误，请检查网络";
	
	self.useBezelStyle = YES;
	//self.coverNavBar = YES;
	
	[self performSelector:@selector(displayActivityView)];
	[self performSelector:@selector(removeActivityView) withObject:nil afterDelay:2.0];
}

-(void)displayRequestFailedActivityView{
	self.responseMessage = @"请求失败";
	[self displayChangeActivityView];
}

-(void)displayActivityView{
	UIView *viewToUse = self.view;
    
    // Perhaps not the best way to find a suitable view to cover the navigation bar as well as the content?
    if (self.coverNavBar)
        viewToUse = self.navigationController.navigationBar.superview;

	// Display the appropriate activity style, with custom label text.  The width can be omitted or zero to use the text's width:
	if (self.useKeyboardStyle)
		[DSKeyboardActivityView newActivityViewWithLabel:self.waitingMessage];
	else if (self.useBezelStyle)
		[DSBezelActivityView newActivityViewForView:viewToUse withLabel:self.waitingMessage width:self.waitingWidth];
	else
		[DSActivityView newActivityViewForView:viewToUse withLabel:self.waitingMessage width:self.waitingWidth];

	// If this is YES, the network activity indicator in the status bar is shown, and automatically hidden when the activity view is removed.  This property can be toggled on and off as needed:
    if (self.useNetworkActivity)
        [DSActivityView currentActivityView].showNetworkActivityIndicator = YES;	
}


- (void)displayChangeActivityView{
    // Change the label text for the currently displayed activity view:
    [DSActivityView currentActivityView].activityLabel.text = self.responseMessage;
    
    // Disable the network activity indicator in the status bar, e.g. after downloading data and starting parsing it (don't have to disable it if simply removing the view):
    if (self.useNetworkActivity)
        [DSActivityView currentActivityView].showNetworkActivityIndicator = NO;
    
    [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:2.0];
}

- (void)removeActivityView;
{
    // Remove the activity view, with animation for the two styles that support it:
    if (self.useKeyboardStyle)
        [DSKeyboardActivityView removeViewAnimated:YES];
    else if (self.useBezelStyle)
        [DSBezelActivityView removeViewAnimated:YES];
    else
        [DSActivityView removeView];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	NSLog(@"did receive memory warning");
    // Release any cached data, images, etc. that aren't in use.
}

@end
