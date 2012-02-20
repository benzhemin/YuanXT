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

-(id)init{
	if (self = [super init]) {
		
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_filmViewController = [[YXTFilmTabController alloc] initWithTab];
	_cinimaViewController = [[YXTCinemaTabController alloc] initWithTab];
	_helpViewController = [[YXTHelpTabController alloc] initWithTab];
	
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
			NSLog(@"tab 1");
			break;
		case 2:
			NSLog(@"tab 2");
			break;
		case 3:
			NSLog(@"tab 3");
			break;
	}
}


@end
