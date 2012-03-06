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
#import "YXTCinemaDetailController.h"
#import "YXTFilmDetailController.h"
#import "YXTSeatSelController.h"

@implementation YXTOrderShowController

@synthesize cinemaInfo, filmInfo;
@synthesize showService, showList;
@synthesize contentView;
@synthesize seatImg, orderTableView;
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
    [seatImg release];
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
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];
    
    cinemaLabel.text = cinemaInfo.cinemaName;
    filmLabel.text = filmInfo.filmName;
    
    UIImage *filmDetailImg = [UIImage imageNamed:@"btn_gray_yingpianxiangqing.png"];
    UIButton *filmDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filmDetailBtn addTarget:self action:@selector(pushToFilmDetailController:) forControlEvents:UIControlEventTouchUpInside];
    filmDetailBtn.bounds = CGRectMake(0, 0, filmDetailImg.size.width+15, filmDetailImg.size.height+6);
    [filmDetailBtn setBackgroundImage:filmDetailImg forState:UIControlStateNormal];
    filmDetailBtn.center = CGPointMake(280, filmLabel.center.y);
    [self.contentView addSubview:filmDetailBtn];
	
	selectDateStr = todayStr;
	
	CGRect dateSegFrame = CGRectMake(57, 75, 206, 31);
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
	
	self.seatImg = [UIImage imageNamed:@"icon_zuowei.png"];
    
	self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 110, 310, 280) style:UITableViewStyleGrouped];
	[self.orderTableView setDelegate:self];
	[self.orderTableView setDataSource:self];
	[self.orderTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.contentView addSubview:orderTableView];
	
	[self requestShowService];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
	showService.delegateFilm = self;
	showService.cinemaInfo = self.cinemaInfo;
    if (self.filmInfo) {
        showService.filmInfo = filmInfo;
    }
	
	[showService startToFetchShowList];
}

-(void)showListFetchSucceed:(NSMutableArray *)showListParam{
	self.showList = showListParam;
    
	[self performSelectorOnMainThread:@selector(refreshFilmTableView) withObject:nil waitUntilDone:NO];
}

-(void)refreshFilmTableView{
	[self.orderTableView reloadData];
    
    [self performSelector:@selector(scrollTableToTop) withObject:nil afterDelay:0.2];
}

-(void)scrollTableToTop{
    if ([self.showList count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [orderTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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
	return ([self.showList count]+1);
}

#pragma mark UITableViewDelegate delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellOrderShowIdentifier = @"CELLORDERSHOW";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellOrderShowIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleDefault reuseIdentifier:cellOrderShowIdentifier] autorelease];
	}
    
    for (UIView *unitview in [cell.contentView subviews]) {
		[unitview removeFromSuperview];
	}
    
    int index = indexPath.row;
    
    if (index == 0) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 40, 30)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont boldSystemFontOfSize:16];
        timeLabel.text = @"时间";
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        
        UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 7, 40, 30)];
        verLabel.backgroundColor = [UIColor clearColor];
        verLabel.font = [UIFont boldSystemFontOfSize:16];
        verLabel.text = @"版本";
        [cell.contentView addSubview:verLabel];
        [verLabel release];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(167, 7, 40, 30)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont boldSystemFontOfSize:16];
        priceLabel.text = @"价格";
        [cell.contentView addSubview:priceLabel];
        [priceLabel release];
        
        UILabel *seatLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 7, 40, 30)];
        seatLabel.backgroundColor = [UIColor clearColor];
        seatLabel.font = [UIFont boldSystemFontOfSize:16];
        seatLabel.text = @"选座";
        [cell.contentView addSubview:seatLabel];
        [seatLabel release];
    }else{
        YXTShowInfo *showInfo = [self.showList objectAtIndex:(index-1)];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 7, 50, 30)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.text = showInfo.showTime;
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        
        UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 7, 60, 30)];
        verLabel.backgroundColor = [UIColor clearColor];
        verLabel.font = [UIFont systemFontOfSize:15];
        verLabel.text = showInfo.filmVer;
        [cell.contentView addSubview:verLabel];
        [verLabel release];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(167, 7, 60, 30)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.text = showInfo.bestPayPrice;
        [cell.contentView addSubview:priceLabel];
        [priceLabel release];
        
        UIButton *seatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seatBtn.frame = CGRectMake(247, 9, seatImg.size.width, seatImg.size.height);
        seatBtn.tag = index-1;
        [seatBtn setBackgroundImage:seatImg forState:UIControlStateNormal];
        [seatBtn addTarget:self action:@selector(pressChooseSeat:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:seatBtn];
    }
    return cell;
}

-(void)pushToSeatSelController:(int)index{
    YXTShowInfo *showInfo = [self.showList objectAtIndex:index];
    
    YXTSeatSelController *seatSelController = [[YXTSeatSelController alloc] init];
    seatSelController.showInfo = showInfo;
    
    [self.navigationController pushViewController:seatSelController animated:YES];
    [seatSelController release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    if (indexPath.row == 0) {
        return;
    }

	[self pushToSeatSelController:(indexPath.row-1)];
}

#define ORDER_TABLE_HEIGHT 44.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return ORDER_TABLE_HEIGHT;
}


-(IBAction)pushToFilmDetailController:(id)sender{
    YXTFilmDetailController *filmDetailController = [[YXTFilmDetailController alloc] init];
    filmDetailController.filmInfo = self.filmInfo;
    [self.navigationController pushViewController:filmDetailController animated:YES];
    [filmDetailController release];
}

-(IBAction)popToPreviousViewController:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];	
}

-(IBAction)pressChooseSeat:(id)sender{
    [self pushToSeatSelController:((UIView *)sender).tag];
}

-(IBAction)funcToViewController:(id)sender{
	YXTCinemaDetailController *cinemaDetailController = [[YXTCinemaDetailController alloc] init];
	cinemaDetailController.cinemaInfo = cinemaInfo;
	[self.navigationController pushViewController:cinemaDetailController animated:YES];
	[cinemaDetailController release];
}

@end
