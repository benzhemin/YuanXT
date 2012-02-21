    //
//  YXTCinimaTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTCinemaTabController.h"
#import "YXTCinemaService.h"

@implementation YXTCinemaTabController

@synthesize filmInfo, cinimaService, cinemaDistrictList;
@synthesize cinemaTableView;

- (void)dealloc {
	[filmInfo release];
	[cinimaService release];
	[cinemaDistrictList release];
	[cinemaTableView release];
    [super dealloc];
}


-(id)init{
	if (self=[super init]) {
	}
	return self;
}

-(void)viewDidLoad{
	if (self.filmInfo != nil) {
		[self setUpUINavigationBarItem];
	}
	
	self.cinemaTableView = [[UITableView alloc] initWithFrame:self.view.frame
														style:UITableViewStylePlain];
	[self.cinemaTableView setDelegate:self];
	[self.cinemaTableView setDataSource:self];
	[self.cinemaTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.view addSubview:cinemaTableView];
	
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	[self refreshCinemaListTable];
	[super viewWillAppear:animated];
}

-(void)refreshCinemaListTable{
	self.cinimaService = [[YXTCinemaService alloc] init];
	[cinimaService setDelegateCinema:self];
	[cinimaService startToFetchCinimaList];
}

-(void)fetchCinemaDistrictListSucceed:(NSMutableArray *)districtList{
	self.cinemaDistrictList = districtList;
	
	//[self.cinemaTableView reloadData];
}

#pragma mark UITableViewDataSource delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (cinemaDistrictList == nil || [cinemaDistrictList count]==0) {
		return 0;
	}
	
	return 0;
}

#pragma mark UITableViewDelegate delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// don't keep the table selection
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cinema"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:@"searchName"] autorelease];
	}
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 60;
}


-(void)setUpUINavigationBarItem{
	// set uibaritem
	UIButton *cinimaDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cinimaDetailBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *cinimaDetailImg = [UIImage imageNamed:@"btn_yingyuanxiangqing.png"];
	[cinimaDetailBtn setFrame:CGRectMake(0, 0, cinimaDetailImg.size.width+15.0, cinimaDetailImg.size.height+8.0)];
	[cinimaDetailBtn setBackgroundImage:cinimaDetailImg forState:UIControlStateNormal];
	[cinimaDetailBtn addTarget:self action:@selector(pressCitySwitchBtn) forControlEvents:UIControlEventTouchUpInside];

	
	UIBarButtonItem *cityDetailItem = [[UIBarButtonItem alloc] initWithCustomView:cinimaDetailBtn];	
	self.navigationItem.rightBarButtonItem = cityDetailItem;
	[cityDetailItem release];
}

-(NSString *)getTabTitle{ return @"影院"; }
-(NSString *)getTabImage{ return @"icon_yingyuan.png"; }
-(int) getTabTag{ return 2; }

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

