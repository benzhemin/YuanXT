//
//  YXTFileTabController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicTabController.h"
#import "OFXPRequest.h"

@class YXTLocation;

@interface YXTFilmTabController : YXTBasicTabController{
	YXTLocation *location;
}

@property (nonatomic, retain) YXTLocation *location;

@end
