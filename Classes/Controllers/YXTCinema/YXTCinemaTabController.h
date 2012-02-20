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

@interface YXTCinemaTabController : YXTBasicTabController {
	YXTFilmInfo *filmInfo;
	YXTCinemaService *cinimaService;
}

@property (nonatomic, retain) YXTFilmInfo *filmInfo;
@property (nonatomic, retain) YXTCinemaService *cinimaService;

-(void)refreshCinemaListTable;

@end



@interface YXTCinemaTabController(Private) 

-(void)setUpUINavigationBarItem;

@end