//
//  YXTHelpTabController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicTabController.h"

@interface YXTHelpTabController : YXTBasicTabController {
	UIScrollView *scrollview;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

@end
