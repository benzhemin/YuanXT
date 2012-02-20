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

@interface YXTCinemaTabController : YXTBasicTabController {
	YXTFilmInfo *filmInfo;
}

@property (nonatomic, retain) YXTFilmInfo *filmInfo;

-(void)refreshCinemaListTable;

@end



@interface YXTCinemaTabController(Private) 

-(void)setUpUINavigationBarItem;

@end