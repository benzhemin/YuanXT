//
//  YXTFilmShowOrderController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTFilmShowController.h"
#import "YXTCinemaService.h"
#import "YXTHotFilmService.h"
#import "YXTCinemaDetailController.h"

@implementation YXTFilmShowController

@synthesize cinemaInfo, filmInfo;
@synthesize todayStr, tomorrowStr;
@synthesize contentView;
@synthesize cinemaImgView, addressLabel, onlineOrderLabel;

-(void)dealloc{
	[cinemaInfo release];
	[filmInfo release];
	
	[todayStr release];
	[tomorrowStr release];
	
	[contentView release];
	
	[cinemaImgView release];
	[addressLabel release];
	[onlineOrderLabel release];
	[super dealloc];
}

-(void)setUpCurrentDate{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:60*60*24L];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	self.todayStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:todayDate]];
	self.tomorrowStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:tomorrowDate]];
	
	
}

-(void)viewDidLoad{
	[self setUpCurrentDate];
	
	
	
	
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	
}

-(void)pushToCinemaDetailController{
	YXTCinemaDetailController *cinemaDetailController = [[YXTCinemaDetailController alloc] init];
	cinemaDetailController.cinemaInfo = cinemaInfo;
	[self.navigationController pushViewController:cinemaDetailController animated:YES];
	[cinemaDetailController release];
}

@end
