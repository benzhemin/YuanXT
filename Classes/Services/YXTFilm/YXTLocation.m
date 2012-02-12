//
//  YXTLocation.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTLocation.h"
#import "OFReachability.h"
#import "NSNotificationCenter+OF.h"
#import "YXTBasicViewController.h"
#import "OFXPRequest.h"

@implementation YXTLocation
	
-(id)init{
	if (self=[super init]) {
		
	}
	return self;
}

-(void)startToFetchCityList{
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:START_FADEIN_WAITING object:nil];
	
	if ([OFReachability isConnectedToInternet]) {
		
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
    //OFSafeRelease(mCurrentRequest);
    if(responseCode == 200){
        
    }
    else{
		
	}
}

@end
