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

@implementation YXTCinemaTabController

@synthesize filmInfo, cinimaService, cinemaDistrictList;
@synthesize cinemaTableView;

@synthesize nodeSelectBgImage, nodeBgImage;
@synthesize nodeRightImage, nodeDownImage;
@synthesize cinemaPicImage;

- (void)dealloc {
	[filmInfo release];
	[cinimaService release];
	[cinemaDistrictList release];
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
	}
	return self;
}

-(void)viewDidLoad{
	if (self.filmInfo != nil) {
		[self setUpUINavigationBarItem];
	}
	
	CGRect tableFrame = CGRectZero;
	tableFrame.size.width = self.view.bounds.size.width;
	tableFrame.size.height = 360;
	
	self.cinemaTableView = [[UITableView alloc] initWithFrame:tableFrame
														style:UITableViewStylePlain];
	[self.cinemaTableView setDelegate:self];
	[self.cinemaTableView setDataSource:self];
	[self.cinemaTableView setBackgroundColor:[UIColor clearColor]];
	
	[self.view addSubview:cinemaTableView];
	
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
	self.cinimaService = [[YXTCinemaService alloc] init];
	[cinimaService setDelegateCinema:self];
	[cinimaService startToFetchCinimaList];
}

-(void)fetchCinemaDistrictListSucceed:(NSMutableArray *)districtList{
	self.cinemaDistrictList = districtList;
	
	//默认树的第一个节点为展开
	((YXTDistrict *)[cinemaDistrictList objectAtIndex:0]).isExpand = YES;
	
	[self.cinemaTableView reloadData];
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
			if (distIndexParam==NULL || cinemaIndexParam==NULL) {
				isNode = NO;
				break;
			}
			*distIndexParam = lastDistIndex;
			*cinemaIndexParam = lastCinemaIndex;
			isNode = NO;
			break;
		}
	}
	return isNode;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellTreeNodeIdentifier = @"Tree_Node";
	static NSString *cellTreeLeafIdentifier = @"Tree_Leaf";
	
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
		bgImgView.tag = 1;
		
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
		rightImgView.tag = 2;
		
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
		
		UIImageView *picImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, cinemaPicImage.size.width, cinemaPicImage.size.height)];
		[picImgView setImage:cinemaPicImage];
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
		
		NSString *supportOnline = @"支持在线选座";
		NSString *notSupportOnline = @"不支持在线选座";
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
				if (view.tag == 1) {
					UIImageView *bgImgView = (UIImageView *)view;
					[bgImgView setImage:nodeBgImage];
				}
				if (view.tag == 2) {
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
				if (view.tag == 1) {
					UIImageView *bgImgView = (UIImageView *)view;
					[bgImgView setImage:nodeSelectBgImage];
				}
				if (view.tag == 2) {
					UIImageView *foldImgView = (UIImageView *)view;
					[foldImgView setImage:nodeDownImage];
				}
			}
		}

	}else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

