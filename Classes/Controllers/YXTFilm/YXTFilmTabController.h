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
#import "ASINetworkQueue.h"
#import "YXTUIImageView.h"
#import "ImageDownLoader.h"

@class YXTLocation;
@class YXTCityInfo;
@class YXTHotFilm;
@class YXTFilmInfo;

@class YXTActionSheet;
@class YXTPickerDelegate;


@interface YXTFilmTabController : YXTBasicTabController<UIScrollViewDelegate, ImageDownLoadDelegate>{
	YXTLocation *location;
	YXTCityInfo *cityInfo;
	YXTHotFilm *hotFilm;
	
	NSMutableArray *filmList;
	ASINetworkQueue *imageQueue;
	
	//retain download film image
	NSMutableArray *filmImageList;
	
	
	UIButton *cityBtn;
	YXTActionSheet *citySheet;
	UIPickerView *cityPicker;
	YXTPickerDelegate *cityPickerDelegate;
	
	UIScrollView *filmScrollView;
	NSMutableArray *filmImageViewList;
	
	UILabel *filmNameLabel;
	UILabel *directorLabel;
	UILabel *mainPerformerLabel;
	UILabel *filmClassLabel;
	UILabel *areaLabel;
	UILabel *ycTimeLabel;
}

@property (nonatomic, retain) YXTLocation *location;
@property (nonatomic, retain) YXTCityInfo *cityInfo;
@property (nonatomic, retain) YXTHotFilm *hotFilm;

@property (nonatomic, retain) NSMutableArray *filmList;
@property (nonatomic, retain) ASINetworkQueue *imageQueue;
@property (nonatomic, retain) NSMutableArray *filmImageList;

@property (nonatomic, retain) UIButton *cityBtn;
@property (nonatomic, retain) YXTActionSheet *citySheet;
@property (nonatomic, retain) UIPickerView *cityPicker;
@property (nonatomic, retain) YXTPickerDelegate *cityPickerDelegate;

@property (nonatomic, retain) IBOutlet UIScrollView *filmScrollView;
@property (nonatomic, retain) NSMutableArray *filmImageViewList;

@property (nonatomic, retain) IBOutlet UILabel *filmNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *directorLabel;
@property (nonatomic, retain) IBOutlet UILabel *mainPerformerLabel;
@property (nonatomic, retain) IBOutlet UILabel *filmClassLabel;
@property (nonatomic, retain) IBOutlet UILabel *areaLabel;
@property (nonatomic, retain) IBOutlet UILabel *ycTimeLabel;

-(void)refreshHotFilmView;

@end

@interface YXTFilmTabController(Private) 

-(void)setUpUINavigationBarItem;
-(void)updateFilmInfo:(YXTFilmInfo *)filmInfo;

@end
