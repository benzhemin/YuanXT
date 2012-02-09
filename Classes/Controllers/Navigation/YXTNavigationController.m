    //
//  YXTNavigationController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTNavigationController.h"


@implementation YXTNavigationController


- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if (self = [super initWithRootViewController:rootViewController]) 
	{
		[self.navigationBar setBarStyle:UIBarStyleDefault];
	}
	return self;
}

- (void) addNavigationBarImage:(UIImage *)backgroundImage 
{
	UIImageView * imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	[self.navigationBar addSubview:imageView];
	[imageView release];
}

- (void)dealloc {
    [super dealloc];
}


@end
