//
//  YXTFileTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTFilmTabController.h"
#import "YXTLocation.h"
#import "YXTHotFilm.h"
#import "YXTActionSheet.h"
#import "YXTPickerDelegate.h"

enum REQUEST_TYPE {
	city_request = 0
};

@implementation YXTFilmTabController

@synthesize location, cityInfo, hotFilm, filmList;

@synthesize cityBtn, citySheet, cityPicker, cityPickerDelegate;

@synthesize filmScrollView;
@synthesize filmNameLabel, directorLabel, mainPerformerLabel;
@synthesize filmClassLabel, areaLabel, ycTimeLabel;

- (void)dealloc {
	[location release];
	[cityInfo release];
	[hotFilm release];
	
	[filmList release];
	
	[cityBtn release];
	[citySheet release];
	[cityPicker release];
	[cityPickerDelegate release];
	
	
	[filmScrollView release];
	[filmNameLabel release];
	[directorLabel release];
	[mainPerformerLabel release];
	[filmClassLabel release];
	[areaLabel release];
	[ycTimeLabel release];
    [super dealloc];
}

-(id)init{
	if (self = [super init]) {
		
	}
	return self;
}

-(void)viewDidLoad{
	self.cityInfo = [[YXTCityInfo alloc] init];
	[cityInfo setProvinceId:@"310000"];
	[cityInfo setCityId:@"310000"];
	[cityInfo setCityName:@"上海市"];
	
	
	// set uibaritem
	self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cityBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *cityImg = [UIImage imageNamed:@"dropselect.png"];
	[cityBtn setFrame:CGRectMake(0, 0, cityImg.size.width+15.0, cityImg.size.height+8.0)];
	[cityBtn setBackgroundImage:cityImg forState:UIControlStateNormal];
	[cityBtn addTarget:self action:@selector(pressCitySwitchBtn) forControlEvents:UIControlEventTouchUpInside];
	[[cityBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2.0, -11.0, 0.0, 0.0)];
	[cityBtn setTitle:[cityInfo cityName] forState:UIControlStateNormal];
	
	UIBarButtonItem *cityBarItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];	
	self.navigationItem.rightBarButtonItem = cityBarItem;
	[cityBarItem release];
	
	
	
	//set filmscroll
	//首先假设一共有15张图片，为了保证一次滑动不拖到底。
	int filmnum = 46;
	
	CGFloat startX = 5;
	CGFloat width = 101;
	CGFloat height = 145;
	CGFloat span = 10;
	
	filmViewArray = [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
	
	for (int i=1; i<=filmnum; i++) {
		int index = 0;
		if (i % 6 == 0) {
			index = 6;
		}else {
			index = i % 6;
		}

		
		NSString *imgName = [NSString stringWithFormat:@"large_%d.png", index];
		UIImage *imageFilm = [UIImage imageNamed:imgName];
		UIImageView *imageView = [[[UIImageView alloc] initWithImage:imageFilm] autorelease];
		[imageView setBackgroundColor:[UIColor lightGrayColor]];
		[imageView setFrame:CGRectMake(startX+(i-1)*width+(i-1)*span, 0, 101, 145)];
		[filmViewArray addObject:imageView];
		[filmScrollView addSubview:imageView];
	}
	filmScrollView.delegate = self;
	filmScrollView.pagingEnabled = NO;
	filmScrollView.showsHorizontalScrollIndicator = NO;
	filmScrollView.contentSize = CGSizeMake(startX + filmnum*width + (filmnum-1)*span + startX, height);

	UIImageView *imgView = [filmViewArray objectAtIndex:((filmnum/2 + 1)-1-1)];
	CGPoint centerfilm = CGPointZero;
	centerfilm.x = imgView.frame.origin.x;
	NSLog(@"center:%f", centerfilm.x);
	[filmScrollView setContentOffset:centerfilm animated:NO];
	
	[super viewDidLoad];
}

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	NSLog(@"scrollview offset:%f", scrollView.contentOffset.x);
	
	if (scrollView.contentOffset.x < 101*7 || scrollView.contentOffset.x > 101*40) {
		[scrollView scrollRectToVisible:CGRectMake(101*22, 0, 101, 145) animated:NO];
	}
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSLog(@"end decelerating");
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
	[self refreshHotFilmView];
	[super viewWillAppear:animated];
}


-(void)refreshHotFilmView{
	self.hotFilm = [[YXTHotFilm alloc] init];
	[hotFilm setDelegateFilm:self];
	[hotFilm setCityInfo:cityInfo];
	
	[hotFilm startToFetchFilmList];
}


-(void)pressCitySwitchBtn{
	self.location = [[YXTLocation alloc] init];
	[location setDelegateFilm:self];
	[location startToFetchCityList];
}

-(void)popUpCityChangePicker:(NSMutableArray *)array{
	self.citySheet = [[YXTActionSheet alloc] initWithHeight:234.0f WithSheetTitle:@"" delegateClass:self 
											   confirm:@selector(selectCityConfirm:) cancel:@selector(selectCityCancel:)];
	
	self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 225)];
	
	cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	cityPicker.showsSelectionIndicator = YES;	// note this is default to NO
	
	self.cityPickerDelegate = [[YXTPickerDelegate alloc] init];
	cityPickerDelegate.pickerDataArray = array;
	cityPicker.dataSource = cityPickerDelegate;
	cityPicker.delegate = cityPickerDelegate;
	
	[citySheet.view addSubview:cityPicker];
	
	
	[citySheet showInView:[self.view superview]];
}

-(IBAction)selectCityConfirm:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
	NSInteger row = [cityPicker selectedRowInComponent:0];
	self.cityInfo = [[cityPickerDelegate pickerDataArray] objectAtIndex:row];
    NSString *cityName = [cityInfo infoDescription];
	[cityBtn setTitle:cityName forState:UIControlStateNormal];
	
	[self refreshHotFilmView];
}

-(IBAction)selectCityCancel:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
}



-(NSString *)getNavTitle{ return @"正在热映";}
-(NSString *)getTabTitle{ return @"影片"; }
-(NSString *)getTabImage{ return @"icon_yingpian.png";}
-(int) getTabTag{ return 1;}

@end
