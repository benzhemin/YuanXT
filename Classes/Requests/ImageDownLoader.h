//
//  ImageDownLoader.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-17.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "YXTBasicViewController.h"

@interface ImageDownLoader : ASIHTTPRequest {
	NSData *imgData;
}

@property (nonatomic, retain) NSData *imgData;

@end
