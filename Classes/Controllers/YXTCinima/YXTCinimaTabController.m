    //
//  YXTCinimaTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTCinimaTabController.h"


@implementation YXTCinimaTabController

-(id)init{
	if (self=[super init]) {
	}
	return self;
}

-(NSString *)getTabTitle{
	return @"影院";
}

-(NSString *)getTabImage{
	return @"icon_yingyuan_xuanzhong.png";
}

-(int) getTabTag{
	return 2;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
