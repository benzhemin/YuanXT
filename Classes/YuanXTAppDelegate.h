//
//  YuanXTAppDelegate.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012  Ideal Information Industry All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTTabBarController;

@interface YuanXTAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    YXTTabBarController *_tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

