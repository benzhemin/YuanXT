    //
//  YXTTabBarController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTTabBarController.h"
#import "YXTNavigationController.h"

@implementation YXTTabBarController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_filmViewController = [[YXTFilmTabController alloc] init];
	_cinimaViewController = [[YXTCinimaTabController alloc] init];
	_helpViewController = [[YXTHelpTabController alloc] init];
	
	YXTNavigationController *filmNavigation = [[YXTNavigationController alloc] initWithRootViewController:_filmViewController];
	YXTNavigationController *cinimaNavigation = [[YXTNavigationController alloc] initWithRootViewController:_cinimaViewController];
	YXTNavigationController *helpNavigation = [[YXTNavigationController alloc] initWithRootViewController:_helpViewController];
	[_filmViewController release];
	[_cinimaViewController release];
	[_helpViewController release];
	
	NSArray *tabArray = [NSArray arrayWithObjects:filmNavigation, cinimaNavigation, helpNavigation, nil];
	[filmNavigation release];
	[cinimaNavigation release];
	[helpNavigation release];
	
	[self setViewControllers:tabArray];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	prePageNum = self.selectedIndex;
	switch (item.tag) 
	{
		case 1:
			break;
		case 2:
			break;
		case 3:
			break;
	}
}


@end
