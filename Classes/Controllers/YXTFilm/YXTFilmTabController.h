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
@class YXTActionSheet;
@class YXTPickerDelegate;

@interface YXTFilmTabController : YXTBasicTabController{
	YXTLocation *location;
	
	UIButton *cityBtn;
	YXTActionSheet *citySheet;
	UIPickerView *cityPicker;
	YXTPickerDelegate *cityPickerDelegate;
}

@property (nonatomic, retain) YXTLocation *location;

@property (nonatomic, retain) UIButton *cityBtn;
@property (nonatomic, retain) YXTActionSheet *citySheet;
@property (nonatomic, retain) UIPickerView *cityPicker;
@property (nonatomic, retain) YXTPickerDelegate *cityPickerDelegate;

@end
