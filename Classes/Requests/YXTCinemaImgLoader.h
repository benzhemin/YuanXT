//
//  YXTCinemaImgLoader.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-22.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownLoader.h"

@class YXTCinemaInfo;

@interface YXTCinemaImgLoader : ImageDownLoader {
	YXTCinemaInfo *cinemaInfo;
}

@property (nonatomic, retain) YXTCinemaInfo *cinemaInfo;

@end
