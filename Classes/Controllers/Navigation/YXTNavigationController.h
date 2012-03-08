//
//  YXTNavigationController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTNavigationController : UINavigationController {

}

- (void) addNavigationBarImage:(UIImage *)backgroundImage;
- (void)addTitleLabelToViewController:(UIViewController*)viewController;
-(void)addBackBtnToViewController:(UIViewController *)viewController;

@end
