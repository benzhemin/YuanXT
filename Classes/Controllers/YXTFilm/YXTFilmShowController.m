//
//  YXTFilmShowOrderController.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-28.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTFilmShowController.h"
#import "YXTCinemaService.h"
#import "YXTHotFilmService.h"
#import "YXTCinemaDetailController.h"
#import "YXTNavigationBarView.h"
#import "YXTShowService.h"
#import "YXTHotFilmService.h"
#import "ASINetworkQueue.h"
#import "OFReachability.h"
#import "YXTOrderShowController.h"

enum Film_Table_Tag {
	film_imgview_tag = 1
};

@implementation YXTFilmShowController

@synthesize cinemaInfo;
@synthesize hotFilmService, showService;
@synthesize imageQueue;
@synthesize filmList, showList, filmImageList;
@synthesize dateSegImgView, selectDateStr, todayStr, tomorrowStr;
@synthesize todayLabel, tomorrowLabel;
@synthesize filmBgImg;
@synthesize contentView, filmTableView;
@synthesize cinemaImgView, addressLabel, onlineOrderLabel;

-(void)dealloc{
	[cinemaInfo release];
	
	[hotFilmService release];
	[showService release];
	
	[filmList release];
	[showList release];
	[filmImageList release];
	
	[dateSegImgView release];
	[selectDateStr release];
	[todayStr release];
	[tomorrowStr release];
	
	[todayLabel release];
	[tomorrowLabel release];
	
	[filmBgImg release];
	[contentView release];
	[filmTableView release];
	
	[cinemaImgView release];
	[addressLabel release];
	[onlineOrderLabel release];
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		self.hidesBottomBarWhenPushed = YES;
		
		dateTag = today_tag;
		
		self.imageQueue = [[ASINetworkQueue alloc] init];
		[imageQueue go];
	}
	return self;
}

-(void)setUpCurrentDate{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSDate *todayDate = [NSDate date];
	NSDate *tomorrowDate = [todayDate dateByAddingTimeInterval:60*60*24L];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	self.todayStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:todayDate]];
	self.tomorrowStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:tomorrowDate]];
}

-(void)setUpNaviBarView{
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
	[naviView addTitleLabelToBar:self.cinemaInfo.cinemaName];
	[naviView addFunctionIconToBar:[UIImage imageNamed:@"btn_yingyuanxiangqing.png"]];
	[self.view addSubview:naviView];
	[naviView release];	
}

-(void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	[self setUpCurrentDate];
	[self setUpNaviBarView];
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];
	
	selectDateStr = todayStr;
	
	UIImage *cinemaPicImg = [UIImage imageNamed:@"cinema_pic.png"];
	if (cinemaInfo!=nil && cinemaInfo.cinemaImage!=nil) {
		[cinemaImgView setImage:cinemaInfo.cinemaImage];
	}else {
		[cinemaImgView setImage:cinemaPicImg];
	}
	
	addressLabel.text = cinemaInfo.address;
	if ([cinemaInfo.onlineOrder isEqualToString:@"N"]) {
		onlineOrderLabel.text = @"不支持在线选座";
	}
	
	self.filmBgImg = [UIImage imageNamed:@"bg_movie.png"];
	
	self.filmTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 90, 310, 300) style:UITableViewStyleGrouped];
	[self.filmTableView setDelegate:self];
	[self.filmTableView setDataSource:self];
	[self.filmTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.contentView addSubview:filmTableView];
	
	CGRect dateSegFrame = CGRectMake(57, 60, 206, 31);
	self.dateSegImgView = [[UIImageView alloc] initWithFrame:dateSegFrame];
	[dateSegImgView setUserInteractionEnabled:YES];
	[dateSegImgView setImage:[UIImage imageNamed:@"tab1.png"]];
	[self.contentView addSubview:dateSegImgView];
	
	CGRect todayFrame = CGRectMake(12, 2, 80, 25);
	self.todayLabel = [[UILabel alloc] initWithFrame:todayFrame];
	[todayLabel setBackgroundColor:[UIColor clearColor]];
	todayLabel.font = [UIFont boldSystemFontOfSize:14];
	todayLabel.textColor = [UIColor whiteColor];
	todayLabel.text = todayStr;
	[dateSegImgView addSubview:todayLabel];
	
	CGRect tomorrowFrame = CGRectMake(115, 2, 80, 25);
	self.tomorrowLabel = [[UILabel alloc] initWithFrame:tomorrowFrame];
	[tomorrowLabel setBackgroundColor:[UIColor clearColor]];
	tomorrowLabel.font = [UIFont boldSystemFontOfSize:14];
	tomorrowLabel.text = tomorrowStr;
	[dateSegImgView addSubview:tomorrowLabel];
	
	[self requestShowService];
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == dateSegImgView) {
		CGPoint touchPoint = [touch locationInView:dateSegImgView];
		if (touchPoint.x < [dateSegImgView bounds].size.width/2) {
			if (dateTag == tomorrow_tag) {
				[self.imageQueue cancelAllOperations];
				dateTag = today_tag;
				self.selectDateStr = todayStr;
				 
				todayLabel.textColor = [UIColor whiteColor];
				tomorrowLabel.textColor = [UIColor blackColor];
				[dateSegImgView setImage:[UIImage imageNamed:@"tab1.png"]];
				
				[self requestShowService];
			}
		}else {
			if (dateTag == today_tag) {
				[self.imageQueue cancelAllOperations];
				dateTag = tomorrow_tag;
				self.selectDateStr = tomorrowStr;
				
				todayLabel.textColor = [UIColor blackColor];
				tomorrowLabel.textColor = [UIColor whiteColor];
				[dateSegImgView setImage:[UIImage imageNamed:@"tab2.png"]];
				
				[self requestShowService];
			}
		}
	}
}


-(void)requestShowService{
	self.showService = [[YXTShowService alloc] init];
	showService.dateStr = selectDateStr;
	showService.changeFlag = YES;
	showService.delegateFilm = self;
	showService.cinemaInfo = self.cinemaInfo;
	
	[showService startToFetchShowList];
}

-(void)showListFetchSucceed:(NSMutableArray *)showListParam{
	self.showList = showListParam;
	
	NSMutableString *filmIdSet = [NSMutableString stringWithCapacity:50];
	int i=0;
	for (YXTShowInfo *showInfo in self.showList) {
		if (i == 0) {
			[filmIdSet appendString:showInfo.filmId];
			i++;
		}else {
			[filmIdSet appendFormat:@"|%@", showInfo.filmId];
		}
	}
	
	self.hotFilmService = [[YXTHotFilmService alloc] init];
	hotFilmService.changeFlag = YES;
	hotFilmService.filmIdSet = filmIdSet;
	[hotFilmService setDelegateFilm:self];
	[hotFilmService startToFetchFilmList];
}

-(void)fetchFilmListSucceed:(NSMutableArray *)filmListParam{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.filmList = filmListParam;
	
	[self performSelectorOnMainThread:@selector(refreshFilmTableView) withObject:nil waitUntilDone:NO];
	
	self.filmImageList = [[NSMutableArray alloc] initWithCapacity:20];
	int filmIndex = 0;
	for (YXTFilmInfo *filmInfo in self.filmList) {
		
		ImageDownLoader *imgLoader = [ImageDownLoader requestWithURL:[NSURL URLWithString:filmInfo.webPoster]];
		imgLoader.reqDelegate = self;
		
		imgLoader.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:filmIndex], @"filmIndex", nil];;
		
		if ([OFReachability isConnectedToInternet]) {
			[self.imageQueue addOperation:imgLoader];
		}
		[filmImageList addObject:imgLoader];
		
		filmIndex++;
	}
	
	[pool drain];
}

-(void)requestHasNoCount{
	self.filmList = [[NSMutableArray alloc] initWithCapacity:0];
	[self performSelectorOnMainThread:@selector(refreshFilmTableView) withObject:nil waitUntilDone:NO];
}

-(void)imageRequestFinished:(NSDictionary *)userInfo{
	int filmIndex = [((NSNumber *)[userInfo objectForKey:@"filmIndex"]) intValue];
	ImageDownLoader *imgLoader = [self.filmImageList objectAtIndex:filmIndex];
	
	UITableViewCell *cell = [self.filmTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:filmIndex inSection:0]];
	for (UIView *view in [cell.contentView subviews]) {
		if (view.tag == film_imgview_tag) {
			UIImageView *imgView = (UIImageView *)view;
			[imgView setImage:[UIImage imageWithData:[imgLoader imgData]]];
		}
	}
}

-(void)refreshFilmTableView{
	[self.filmTableView reloadData];
    
    [self performSelector:@selector(scrollTableToTop) withObject:nil afterDelay:0.2];
}

-(void)scrollTableToTop{
    if ([self.filmList count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [filmTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


#pragma mark UITableViewDataSource delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.filmList count];
}

#pragma mark UITableViewDelegate delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellFilmShowIdentifier = @"CELLFILMSHOW";
	
	int filmIndex = indexPath.row;
	YXTFilmInfo *filmInfo = [self.filmList objectAtIndex:filmIndex];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellFilmShowIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFilmShowIdentifier] autorelease];
	}
	
	for (UIView *unitview in [cell.contentView subviews]) {
		[unitview removeFromSuperview];
	}
	
	ImageDownLoader *imgLoader = nil;
	if (indexPath.row < [self.filmImageList count]) {
		imgLoader = [self.filmImageList objectAtIndex:indexPath.row];
	}
	
	CGRect filmImgFrame = CGRectMake(10, 16, 60, 80);
	UIImageView *filmImgView = [[UIImageView alloc] initWithFrame:filmImgFrame];
	filmImgView.tag = film_imgview_tag;
	if (imgLoader == nil || imgLoader.imgData == nil) {
		[filmImgView setImage:filmBgImg];
	}else {
		[filmImgView setImage:[UIImage imageWithData:[imgLoader imgData]]];
	}
	[cell.contentView addSubview:filmImgView];
	[filmImgView release];
	
	CGRect filmNameFrame = CGRectMake(80, 5, 180, 20);
	UILabel *filmNameLabel = [[UILabel alloc] initWithFrame:filmNameFrame];
    [filmNameLabel setBackgroundColor:[UIColor clearColor]];
	filmNameLabel.font = [UIFont boldSystemFontOfSize:14];
	filmNameLabel.textColor = [UIColor colorWithRed:0.06 green:0.55 blue:0.78 alpha:1.0];
	filmNameLabel.text = filmInfo.filmName;
	[cell.contentView addSubview:filmNameLabel];
	[filmNameLabel release];
	
	CGRect directorStrFrame = CGRectMake(80, 25, 40, 20);
	UILabel *directorStrLabel = [[UILabel alloc] initWithFrame:directorStrFrame];
    [directorStrLabel setBackgroundColor:[UIColor clearColor]];
	directorStrLabel.font = [UIFont boldSystemFontOfSize:13];
	directorStrLabel.text = @"导演：";
	[cell.contentView addSubview:directorStrLabel];
	[directorStrLabel release];
	
	CGRect filmDirectorFrame = CGRectMake(120, 25, 160, 20);
	UILabel *dirctorLabel = [[UILabel alloc] initWithFrame:filmDirectorFrame];
    [dirctorLabel setBackgroundColor:[UIColor clearColor]];
	dirctorLabel.font = [UIFont boldSystemFontOfSize:13];
	dirctorLabel.textColor = [UIColor colorWithRed:0.06 green:0.55 blue:0.78 alpha:1.0];
	dirctorLabel.text = filmInfo.director;
	[cell.contentView addSubview:dirctorLabel];
	[dirctorLabel release];
	
	CGRect perfomerStrFrame = CGRectMake(80, 45, 40, 20);
	UILabel *perfomerStrLabel = [[UILabel alloc] initWithFrame:perfomerStrFrame];
    [perfomerStrLabel setBackgroundColor:[UIColor clearColor]];
	perfomerStrLabel.font = [UIFont boldSystemFontOfSize:13];
	perfomerStrLabel.text = @"主演：";
	[cell.contentView addSubview:perfomerStrLabel];
	[perfomerStrLabel release];
	
	CGRect perfomerFrame = CGRectMake(120, 45, 160, 20);
	UILabel *perfomerLabel = [[UILabel alloc] initWithFrame:perfomerFrame];
    [perfomerLabel setBackgroundColor:[UIColor clearColor]];
	perfomerLabel.font = [UIFont boldSystemFontOfSize:13];
	perfomerLabel.textColor = [UIColor colorWithRed:0.06 green:0.55 blue:0.78 alpha:1.0];
	perfomerLabel.text = filmInfo.mainPerformer;
	[cell.contentView addSubview:perfomerLabel];
	[perfomerLabel release];
	
	CGRect classStrFrame = CGRectMake(80, 65, 40, 20);
	UILabel *classStrLabel = [[UILabel alloc] initWithFrame:classStrFrame];
    [classStrLabel setBackgroundColor:[UIColor clearColor]];
	classStrLabel.font = [UIFont boldSystemFontOfSize:13];
	classStrLabel.text = @"类型：";
	[cell.contentView addSubview:classStrLabel];
	[classStrLabel release];
	
	CGRect classFrame = CGRectMake(120, 65, 160, 20);
	UILabel *classLabel = [[UILabel alloc] initWithFrame:classFrame];
    [classLabel setBackgroundColor:[UIColor clearColor]];
	classLabel.font = [UIFont boldSystemFontOfSize:13];
	classLabel.textColor = [UIColor colorWithRed:0.06 green:0.55 blue:0.78 alpha:1.0];
	classLabel.text = filmInfo.filmClass;
	[cell.contentView addSubview:classLabel];
	[classLabel release];
	
	NSString *showCount = filmInfo.showCount;
	
	NSArray *splitArray = [showCount componentsSeparatedByString:@"/"];
	NSString *filmCountStr = [splitArray objectAtIndex:0];
	NSString *showCountStr = [splitArray objectAtIndex:1];
	
	CGRect filmCountFrame = CGRectMake(90, 85, 30, 20);
	UILabel *filmCountLabel = [[UILabel alloc] initWithFrame:filmCountFrame];
    [filmCountLabel setBackgroundColor:[UIColor clearColor]];
	filmCountLabel.font = [UIFont boldSystemFontOfSize:13];
	filmCountLabel.textColor = [UIColor colorWithRed:1.0 green:0.49 blue:0.00 alpha:1.0];
	filmCountLabel.text = filmCountStr;
	[cell.contentView addSubview:filmCountLabel];
	[filmCountLabel release];
	
	CGRect filmPlainFrame = CGRectMake(111, 85, 120, 20);
	UILabel *filmPlainLabel = [[UILabel alloc] initWithFrame:filmPlainFrame];
    [filmPlainLabel setBackgroundColor:[UIColor clearColor]];
	filmPlainLabel.font = [UIFont boldSystemFontOfSize:13];
	filmPlainLabel.text = @"家影院上映";
	[cell.contentView addSubview:filmPlainLabel];
	[filmPlainLabel release];
	
	CGRect showCountFrame = CGRectMake(177, 85, 30, 20);
	UILabel *showCountLabel = [[UILabel alloc] initWithFrame:showCountFrame];
    [showCountLabel setBackgroundColor:[UIColor clearColor]];
	showCountLabel.font = [UIFont boldSystemFontOfSize:13];
	showCountLabel.textColor = [UIColor colorWithRed:1.0 green:0.49 blue:0.00 alpha:1.0];
	showCountLabel.text = showCountStr;
	[cell.contentView addSubview:showCountLabel];
	[showCountLabel release];
	
	CGRect filmPlainFrame2 = CGRectMake(204, 85, 30, 20);
	UILabel *filmPlainLabel2 = [[UILabel alloc] initWithFrame:filmPlainFrame2];
    [filmPlainLabel2 setBackgroundColor:[UIColor clearColor]];
	filmPlainLabel2.font = [UIFont boldSystemFontOfSize:13];
	filmPlainLabel2.text = @"场";
	[cell.contentView addSubview:filmPlainLabel2];
	[filmPlainLabel2 release];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    int index = indexPath.row;
    
    YXTFilmInfo *filmInfo = [self.filmList objectAtIndex:index];
    
	YXTOrderShowController *orderShowController = [[YXTOrderShowController alloc] init];
    orderShowController.cinemaInfo = self.cinemaInfo;
    orderShowController.filmInfo = filmInfo;
    
    [self.navigationController pushViewController:orderShowController animated:YES];
    [orderShowController release];
}

#define FILM_TABLE_HEIGHT 112.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return FILM_TABLE_HEIGHT;
}

-(IBAction)popToPreviousViewController:(id)sender{
	[self.imageQueue cancelAllOperations];
	[self.navigationController popViewControllerAnimated:YES];	
}

-(IBAction)funcToViewController:(id)sender{
	[self.imageQueue cancelAllOperations];
	YXTCinemaDetailController *cinemaDetailController = [[YXTCinemaDetailController alloc] init];
	cinemaDetailController.cinemaInfo = cinemaInfo;
	[self.navigationController pushViewController:cinemaDetailController animated:YES];
	[cinemaDetailController release];
}

@end
