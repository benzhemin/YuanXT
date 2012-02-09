//
//  YXTTabBarController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YXTFilmTabController.h"
#import "YXTCinimaTabController.h"
#import "YXTHelpTabController.h"


@interface YXTTabBarController : UITabBarController<UITabBarDelegate> {
	YXTFilmTabController *_filmViewController;
	YXTCinimaTabController *_cinimaViewController;
	YXTHelpTabController *_helpViewController;
	
	int prePageNum;
}

@end
