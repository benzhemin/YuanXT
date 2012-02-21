//
//  YXTCinimaTabController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicTabController.h"

@class YXTFilmInfo;
@class YXTCinemaService;

@interface YXTCinemaTabController : YXTBasicTabController <UITableViewDelegate, UITableViewDataSource> {
	YXTFilmInfo *filmInfo;
	YXTCinemaService *cinimaService;
	
	NSMutableArray *cinemaDistrictList;
	
	UITableView *cinemaTableView;
}

@property (nonatomic, retain) YXTFilmInfo *filmInfo;
@property (nonatomic, retain) YXTCinemaService *cinimaService;
@property (nonatomic, retain) NSMutableArray *cinemaDistrictList;

@property (nonatomic, retain) UITableView *cinemaTableView;

-(void)refreshCinemaListTable;
-(void)fetchCinemaDistrictListSucceed:(NSMutableArray *)districtList;

@end



@interface YXTCinemaTabController(Private) 

-(void)setUpUINavigationBarItem;

@end