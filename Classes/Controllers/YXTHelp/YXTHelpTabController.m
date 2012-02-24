    //
//  YXTHelpTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTHelpTabController.h"


@implementation YXTHelpTabController

@synthesize scrollview;

- (void)dealloc {
	[scrollview release];
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
	}
	return self;
}

-(void)viewDidLoad{
	//scrollview.contentSize = CGSizeMake(295, 480);
	scrollview.showsVerticalScrollIndicator = NO;
	[super viewDidLoad];
}

-(NSString *)getTabTitle{ return @"帮助"; }
-(NSString *)getTabImage{ return @"icon_help.png"; }
-(int) getTabTag{ return 3; }

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

@end
