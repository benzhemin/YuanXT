//
//  YXTCinemaImgLoader.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-22.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTCinemaImgLoader.h"
#import "YXTCinemaService.h"

@implementation YXTCinemaImgLoader

@synthesize cinemaInfo;

-(void)processImageData{
	UIImage *cinemaImg = [[UIImage alloc] initWithData:self.imgData];
	self.cinemaInfo.cinemaImage = cinemaImg;
	[cinemaImg release];
}

-(void)dealloc{
	[cinemaInfo release];
	[super dealloc];
}



@end
