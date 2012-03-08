//
//  YXTFileTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTFilmTabController.h"
#import "YXTLocationService.h"
#import "YXTHotFilmService.h"
#import "YXTActionSheet.h"
#import "YXTPickerDelegate.h"
#import "ImageDownLoader.h"
#import "YXTSettings.h"
#import "YXTNavigationBarView.h"

#import "YXTCinemaTabController.h"

enum REQUEST_TYPE {
	city_request = 0
};

static const CGFloat startX = 0;
static const CGFloat width = 101;
static const CGFloat height = 145;
static const CGFloat span = 8;
static int factor = 5;

static CGFloat begin_decelerate_offsetx = 0; 

@implementation YXTFilmTabController

@synthesize curFilmInfo;

@synthesize location, hotFilm, filmList, imageQueue, filmImageList;

@synthesize citySheet, cityPicker, cityPickerDelegate;

@synthesize naviView, contentView, filmScrollView, filmImageViewList;

@synthesize filmNameLabel, directorLabel, mainPerformerLabel;
@synthesize filmClassLabel, areaLabel, ycTimeLabel;

- (void)dealloc {
	[location release];
	[hotFilm release];
    
    [curFilmInfo release];
	
	[filmList release];
	[imageQueue release];
	[filmImageList release];
	
	[citySheet release];
	[cityPicker release];
	[cityPickerDelegate release];
	
	[naviView release];
    [contentView release];
	
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

-(id)initWithTab{
	if (self=[super initWithTab]){
		//self.navigationController.navigationBarHidden = YES;
		
	}
	return self;
}

-(void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
    
	YXTNavigationBarView *cusNaviView = [[YXTNavigationBarView alloc] init];
	self.naviView = cusNaviView;
    [cusNaviView release];
    
    naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
	[naviView addCitySwitchIconToBar];
	[naviView addTitleLabelToBar:@"正在热映"];
	[self.view addSubview:naviView];
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];
	
	refreshFisrtTiem = YES;

	//initialize 3 pic, when fetch all pics relayout
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
	if (refreshFisrtTiem) {
		[self refreshHotFilmView];
		refreshFisrtTiem = NO;
	}
	[super viewWillAppear:animated];
}

-(void)refreshHotFilmView{
	YXTHotFilmService *cusHotFilm = [[YXTHotFilmService alloc] init];
	self.hotFilm = cusHotFilm;
    [cusHotFilm release];
    [hotFilm setDelegateFilm:self];
	[hotFilm setCityInfo:[YXTSettings instance].cityInfo];
	
	[hotFilm startToFetchFilmList];
}

-(void)fetchFilmListSucceed:(NSMutableArray *)filmListArray {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.filmList = filmListArray;

	[self performSelectorOnMainThread:@selector(updateFilmInfo:) withObject:[filmList objectAtIndex:0] waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(layoutFilmScroll) withObject:nil waitUntilDone:NO];
	
	if (imageQueue) {
		[imageQueue cancelAllOperations];
	}
    
	ASINetworkQueue *cusImageQueue = [[ASINetworkQueue alloc] init];
    self.imageQueue = cusImageQueue;
    [cusImageQueue release];
    
    
	NSMutableArray *cusFilmImageList = [[NSMutableArray alloc] initWithCapacity:20];
    self.filmImageList = cusFilmImageList;
    [cusFilmImageList release];
	
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
	
	[pool drain];
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

-(void)layoutFilmScroll{
	for (UIView *view in [self.filmScrollView subviews]) {
		[view removeFromSuperview];
	}
	
	//为了有循环滑动效果，设置scrollview的宽度为3倍内容
	
	int film_init_image = [self.filmList count] * factor;
    
	NSMutableArray *cusFilmImgViewList = [[NSMutableArray alloc] initWithCapacity:film_init_image];
    self.filmImageViewList = cusFilmImgViewList;
    [cusFilmImgViewList release];
    
	filmScrollView.contentSize = CGSizeMake(startX + film_init_image*width + (film_init_image-1)*span + startX, height);	
	
	NSString *loadingImgName = [NSString stringWithFormat:@"bg_movie.png"];
	UIImage *loadingImg = [UIImage imageNamed:loadingImgName];
	for (int i=0; i<film_init_image; i++) {
		UIButton *filmImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		filmImgBtn.tag = i;
		[filmImgBtn addTarget:self action:@selector(pressFilmImgBtn:) forControlEvents:UIControlEventTouchUpInside];
		[filmImgBtn setFrame:CGRectMake(startX+i*width+i*span, 0, loadingImg.size.width, loadingImg.size.height)];
		
		YXTUIImageView *loadingImageView = [[YXTUIImageView alloc] initWithImage:loadingImg];
		[loadingImageView addAnimateLoadingImage];
		[loadingImageView setFrame:CGRectMake(0, 0, loadingImg.size.width, loadingImg.size.height)];
		[loadingImageView startAnimateLoadingImage];
		
		[filmImgBtn addSubview:loadingImageView];
		
		
		
		[filmScrollView addSubview:filmImgBtn];
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

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	int film_init_image = [self.filmList count] * (factor-1);
	if ([self.filmList count] == 2) {
		film_init_image = 3;
	}
	
	CGFloat contentWidth = startX + film_init_image*width + (film_init_image-1)*span + startX;
	
	if (scrollView.contentOffset.x <= 30 || scrollView.contentOffset.x>=contentWidth-30) {
		
		CGFloat total_width = startX + [filmList count]*width + [filmList count]*span;
		
		total_width = total_width * ((int)factor/2);
		
		if (scrollView.contentOffset.x>=contentWidth-30) {
			if ([self.filmList count] > 3) {
				CGFloat offset = ([filmList count]-3) * (width+span);
				total_width = total_width + offset;
			}else if ([self.filmList count] == 2) {
				total_width = total_width - (width+span);
			}
		}
		
		//将第一条移到中间,右移一个图片的位置
		//CGFloat offset = (width + span);
		//total_width = total_width - offset;
		
		begin_decelerate_offsetx = total_width;
		[filmScrollView scrollRectToVisible:CGRectMake(total_width, 0, filmScrollView.bounds.size.width, filmScrollView.bounds.size.height)
								   animated:NO];
		
		int update_index = ((int)total_width/(int)(width+span)+1) % [filmList count];
		[self updateFilmInfo:[filmList objectAtIndex:update_index]];
	}else {
		CGFloat total_width = startX + [filmList count]*width + [filmList count]*span;
		int offset_list_unit = scrollView.contentOffset.x / total_width;
		int offset_list_span = (int)scrollView.contentOffset.x % (int)total_width;
		
		int offset_film_unit = offset_list_span / (width+span);
		
		if (scrollView.contentOffset.x < begin_decelerate_offsetx) {
			
		}else {
			offset_film_unit++;
		}
		
		CGFloat offset = (offset_list_unit*[filmList count] + offset_film_unit)*(width+span);
		begin_decelerate_offsetx = offset;
		
		[filmScrollView scrollRectToVisible:CGRectMake(offset, 0, filmScrollView.bounds.size.width, filmScrollView.bounds.size.height)
								   animated:YES];

		YXTFilmInfo *filmInfo = [filmList objectAtIndex:(offset_film_unit+1)%[filmList count]];
		[self updateFilmInfo:filmInfo];
	}
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


-(IBAction)popToPreviousViewController:(id)sender{
	NSLog(@"do nothing");
}

-(IBAction)pressCitySwitchBtn:(id)sender{
    YXTLocationService *cusLocation = [[YXTLocationService alloc] init];
	self.location = cusLocation;
    [cusLocation release];
    
	[location setDelegateFilm:self];
	[location startToFetchCityList];
}

-(void)popUpCityChangePicker:(NSMutableArray *)array{
	YXTActionSheet *cusCitySheet = [[YXTActionSheet alloc] initWithHeight:234.0f WithSheetTitle:@"" delegateClass:self 
											   confirm:@selector(selectCityConfirm:) cancel:@selector(selectCityCancel:)];
	self.citySheet = cusCitySheet;
    [cusCitySheet release];
    
    CGRect pickFrame = CGRectMake(0, 0, citySheet.bounds.size.width, 225);
    UIPickerView *cusPicker = [[UIPickerView alloc] initWithFrame:pickFrame];
	self.cityPicker = cusPicker;
    [cusPicker release];
	
	cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	cityPicker.showsSelectionIndicator = YES;	// note this is default to NO
	
    YXTPickerDelegate *cusDelegate = [[YXTPickerDelegate alloc] init];
	self.cityPickerDelegate = cusDelegate;
    [cusDelegate release];
    
	cityPickerDelegate.pickerDataArray = array;
	cityPicker.dataSource = cityPickerDelegate;
	cityPicker.delegate = cityPickerDelegate;
	
	[citySheet.view addSubview:cityPicker];
	
	
	[citySheet showInView:[self.view superview]];
}

-(IBAction)selectCityConfirm:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
	NSInteger row = [cityPicker selectedRowInComponent:0];
	[YXTSettings instance].cityInfo = [[cityPickerDelegate pickerDataArray] objectAtIndex:row];
    //NSString *cityName = [[YXTSettings instance].cityInfo infoDescription];
	
	[naviView.cityBtn setTitle:[[YXTSettings instance].cityInfo cityName] forState:UIControlStateNormal];
	
	[self refreshHotFilmView];
}

-(IBAction)selectCityCancel:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)pressFilmImgBtn:(id)sender{
	int index = ((UIView *)sender).tag;
	YXTFilmInfo *filmInfo = [self.filmList objectAtIndex:(index%[filmList count])];
	
    YXTCinemaTabController *cinemaController = [[YXTCinemaTabController alloc] init];

	cinemaController.filmInfo = filmInfo;
	[self.navigationController pushViewController:cinemaController animated:YES];
    [cinemaController release];
}

-(IBAction)pressBuyFilmTicket:(id)sender{
    
    YXTCinemaTabController *cinemaController = [[YXTCinemaTabController alloc] init];

    cinemaController.filmInfo = self.curFilmInfo;
    [self.navigationController pushViewController:cinemaController animated:YES];
    [cinemaController release];
}

-(void)updateFilmInfo:(YXTFilmInfo *)filmInfo{
    self.curFilmInfo = filmInfo;
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
