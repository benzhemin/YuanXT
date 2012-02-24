//
//  YXTHelpTabController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicTabController.h"

@interface YXTHelpTabController : YXTBasicTabController {
	IBOutlet UIScrollView *scrollview;
}

@property (nonatomic, retain) UIScrollView *scrollview;

@end
