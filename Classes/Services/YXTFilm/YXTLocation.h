//
//  YXTLocation.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-12.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicViewController.h"

@interface YXTLocation : NSObject <OFXPResponseJSON>{
	YXTBasicViewController *delegateFilm;
	OFXPRequest *mReq;
}

@property (nonatomic, assign) YXTBasicViewController *delegateFilm;

-(void)startToFetchCityList;

@end
