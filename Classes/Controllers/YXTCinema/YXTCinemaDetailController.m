    //
//  YXTCinemaDetailController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-27.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTCinemaDetailController.h"
#import "YXTCinemaService.h"
#import "YXTNavigationBarView.h"
#import "YXTShowService.h"

@implementation YXTCinemaDetailController

@synthesize cinemaInfo;
@synthesize addressLabel, cinemaBusLineLabel, onlineOrderLabel;

- (void)dealloc {
	[cinemaInfo release];
	
	[addressLabel release];
	[cinemaBusLineLabel release];
	[onlineOrderLabel release];
	
	[super dealloc];
}

-(void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
	
	if (self.cinemaInfo != nil) {
		[naviView addTitleLabelToBar:self.cinemaInfo.cinemaName];
	}
	[self.view addSubview:naviView];
	[naviView release];
	
	if (self.cinemaInfo != nil) {
		addressLabel.text = self.cinemaInfo.address;
		cinemaBusLineLabel.text = self.cinemaInfo.cinemaBusLine;
		if ([cinemaInfo.onlineOrder isEqualToString:@"Y"]) {
			
		}else {
			onlineOrderLabel.text = @"不支持在线选座";
		}
	}
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	YXTShowService *showService = [[YXTShowService alloc] init];
	[showService startToFetchShowList];
	
}

-(IBAction)popToPreviousViewController:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
