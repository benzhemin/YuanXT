//
//  YXTSeatSelController.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXTSeatSelController.h"
#import "YXTSeatService.h"
#import "YXTShowService.h"
#import "YXTNavigationBarView.h"
#import "YXTSeatButton.h"
#import "YXTOrderService.h"
#import "YXTTicketController.h"
#import "YXTSeatBackView.h"

static int row_max = 0;
static int col_max = 0;

@implementation YXTSeatSelController

@synthesize seatService;
@synthesize orderService;
@synthesize showInfo;
@synthesize seatList, pickList;
@synthesize totalCounts;
@synthesize contentView;
@synthesize seatBackView;
@synthesize cinemaNameLabel, hallNameLabel, showDateLabel;
@synthesize seatSelLabel;
@synthesize scrollview;

-(void)dealloc{
    [seatService release];
    [orderService release];
    
    [showInfo release];
    
    [seatList release];
    [pickList release];
    
	[contentView release];
    [seatBackView release];
	
	[cinemaNameLabel release];
	[hallNameLabel release];
	[showDateLabel release];
	
	[seatSelLabel release];
	
	[scrollview release];
	
	[super dealloc];
}


- (void)viewDidLoad{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
	YXTNavigationBarView *naviView = [[YXTNavigationBarView alloc] init];
	naviView.delegateCtrl = self;
	[naviView addBackIconToBar:[UIImage imageNamed:@"btn_back.png"]];
    [naviView addTitleLabelToBar:showInfo.filmName];
    [self.view addSubview:naviView];
	[naviView release];
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]];
    
    cinemaNameLabel.text = showInfo.cinemaName;
    hallNameLabel.text = showInfo.hallName;
    showDateLabel.text = [NSString stringWithFormat:@"%@ %@", showInfo.showDate, showInfo.showTime];
    
    [scrollview setMinimumZoomScale:1.0];
    [scrollview setMaximumZoomScale:1.5];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self requestSeatService];
    [super viewWillAppear:animated];
}

-(void)requestSeatService{
    self.seatService = [[[YXTSeatService alloc] init] autorelease];
    seatService.showInfo = self.showInfo;
    seatService.delegateSeat = self;
    [seatService startToFetchSeatList];
}

-(void)computeMaxRowCol{
    int maxRow = 0;
    int maxCol = 0;
    for (YXTSeatInfo *seatInfo in self.seatList) {
        if (seatInfo.rowNum > maxRow) {
            maxRow = seatInfo.rowNum;
        }
        
        if (seatInfo.columnNum > maxCol) {
            maxCol = seatInfo.columnNum;
        }
    }
    row_max = maxRow;
    col_max = maxCol;
}

-(void)fetchSeatListSucceed:(NSMutableArray *)seatListParam{
    self.seatList = seatListParam;
    [self computeMaxRowCol];
    
    self.totalCounts = 0;
    self.pickList = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    self.seatSelLabel.text = @"";
    
    [self performSelector:@selector(layOutSeatScroll) withObject:nil afterDelay:0.2];
}

#define INDEX_OFFSET 22
#define ROW_SPACING 4
#define COL_SPACING 4
#define SEAT_WIDTH 11
#define SEAT_HEIGHT 18

#define SEAT_NUMLABEL_OFFSET 5

#define SCROLL_WIDTH_SPAN 20
#define SCROLL_HEIGHT_SPAN 20

#define ZOOM_VIEW_TAG 100

#define ZOOM_MAXIMUM 1.7
#define ZOOM_MINIMUM 0.7

-(void)layOutSeatScroll{
    //self.scrollView.delegate = self;
	self.scrollview.pagingEnabled = NO;
	self.scrollview.showsHorizontalScrollIndicator = YES;
    self.scrollview.showsVerticalScrollIndicator = YES;
    self.scrollview.delegate = self;
	
	for (UIView *view in [self.scrollview subviews]) {
		[view removeFromSuperview];
	}
    
    CGSize contentSize = CGSizeMake(INDEX_OFFSET+SEAT_WIDTH*col_max+COL_SPACING*(col_max+1)+SCROLL_WIDTH_SPAN, 
                                             SEAT_HEIGHT*row_max+ROW_SPACING*(row_max+1)+SCROLL_HEIGHT_SPAN);
    
    self.scrollview.contentSize = contentSize;
    self.seatBackView = [[[YXTSeatBackView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)] autorelease];
    seatBackView.tag = ZOOM_VIEW_TAG;
    
    //float minimumScale = [scrollview frame].size.width  / [seatBackView frame].size.width;
    [scrollview setMinimumZoomScale:ZOOM_MINIMUM];
    [scrollview setMaximumZoomScale:ZOOM_MAXIMUM];
    
    int rowNum = -1;
    for (YXTSeatInfo *seatInfo in self.seatList) {
        if ([seatInfo.damageFlag isEqualToString:@"N"]) {
            int colnum = seatInfo.columnNum;
            int rownum = seatInfo.rowNum;
            
            if (seatInfo.rowNum != rowNum) {
                rowNum = seatInfo.rowNum;
                UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rownum*ROW_SPACING+(rownum-1)*SEAT_HEIGHT-SEAT_NUMLABEL_OFFSET, 20, SEAT_HEIGHT+SEAT_NUMLABEL_OFFSET)];
                [rowLabel setBackgroundColor:[UIColor lightGrayColor]];
                rowLabel.font = [UIFont boldSystemFontOfSize:14];
                rowLabel.text = seatInfo.rowId;
                rowLabel.textAlignment = UITextAlignmentCenter;
                [self.seatBackView addSubview:rowLabel];
                [rowLabel release];
            }
        
            YXTSeatButton *seatBtn = [[YXTSeatButton alloc] initStatus:seatInfo.statusType];
            seatBtn.seatInfo = seatInfo;
            seatBtn.delegateSeat = self;
            seatBtn.frame = CGRectMake(INDEX_OFFSET+colnum*COL_SPACING+(colnum-1)*SEAT_WIDTH, 
                                       rownum*ROW_SPACING+(rownum-1)*SEAT_HEIGHT, SEAT_WIDTH, SEAT_HEIGHT);
            [self.seatBackView addSubview:seatBtn];
            [seatBtn release];
        }
    }
    
    [self.scrollview addSubview:seatBackView];
    
    [self removeActivityView];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollview viewWithTag:ZOOM_VIEW_TAG];
}


- (void)handleSeatTap:(CGPoint) point {
    // double tap zooms in
    float newScale = [scrollview zoomScale] * ZOOM_MAXIMUM;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:point];
    [scrollview zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [scrollview frame].size.height / scale;
    zoomRect.size.width  = [scrollview frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(void)selectCinemaSeat:(YXTSeatInfo *)seatInfo{
    if (totalCounts >= SEL_MAX_SEAT) {
        NSLog(@"encounter error!");
        return;
    }
    
    [self.pickList addObject:seatInfo];
    
    NSMutableString *pickStr = [NSMutableString string];
    for (YXTSeatInfo *seatInfo in pickList) {
        [pickStr appendFormat:@"%@排%@座  ", seatInfo.rowId, seatInfo.columnId];
    }

    seatSelLabel.text = pickStr;
    
    totalCounts++;
}

-(void)deSelectCinemaSeat:(YXTSeatInfo *)seatInfo{
    totalCounts--;
    
    [self.pickList removeObject:seatInfo];
    
    NSMutableString *pickStr = [NSMutableString string];
    for (YXTSeatInfo *seatInfo in pickList) {
        [pickStr appendFormat:@"%@排%@座  ", seatInfo.rowId, seatInfo.columnId];
    }
    
    seatSelLabel.text = pickStr;
}


-(IBAction)popToPreviousViewController:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)pressSubmitSeat:(id)sender{
    if ([pickList count] > 0) {
        self.orderService = [[[YXTOrderService alloc] init] autorelease];
        orderService.delegateSeat = self;
        orderService.pickList = self.pickList;
        orderService.showSeqNo = showInfo.showSeqNo;
        [orderService startToFetchFilmOrder];
    }else{
        self.waitingMessage = @"请选座位后提交";
        [self displayActivityView];
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1.5];
    }
}

-(void)fetchFilmOrderSucceed:(YXTOrderInfo *)orderInfoParam{
    YXTTicketController *ticketController = [[YXTTicketController alloc] init];
    ticketController.showInfo = self.showInfo;
    ticketController.orderInfo = orderInfoParam;
    ticketController.pickList = self.pickList;
    [self.navigationController pushViewController:ticketController animated:YES];
    [ticketController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
