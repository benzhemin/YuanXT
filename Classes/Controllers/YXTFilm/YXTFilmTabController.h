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
@class YXTCityInfo;
@class YXTHotFilm;

@class YXTActionSheet;
@class YXTPickerDelegate;


@interface YXTFilmTabController : YXTBasicTabController{
	YXTLocation *location;
	YXTCityInfo *cityInfo;
	YXTHotFilm *hotFilm;
	
	UIButton *cityBtn;
	YXTActionSheet *citySheet;
	UIPickerView *cityPicker;
	YXTPickerDelegate *cityPickerDelegate;
}

@property (nonatomic, retain) YXTLocation *location;
@property (nonatomic, retain) YXTCityInfo *cityInfo;
@property (nonatomic, retain) YXTHotFilm *hotFilm;

@property (nonatomic, retain) UIButton *cityBtn;
@property (nonatomic, retain) YXTActionSheet *citySheet;
@property (nonatomic, retain) UIPickerView *cityPicker;
@property (nonatomic, retain) YXTPickerDelegate *cityPickerDelegate;

-(void)refreshHotFilmView;

@end
