//
//  YXTFilmDetailController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-27.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTFilmDetailController.h"
#import "YXTNavigationBarView.h"
#import "YXTHotFilmService.h"

@implementation YXTFilmDetailController

@synthesize filmInfo, imgLoader;

@synthesize contentView, filmImageView;

@synthesize filmNameLabel;
@synthesize directorLabel, mainPerformerLabel, durationLabel;
@synthesize filmClassLabel, areaLabel, ycTimeLabel;

@synthesize descriptionText;

-(void)dealloc{
	[filmInfo release];
	[imgLoader release];
    
    [contentView release];
	[filmImageView release];
	
	[filmNameLabel release];
	[directorLabel release];
	[mainPerformerLabel release];
	[durationLabel release];
	[filmClassLabel release];
	[areaLabel release];
	[ycTimeLabel release];
	
	[descriptionText release];
	[super dealloc];
}


-(void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
	[naviView addTitleLabelToBar:@"电影详情"];
	[self.view addSubview:naviView];
	[naviView release];
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];
	
	[descriptionText setFont:[UIFont boldSystemFontOfSize:15.0f]];
	
	filmNameLabel.text = filmInfo.filmName;
	directorLabel.text = filmInfo.director;
	mainPerformerLabel.text = filmInfo.mainPerformer;
	durationLabel.text = filmInfo.duration;
	filmClassLabel.text = filmInfo.filmClass;
	areaLabel.text = filmInfo.area;
	ycTimeLabel.text = filmInfo.ycTime;
	
	descriptionText.text = filmInfo.description;
	
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	self.imgLoader = [ImageDownLoader requestWithURL:[NSURL URLWithString:filmInfo.webPoster]];
	imgLoader.reqDelegate = self;
	[imgLoader startAsynchronous];
}

-(void)imageRequestFinished:(NSDictionary *)userInfo{
	UIImage *image = [[UIImage alloc] initWithData:[imgLoader imgData]];
	[filmImageView setImage:image];	
	[image release];
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
