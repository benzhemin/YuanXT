//
//  YXTFileTabController.h
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTBasicTabController.h"
#import "OFXPRequest.h"
#import "ASINetworkQueue.h"
#import "YXTUIImageView.h"
#import "ImageDownLoader.h"

@class YXTLocationService;
@class YXTCityInfo;
@class YXTHotFilmService;
@class YXTFilmInfo;

@class YXTNavigationBarView;

@class YXTActionSheet;
@class YXTPickerDelegate;

@class YXTCinemaTabController;

@interface YXTFilmTabController : YXTBasicTabController<UIScrollViewDelegate, ImageDownLoadDelegate>{
	BOOL refreshFisrtTiem;
    
    YXTFilmInfo *curFilmInfo;
	
	YXTLocationService *location;
	YXTHotFilmService *hotFilm;
	
	NSMutableArray *filmList;
	ASINetworkQueue *imageQueue;
	
	//retain download film image
	NSMutableArray *filmImageList;
	
	YXTActionSheet *citySheet;
	UIPickerView *cityPicker;
	YXTPickerDelegate *cityPickerDelegate;
	
	YXTNavigationBarView *naviView;
	
    UIView *contentView;
    
	UIScrollView *filmScrollView;
	NSMutableArray *filmImageViewList;
	
	UILabel *filmNameLabel;
	UILabel *directorLabel;
	UILabel *mainPerformerLabel;
	UILabel *filmClassLabel;
	UILabel *areaLabel;
	UILabel *ycTimeLabel;
}

@property (nonatomic, retain) YXTFilmInfo *curFilmInfo;

@property (nonatomic, retain) YXTLocationService *location;
@property (nonatomic, retain) YXTHotFilmService *hotFilm;

@property (nonatomic, retain) NSMutableArray *filmList;
@property (nonatomic, retain) ASINetworkQueue *imageQueue;
@property (nonatomic, retain) NSMutableArray *filmImageList;

@property (nonatomic, retain) YXTActionSheet *citySheet;
@property (nonatomic, retain) UIPickerView *cityPicker;
@property (nonatomic, retain) YXTPickerDelegate *cityPickerDelegate;

@property (nonatomic, retain) YXTNavigationBarView *naviView;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (nonatomic, retain) IBOutlet UIScrollView *filmScrollView;
@property (nonatomic, retain) NSMutableArray *filmImageViewList;

@property (nonatomic, retain) IBOutlet UILabel *filmNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *directorLabel;
@property (nonatomic, retain) IBOutlet UILabel *mainPerformerLabel;
@property (nonatomic, retain) IBOutlet UILabel *filmClassLabel;
@property (nonatomic, retain) IBOutlet UILabel *areaLabel;
@property (nonatomic, retain) IBOutlet UILabel *ycTimeLabel;

-(void)refreshHotFilmView;
-(IBAction)pressFilmImgBtn:(id)sender;
-(IBAction)pressBuyFilmTicket:(id)sender;

@end

@interface YXTFilmTabController(Private) 

-(void)setUpUINavigationBarItem;
-(void)updateFilmInfo:(YXTFilmInfo *)filmInfo;

@end
