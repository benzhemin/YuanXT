//
//  ImageDownLoader.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-17.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "ImageDownLoader.h"


@implementation ImageDownLoader

@synthesize imgData, reqDelegate;


- (void)requestFinished{
    [super requestFinished]; 
	
	if (self.responseStatusCode == 200) {
		NSLog(@"request finished:%@", self.originalURL.path);
		
		self.imgData = [self responseData];
			
		[(NSObject *)reqDelegate performSelectorOnMainThread:@selector(imageRequestFinished:) withObject:self.userInfo waitUntilDone:NO];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	NSLog(@"request failed!");
	[[NSNotificationCenter defaultCenter] postNotificationName:START_SHOW_REQUEST_FAILED_ERROR object:nil userInfo:nil];
}


-(void)dealloc{
	[imgData release];
	[super dealloc];
}

@end
