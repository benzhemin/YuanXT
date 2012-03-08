//
//  YXTTabBarController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YXTFilmTabController.h"
#import "YXTCinemaTabController.h"
#import "YXTHelpTabController.h"


@interface YXTTabBarController : UITabBarController<UITabBarDelegate> {
	YXTFilmTabController *_filmViewController;
	YXTCinemaTabController *_cinimaViewController;
	YXTHelpTabController *_helpViewController;
	
	int prePageNum;
}

@end
