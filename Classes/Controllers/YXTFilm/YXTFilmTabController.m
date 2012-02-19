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
#import "ImageDownLoader.h"

enum REQUEST_TYPE {
	city_request = 0
};

static const CGFloat startX = 0;
static const CGFloat width = 101;
static const CGFloat height = 145;
static const CGFloat span = 8;
static 	int factor = 3;

static CGFloat begin_decelerate_offsetx = 0; 

@implementation YXTFilmTabController

@synthesize location, cityInfo, hotFilm, filmList, imageQueue, filmImageList;

@synthesize cityBtn, citySheet, cityPicker, cityPickerDelegate;

@synthesize filmScrollView, filmImageViewList;

@synthesize filmNameLabel, directorLabel, mainPerformerLabel;
@synthesize filmClassLabel, areaLabel, ycTimeLabel;

- (void)dealloc {
	[location release];
	[cityInfo release];
	[hotFilm release];
	
	[filmList release];
	[imageQueue release];
	[filmImageList release];
	
	[cityBtn release];
	[citySheet release];
	[cityPicker release];
	[cityPickerDelegate release];
	
	
	[filmScrollView release];
	[filmImageViewList release];
	
	
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
	
	[self setUpUINavigationBarItem];
	
	
	//viewDidLoad时，初始化3张图片，等获取到所有图片再重新layout
	int film_init_image = 3;
	
	filmScrollView.delegate = self;
	filmScrollView.pagingEnabled = NO;
	filmScrollView.showsHorizontalScrollIndicator = NO;
	filmScrollView.contentSize = CGSizeMake(startX + film_init_image*width + film_init_image*span + startX, height);
	
	NSString *loadingImgName = [NSString stringWithFormat:@"bg_movie.png"];
	UIImage *loadingImg = [UIImage imageNamed:loadingImgName];
	for (int i=0; i<film_init_image; i++) {
		YXTUIImageView *loadingImageView = [[YXTUIImageView alloc] initWithImage:loadingImg];
		[loadingImageView addAnimateLoadingImage];
		[loadingImageView setFrame:CGRectMake(startX+i*width+i*span, 0, loadingImg.size.width, loadingImg.size.height)];
		[loadingImageView startAnimateLoadingImage];
		[filmScrollView addSubview:loadingImageView];
		[loadingImageView release];
	}
	
	[super viewDidLoad];
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

-(void)fetchFilmListSucceed:(NSMutableArray *)filmListArray {
	self.filmList = filmListArray;

	[self performSelectorOnMainThread:@selector(updateFilmInfo:) withObject:[filmList objectAtIndex:0] waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(layoutFilmScroll) withObject:nil waitUntilDone:NO];
	
	if (imageQueue) {
		[imageQueue cancelAllOperations];
	}
	self.imageQueue = [[ASINetworkQueue alloc] init];
	self.filmImageList = [[NSMutableArray alloc] initWithCapacity:20];
	
	int i=0;
	for (YXTFilmInfo *filmInfo in filmList) {
		if (filmInfo.webPoster2 != nil) {
			ImageDownLoader *imgLoader = [ImageDownLoader requestWithURL:[NSURL URLWithString:filmInfo.webPoster2]];
			imgLoader.reqDelegate = self;
			imgLoader.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i], @"tag", nil];;
			[self.imageQueue addOperation:imgLoader];
			[self.filmImageList addObject:imgLoader];
			i++;
		}
	}
	[imageQueue go];
}

-(void)layoutFilmScroll{
	for (UIView *view in [self.filmScrollView subviews]) {
		[view removeFromSuperview];
	}
	
	//为了有循环滑动效果，设置scrollview的宽度为3倍内容
	
	int film_init_image = [self.filmList count] * factor;
	self.filmImageViewList = [[NSMutableArray alloc] initWithCapacity:film_init_image];
	filmScrollView.contentSize = CGSizeMake(startX + film_init_image*width + (film_init_image-1)*span + startX, height);	
	
	NSString *loadingImgName = [NSString stringWithFormat:@"bg_movie.png"];
	UIImage *loadingImg = [UIImage imageNamed:loadingImgName];
	for (int i=0; i<film_init_image; i++) {
		YXTUIImageView *loadingImageView = [[YXTUIImageView alloc] initWithImage:loadingImg];
		[loadingImageView addAnimateLoadingImage];
		[loadingImageView setFrame:CGRectMake(startX+i*width+i*span, 0, loadingImg.size.width, loadingImg.size.height)];
		[loadingImageView startAnimateLoadingImage];
		[filmScrollView addSubview:loadingImageView];
		[filmImageViewList addObject:loadingImageView];
		[loadingImageView release];
	}
	
	CGFloat total_width = startX + [filmList count]*width + [filmList count]*span;
	total_width = total_width * ((int)factor/2);
	//将第一条移到中间,右移一个图片的位置
	CGFloat offset = (width + span);
	total_width = total_width - offset;
	begin_decelerate_offsetx = total_width;
	[filmScrollView scrollRectToVisible:CGRectMake(total_width, 0, filmScrollView.bounds.size.width, loadingImg.size.height)
							   animated:NO];
}

-(void)imageRequestFinished:(NSDictionary *)userInfo{
	int index = [((NSNumber *)[userInfo objectForKey:@"tag"]) intValue];
	ImageDownLoader *imgLoader = [self.filmImageList objectAtIndex:index];
	UIImage *image = [[UIImage alloc] initWithData:[imgLoader imgData]];
	
	for (int i=0; i<[filmImageViewList count]; i++) {
		if (i%[filmList count] == index) {
			YXTUIImageView *imageView = [filmImageViewList objectAtIndex:i];
			[imageView setImage:image];
			[imageView stopAnimateLoadingImage];
		}
	}
	[image release];
}

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	/*
	if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width-(startX + [filmList count]*width + ([filmList count]+1)*span)) {
		CGFloat total_width = startX + [filmList count]*width + [filmList count]*span;
		total_width = total_width * ((int)factor/2);
		//将第一条移到中间,右移一个图片的位置
		CGFloat offset = (width + span);
		total_width = total_width - offset;
		
		[filmScrollView scrollRectToVisible:CGRectMake(total_width, 0, filmScrollView.bounds.size.width, filmScrollView.bounds.size.height)
								   animated:NO];
	}
	*/
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
}

// called on finger up if user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (decelerate == YES) {
		return ;
	}
	
	CGFloat total_width = startX + [filmList count]*width + [filmList count]*span;
	
	int offset_list_unit = begin_decelerate_offsetx / total_width;
	int offset_list_span = (int)begin_decelerate_offsetx % (int)total_width;
	
	int offset_film_unit = offset_list_span / (width+span);
	
	//向右滑动
	if (scrollView.contentOffset.x > begin_decelerate_offsetx) {
		offset_film_unit++;
	}else {
		offset_film_unit--;
	}

	CGFloat offset = (offset_list_unit*[filmList count] + offset_film_unit)*(width+span);
	
	[filmScrollView scrollRectToVisible:CGRectMake(offset, 0, filmScrollView.bounds.size.width, filmScrollView.bounds.size.height)
							   animated:YES];
	begin_decelerate_offsetx = offset;
	
	YXTFilmInfo *filmInfo = [filmList objectAtIndex:(offset_film_unit+1)%[filmList count]];
	[self updateFilmInfo:filmInfo];
}

-(void)scrollViewToFormatFilm:(UIScrollView *)scrollView{
	
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

-(void)setUpUINavigationBarItem{
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
}

-(void)updateFilmInfo:(YXTFilmInfo *)filmInfo{
	self.filmNameLabel.text = filmInfo.filmName;
	self.directorLabel.text = filmInfo.director;
	self.mainPerformerLabel.text = filmInfo.mainPerformer;
	self.filmClassLabel.text = filmInfo.filmClass;
	self.areaLabel.text = filmInfo.area;
	self.ycTimeLabel.text = filmInfo.ycTime;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSString *)getNavTitle{ return @"正在热映";}
-(NSString *)getTabTitle{ return @"影片"; }
-(NSString *)getTabImage{ return @"icon_yingpian.png";}
-(int) getTabTag{ return 1;}

@end
