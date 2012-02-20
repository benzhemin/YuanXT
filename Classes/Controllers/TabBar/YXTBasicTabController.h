//
//  YXTTabController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-10.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicViewController.h"

@interface YXTBasicTabController : YXTBasicViewController {

}

-(id)initWithTab;

-(NSString *)getNavTitle;
-(NSString *)getTabTitle;
-(NSString *)getTabImage;
-(int) getTabTag;

@end
