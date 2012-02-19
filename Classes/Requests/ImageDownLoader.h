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

@protocol ImageDownLoadDelegate

-(void)imageRequestFinished:(NSDictionary *)userInfo;

@end


@interface ImageDownLoader : ASIHTTPRequest {
	NSData *imgData;
	id<ImageDownLoadDelegate> reqDelegate;
}

@property (nonatomic, retain) NSData *imgData;
@property (nonatomic, assign) id<ImageDownLoadDelegate> reqDelegate; 

@end
