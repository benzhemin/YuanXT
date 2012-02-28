//
//  YXTFilmDetailController.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-27.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownLoader.h"
#import "YXTBasicViewController.h"

@class YXTFilmInfo;

@interface YXTFilmDetailController : YXTBasicViewController <ImageDownLoadDelegate>{
	YXTFilmInfo *filmInfo;
	ImageDownLoader *imgLoader;
	
	UIImageView *filmImageView;
	
	UILabel *filmNameLabel;
	
	UILabel *directorLabel;
	UILabel *mainPerformerLabel;
	UILabel *durationLabel;
	UILabel *filmClassLabel;
	UILabel *areaLabel;
	UILabel *ycTimeLabel;
	
	UITextView *descriptionText;
}

@property (nonatomic, retain) YXTFilmInfo *filmInfo;
@property (nonatomic, retain) ImageDownLoader *imgLoader;

@property (nonatomic, retain) IBOutlet UIImageView *filmImageView;

@property (nonatomic, retain) IBOutlet UILabel *filmNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *directorLabel;
@property (nonatomic, retain) IBOutlet UILabel *mainPerformerLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *filmClassLabel;
@property (nonatomic, retain) IBOutlet UILabel *areaLabel;
@property (nonatomic, retain) IBOutlet UILabel *ycTimeLabel;

@property (nonatomic, retain) IBOutlet UITextView *descriptionText;

@end
