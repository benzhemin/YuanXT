//
//  YXTCinimaTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTCinemaTabController.h"
#import "YXTCinemaService.h"
#import "YXTUIImageView.h"
#import "ASINetworkQueue.h"
#import "OFReachability.h"
#import "YXTNavigationBarView.h"
#import "YXTFilmDetailController.h"
#import "YXTHotFilmService.h"
#import "YXTCinemaDetailController.h"
#import "YXTFilmShowController.h"

enum TreeNodeLeafTag {
	//node bg img
	node_bg_tag = 1,
	//node right fold icon
	node_fold_tag,
	leaf_cinema_tag
};


@implementation YXTCinemaTabController

@synthesize filmInfo, cinimaService, cinemaDistrictList;
@synthesize imageQueue;
@synthesize contentView, cinemaTableView;
@synthesize nodeSelectBgImage, nodeBgImage;
@synthesize nodeRightImage, nodeDownImage;
@synthesize cinemaPicImage;


- (void)dealloc {
	[filmInfo release];
	[cinimaService release];
	[cinemaDistrictList release];
	[imageQueue release];
	[contentView release];
	[cinemaTableView release];
	[nodeSelectBgImage release];
	[nodeBgImage release];
	[nodeRightImage release];
	[nodeDownImage release];
	[cinemaPicImage release];
    [super dealloc];
}


-(id)init{
	if (self=[super init]) {
		
		tableFrame = CGRectZero;
		tableFrame.size.height = 396;
		
		self.hidesBottomBarWhenPushed = YES;
		self.imageQueue = [[ASINetworkQueue alloc] init];
		[imageQueue go];
	}
	return self;
}

-(id)initWithTab{
	if (self=[super initWithTab]){
		
		tableFrame = CGRectZero;
		tableFrame.size.height = 360;
		
		self.imageQueue = [[ASINetworkQueue alloc] init];
		[imageQueue go];
	}
	return self;
}

-(void)viewDidLoad{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
	
	if (self.filmInfo != nil) {
		[naviView addFunctionIconToBar:[UIImage imageNamed:@"btn_dianyingxiangqing.png"]];
		[naviView addTitleLabelToBar:self.filmInfo.filmName];
	}else {
		[naviView addTitleLabelToBar:@"影院列表"];
	}

	
	[self.view addSubview:naviView];
	[naviView release];
	
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, tableFrame.size.height)];
	[self.view addSubview:contentView];
	
	tableFrame.size.width = self.view.bounds.size.width;
	
	self.cinemaTableView = [[UITableView alloc] initWithFrame:tableFrame
														style:UITableViewStylePlain];
	[self.cinemaTableView setDelegate:self];
	[self.cinemaTableView setDataSource:self];
	[self.cinemaTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.contentView addSubview:cinemaTableView];
	
	self.nodeSelectBgImage = [UIImage imageNamed:@"node_xuanzhong_bg_t.png"];
	self.nodeBgImage = [UIImage imageNamed:@"node_bg_t.png"];
	
	self.nodeRightImage = [UIImage imageNamed:@"icon_right.png"];
	self.nodeDownImage = [UIImage imageNamed:@"icon_down.png"];
	
	self.cinemaPicImage = [UIImage imageNamed:@"cinema_pic.png"];
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	[self refreshCinemaListTable];
	[super viewWillAppear:animated];
}

-(void)refreshCinemaListTable{
	if (self.filmInfo != nil) {
		[self setUpUINavigationBarItem];
	}
	
	self.cinimaService = [[YXTCinemaService alloc] init];
	[cinimaService setDelegateCinema:self];
	[cinimaService startToFetchCinimaList];
}

-(void)fetchCinemaDistrictListSucceed:(NSMutableArray *)districtList{
	self.cinemaDistrictList = districtList;
	
	//默认树的第一个节点为展开
	YXTDistrict *district = [cinemaDistrictList objectAtIndex:0];
	district.isExpand = YES;
	
	int distIndex = 0;
	int cinemaIndex = 0;
	for (YXTCinemaInfo *cinemaInfo in district.cinemaList) {
		if (cinemaInfo.cinemaImage != nil) {
			cinemaIndex++;
			continue;
		}
		
		YXTCinemaImgLoader *imgLoader = [YXTCinemaImgLoader requestWithURL:[NSURL URLWithString:cinemaInfo.cinemaPhoto]];
		imgLoader.cinemaInfo = cinemaInfo;
		imgLoader.reqDelegate = self;
		
		imgLoader.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:distIndex], @"distIndex", 
																		[NSNumber numberWithInt:cinemaIndex], @"cinemaIndex", 
																		nil];;
		
		if ([OFReachability isConnectedToInternet]) {
			[self.imageQueue addOperation:imgLoader];
		}
		
		cinemaIndex++;
	}
	
	[self.cinemaTableView reloadData];
}

-(void)imageRequestFinished:(NSDictionary *)userInfo{
	int distIndex = [((NSNumber *)[userInfo objectForKey:@"distIndex"]) intValue];
	int cinemaIndex = [((NSNumber *)[userInfo objectForKey:@"cinemaIndex"]) intValue];
	
	YXTDistrict *district = [self.cinemaDistrictList objectAtIndex:distIndex];
	YXTCinemaInfo *cinemaInfo = [district.cinemaList objectAtIndex:cinemaIndex];
	
	if (district.isExpand == NO) {
		return ;
	}
	
	int cellIndex = 0;
	for (int i=0; i<=distIndex; i++) {
		cellIndex++;
		if (i == distIndex) {
			break;
		}
		
		YXTDistrict *dist = [self.cinemaDistrictList objectAtIndex:i];
		if (dist.isExpand) {
			cellIndex = cellIndex + [dist.cinemaList count];
		}
	}
	cellIndex = cellIndex + cinemaIndex;
	
	UITableViewCell *cell = [self.cinemaTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
	for (UIView *view in [cell.contentView subviews]) {
		if (view.tag == leaf_cinema_tag) {
			UIImageView *cinemaImgView = (UIImageView *)view;
			[cinemaImgView setImage:cinemaInfo.cinemaImage];
		}
	}
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
	
	int nodeCount = [self.cinemaDistrictList count];
	for (YXTDistrict *district in cinemaDistrictList) {
		if (district.isExpand) {
			nodeCount = nodeCount + [district.cinemaList count];
		}
	}
	
	return nodeCount;
}

#pragma mark UITableViewDelegate delegates

//judge index is node or leaf
-(bool)isIndexNode:(int)index districtIndex:(int *)distIndexParam cinemaIndex:(int *)cinemaIndexParam{
	int distIndex = 0;
	int cur = 0;
	bool isNode = NO;
	
	int lastDistIndex = 0;
	int lastCinemaIndex = 0;
	
	for (YXTDistrict *district in self.cinemaDistrictList) {
		if (cur < index) {
			
			lastDistIndex = distIndex;
			//从第0个节点计数（cur＋1）
			lastCinemaIndex = index-(cur+1);
			
			if (distIndexParam!=NULL && cinemaIndexParam!=NULL) {
				*distIndexParam = lastDistIndex;
				*cinemaIndexParam = lastCinemaIndex;
			}
			
			if (district.isExpand) {
				cur = cur + [district.cinemaList count];
			}
			cur = cur++;
			distIndex++;
		}else if (cur == index) {
			if (distIndexParam != NULL) {
				*distIndexParam = distIndex;
			}
			isNode = YES;
			break;
		}else {
			//improve efficiency
			isNode = NO;
			break;
		}
	}
	return isNode;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellTreeNodeIdentifier = @"Tree_Node";
	static NSString *cellTreeLeafIdentifier = @"Tree_Leaf";
	static NSString *supportOnline = @"支持在线选座";
	static NSString *notSupportOnline = @"不支持在线选座";
	
	int distIndex = 0;
	int cinemaIndex = 0;
	int index = indexPath.row;
	
	UITableViewCell* cell;
	if ([self isIndexNode:index districtIndex:&distIndex cinemaIndex:&cinemaIndex]) {
		cell = [tableView dequeueReusableCellWithIdentifier:cellTreeNodeIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTreeNodeIdentifier] autorelease];
		}
		
		for (UIView *unitview in [cell.contentView subviews]) {
			[unitview removeFromSuperview];
		}
		
		CGRect bgFrame = CGRectZero;
		bgFrame.size.width = nodeBgImage.size.width;
		bgFrame.size.height = nodeBgImage.size.height;
		UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:bgFrame];
		bgImgView.tag = node_bg_tag;
		
		YXTDistrict *district = [self.cinemaDistrictList objectAtIndex:distIndex];
		if (district.isExpand) {
			[bgImgView setImage:nodeSelectBgImage];
		}else {
			[bgImgView setImage:nodeBgImage];
		}
		[cell.contentView addSubview:bgImgView];
		[bgImgView release];

	
		UILabel *distLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, bgFrame.size.height)];
		distLabel.backgroundColor = [UIColor clearColor];
		distLabel.font = [UIFont boldSystemFontOfSize:15.0f];
		distLabel.textAlignment = UITextAlignmentLeft;
		distLabel.text = district.distName;
		[cell.contentView addSubview:distLabel];
		[distLabel release];
		
		UILabel *distCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 70, bgFrame.size.height)];
		distCountLabel.backgroundColor = [UIColor clearColor];
		distCountLabel.font = [UIFont boldSystemFontOfSize:15.0f];
		distCountLabel.textColor = [UIColor colorWithRed:1.0 green:0.53 blue:0.1 alpha:1.0];
		distCountLabel.textAlignment = UITextAlignmentLeft;
		distCountLabel.text = [NSString stringWithFormat:@"( %d家 )", [district.cinemaList count]];
		[cell.contentView addSubview:distCountLabel];
		[distCountLabel release];
		
		UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 6, nodeRightImage.size.width, nodeRightImage.size.height)];
		rightImgView.tag = node_fold_tag;
		
		if (district.isExpand) {
			[rightImgView setImage:nodeDownImage];
		}else {
			[rightImgView setImage:nodeRightImage];
		}
		
		[cell.contentView addSubview:rightImgView];
		[rightImgView release];
		
	}else {
		cell = [tableView dequeueReusableCellWithIdentifier:cellTreeLeafIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTreeNodeIdentifier] autorelease];
		}
		for (UIView *unitview in [cell.contentView subviews]) {
			[unitview removeFromSuperview];
		}
	
		YXTDistrict *district = [self.cinemaDistrictList objectAtIndex:distIndex];
		YXTCinemaInfo *cinemaInfo = [district.cinemaList objectAtIndex:cinemaIndex];
		
		YXTUIImageView *picImgView = [[YXTUIImageView alloc] init];
		picImgView.tag = leaf_cinema_tag;
		picImgView.frame = CGRectMake(20, 16, cinemaPicImage.size.width, cinemaPicImage.size.height);
		
		if (cinemaInfo.cinemaImage != nil) {
			[picImgView setImage:cinemaInfo.cinemaImage];
		}else {
			[picImgView setImage:cinemaPicImage];
		}
		
		[cell.contentView addSubview:picImgView];
		[picImgView release];
		
		UILabel *cinemaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 230, 25)];
		cinemaNameLabel.backgroundColor = [UIColor clearColor];
		cinemaNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
		cinemaNameLabel.textColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.8 alpha:1.0];
		cinemaNameLabel.textAlignment = UITextAlignmentLeft;
		cinemaNameLabel.text = cinemaInfo.cinemaName;
		[cell.contentView addSubview:cinemaNameLabel];
		[cinemaNameLabel release];
		
		UILabel *cinemaAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 230, 20)];
		cinemaAddressLabel.backgroundColor = [UIColor clearColor];
		cinemaAddressLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		cinemaAddressLabel.textAlignment = UITextAlignmentLeft;
		cinemaAddressLabel.text = cinemaInfo.address;
		[cell.contentView addSubview:cinemaAddressLabel];
		[cinemaAddressLabel release];
		
		UILabel *onlineOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 45, 230, 20)];
		onlineOrderLabel.backgroundColor = [UIColor clearColor];
		onlineOrderLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		onlineOrderLabel.textColor = [UIColor colorWithRed:1.0 green:0.53 blue:0.1 alpha:1.0];
		onlineOrderLabel.textAlignment = UITextAlignmentLeft;
		
		if ([cinemaInfo.onlineOrder isEqualToString:@"Y"]) {
			onlineOrderLabel.text = supportOnline;
		}else {
			onlineOrderLabel.text = notSupportOnline;
		}
		
		[cell.contentView addSubview:onlineOrderLabel];
		[onlineOrderLabel release];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// don't keep the table selection
	
	int distIndex = 0;
	int cinemaIndex = 0;
	int index = indexPath.row;
	
	if ([self isIndexNode:index districtIndex:&distIndex cinemaIndex:&cinemaIndex]) {
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		YXTDistrict *district = [self.cinemaDistrictList objectAtIndex:distIndex];
		if (district.isExpand) {
			district.isExpand = NO;
			
			int cellIndex = index+1;
			NSMutableArray *deleteCells=[NSMutableArray array];
			for(YXTCinemaInfo *cinemaInfo in district.cinemaList) {
				[deleteCells addObject:[NSIndexPath indexPathForRow:cellIndex++ inSection:0]];
			}
			
			[tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
			
			for (UIView *view in [cell.contentView subviews]) {
				if (view.tag == node_bg_tag) {
					UIImageView *bgImgView = (UIImageView *)view;
					[bgImgView setImage:nodeBgImage];
				}
				if (view.tag == node_fold_tag) {
					UIImageView *foldImgView = (UIImageView *)view;
					[foldImgView setImage:nodeRightImage];
				}
			}
		}else {
			district.isExpand = YES;
			
			int cellIndex = index+1;
			NSMutableArray *insertCells=[NSMutableArray array];
			for(YXTCinemaInfo *cinemaInfo in district.cinemaList) {
				[insertCells addObject:[NSIndexPath indexPathForRow:cellIndex++ inSection:0]];
			}
			[tableView insertRowsAtIndexPaths:insertCells withRowAnimation:UITableViewRowAnimationLeft];
			
			for (UIView *view in [cell.contentView subviews]) {
				if (view.tag == node_bg_tag) {
					UIImageView *bgImgView = (UIImageView *)view;
					[bgImgView setImage:nodeSelectBgImage];
				}
				if (view.tag == node_fold_tag) {
					UIImageView *foldImgView = (UIImageView *)view;
					[foldImgView setImage:nodeDownImage];
				}
			}
			
			//here we process the tree leaf.
			int tempCinemaIndex = 0;
			for (YXTCinemaInfo *cinemaInfo in district.cinemaList) {
				if (cinemaInfo.cinemaImage != nil) {
					tempCinemaIndex++;
					continue;
				}
				
				YXTCinemaImgLoader *imgLoader = [YXTCinemaImgLoader requestWithURL:[NSURL URLWithString:cinemaInfo.cinemaPhoto]];
				imgLoader.cinemaInfo = cinemaInfo;
				imgLoader.reqDelegate = self;
				
				imgLoader.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:distIndex], @"distIndex", 
									  [NSNumber numberWithInt:tempCinemaIndex], @"cinemaIndex", 
									  nil];;
				
				if ([OFReachability isConnectedToInternet]) {
					[self.imageQueue addOperation:imgLoader];
				}
				
				tempCinemaIndex++;
			}
		}

	}else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		[self.imageQueue cancelAllOperations];
		YXTDistrict *district = [self.cinemaDistrictList objectAtIndex:distIndex];
		YXTCinemaInfo *cinemaInfo = [district.cinemaList objectAtIndex:cinemaIndex];
		
		if (self.filmInfo) {
			
		}else {
			YXTFilmShowController *filmShowController = [[YXTFilmShowController alloc] init];
			filmShowController.cinemaInfo = cinemaInfo;
			[self.navigationController pushViewController:filmShowController animated:YES];
			[filmShowController release];
		}
	}
}

#define TABLE_TREE_NODE_HEIGHT 36
#define TABLE_TREE_LEAF_HEIGHT 72

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self isIndexNode:indexPath.row districtIndex:NULL cinemaIndex:NULL]) {
		return TABLE_TREE_NODE_HEIGHT;
	}else {
		return TABLE_TREE_LEAF_HEIGHT;
	}
}

-(IBAction)popToPreviousViewController:(id)sender{
	if (self.filmInfo != nil) {
		[self.imageQueue cancelAllOperations];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(IBAction)funcToViewController:(id)sender{
	if (self.filmInfo != nil) {
		YXTFilmDetailController *filmDetailController = [[YXTFilmDetailController alloc] init];
		filmDetailController.filmInfo = self.filmInfo;
		[self.navigationController pushViewController:filmDetailController animated:YES];
		[filmDetailController release];
	}
}


-(void)setUpUINavigationBarItem{
	// set uibaritem
	UIButton *cinimaDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cinimaDetailBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *cinimaDetailImg = [UIImage imageNamed:@"btn_yingyuanxiangqing.png"];
	[cinimaDetailBtn setFrame:CGRectMake(0, 0, cinimaDetailImg.size.width+15.0, cinimaDetailImg.size.height+8.0)];
	[cinimaDetailBtn setBackgroundImage:cinimaDetailImg forState:UIControlStateNormal];
	[cinimaDetailBtn addTarget:self action:@selector(pressCitySwitchBtn) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *cinemaDetailItem = [[UIBarButtonItem alloc] initWithCustomView:cinimaDetailBtn];	
	self.navigationItem.rightBarButtonItem = cinemaDetailItem;
	[cinemaDetailItem release];
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

