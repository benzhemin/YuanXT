//
//  YXTUIImageView.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-18.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTUIImageView.h"


@implementation YXTUIImageView

@synthesize spiner;

-(void)dealloc{
	[spiner release];
	[super dealloc];
}

-(void)addAnimateLoadingImage{
	if (!self.spiner) {
		self.spiner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
		spiner.bounds = CGRectMake(0, 0, 50, 50);
		spiner.center = self.center;
		[self addSubview:spiner];
	}
}

-(void)startAnimateLoadingImage{
	if (self.spiner) {
		[spiner startAnimating];
	}
}

-(void)stopAnimateLoadingImage{
	if (self.spiner) {
		[spiner stopAnimating];
	}
}


@end
