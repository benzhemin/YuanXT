    //
//  YXTTabController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-10.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTBasicTabController.h"


@implementation YXTBasicTabController


-(id)init{
	if (self = [super init]) {
		self.title = [self getNavTitle];
		UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:[self getTabTitle] 
															  image:[UIImage imageNamed:[self getTabImage]] 
																tag:[self getTabTag]];
		self.tabBarItem = barItem;
		[barItem release];		
	}
	return self;
}

-(NSString *)getNavTitle{
	return nil;
}

-(NSString *)getTabTitle{
	return nil;
}

-(NSString *)getTabImage{
	return nil;
}

-(int) getTabTag{
	return 0;
}
 
@end
