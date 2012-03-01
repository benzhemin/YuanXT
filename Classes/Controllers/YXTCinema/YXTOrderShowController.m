//
//  YXTOrderShowController.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTOrderShowController.h"
#import "YXTNavigationBarView.h"
#import "YXTHotFilmService.h"
#import "YXTCinemaService.h"
#import "YXTShowService.h"

@implementation YXTOrderShowController

@synthesize cinemaInfo, filmInfo;
@synthesize showService, showList;
@synthesize contentView;
@synthesize orderTableView;
@synthesize cinemaLabel, filmLabel;
@synthesize dateSegImgView, selectDateStr, todayStr, tomorrowStr;
@synthesize todayLabel, tomorrowLabel;

-(void)dealloc{
	[cinemaInfo release];
	[filmInfo release];
	
	[showService release];
	[showList release];
	
	[dateSegImgView release];
	[selectDateStr release];
	[todayStr release];
	[tomorrowStr release];
	
	[todayLabel release];
	[tomorrowLabel release];
	
	[contentView release];
	[orderTableView release];
	
	[cinemaLabel release];
	[filmLabel release];
	
	[super dealloc];
}

-(id)init{
	if (self=[super init]) {
		self.hidesBottomBarWhenPushed = YES;
		
		dateTag = today_tag;
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
	[naviView addTitleLabelToBar:@"上映场次"];
	[naviView addFunctionIconToBar:[UIImage imageNamed:@"btn_yingyuanxiangqing.png"]];
	[self.view addSubview:naviView];
	[naviView release];	
}

- (void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
    [self setUpCurrentDate];
	[self setUpNaviBarView];
	
	selectDateStr = todayStr;
	
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
	
	
	self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 90, 310, 300) style:UITableViewStyleGrouped];
	[self.orderTableView setDelegate:self];
	[self.orderTableView setDataSource:self];
	[self.orderTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.contentView addSubview:orderTableView];
	
	
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == dateSegImgView) {
		CGPoint touchPoint = [touch locationInView:dateSegImgView];
		if (touchPoint.x < [dateSegImgView bounds].size.width/2) {
			if (dateTag == tomorrow_tag) {
				dateTag = today_tag;
				self.selectDateStr = todayStr;
				
				todayLabel.textColor = [UIColor whiteColor];
				tomorrowLabel.textColor = [UIColor blackColor];
				[dateSegImgView setImage:[UIImage imageNamed:@"tab1.png"]];
				
				[self requestShowService];
			}
		}else {
			if (dateTag == today_tag) {
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
	[self performSelectorOnMainThread:@selector(refreshFilmTableView) withObject:nil waitUntilDone:NO];
}

-(void)refreshFilmTableView{
	[self.orderTableView reloadData];
}

-(void)requestHasNoCount{
	self.showList = [[NSMutableArray alloc] initWithCapacity:0];
	[self performSelectorOnMainThread:@selector(refreshFilmTableView) withObject:nil waitUntilDone:NO];
}

#pragma mark UITableViewDataSource delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.showList count];
}

#pragma mark UITableViewDelegate delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellFilmShowIdentifier = @"CELLFILMSHOW";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}

#define FILM_TABLE_HEIGHT 112.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return FILM_TABLE_HEIGHT;
}


@end
