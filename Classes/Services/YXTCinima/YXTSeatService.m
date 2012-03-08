//
//  YXTSeatService.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 Ideal Information Industry. All rights reserved.
//

#import "YXTSeatService.h"
#import "OFXPRequest.h"
#import "OFReachability.h"
#import "YXTSettings.h"
#import "YXTShowService.h"

@implementation YXTSeatService

@synthesize delegateSeat;
@synthesize showInfo;
@synthesize seatList;

-(id)init{
    if (self=[super init]) {
        seatList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

-(void)startToFetchSeatList{
	if ([OFReachability isConnectedToInternet]) {
		[delegateSeat setWaitingMessage:@"正在获取影院座位信息"];
		[delegateSeat displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"seat" forKey:@"METHOD"];
		
		[dict setValue:showInfo.showSeqNo forKey:@"SHOWSEQNO"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:@"a6126169c99301f105e742b57df63fb9" forKey:@"SIGN"];
        
        NSLog(@"%@", dict);
		
		OFXPRequest *req = [OFXPRequest postRequestWithPath:url andBody:dict];
		[req onRespondJSON:self];
		[req execute];
		
		mReq = [req retain];
	}else {
		[delegateSeat displayNetWorkErrorActivityView];
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
	
    OFSafeRelease(mReq);
	
	NSDictionary *bodyDict = (NSDictionary *)body;
    NSLog(@"%@", bodyDict);
	NSString *errorCode = [bodyDict objectForKey:@"ERRORCODE"];
	
	if(responseCode == 200 && [errorCode isEqualToString:@"000000"]){
		
		int recordCount = [[bodyDict objectForKey:@"RECORDAMOUNT"] intValue];
        NSArray *seatListBody = [bodyDict objectForKey:@"SEATLIST"];
		
		if ([seatListBody count] != 0 && recordCount != 0) {
			for (NSDictionary *seatDict in seatListBody) {
				YXTSeatInfo *seatInfo = [[YXTSeatInfo alloc] init];
                
                seatInfo.rowId = [seatDict objectForKey:@"ROWID"];
                seatInfo.columnId = [seatDict objectForKey:@"COLUMNID"];
                seatInfo.damageFlag = [seatDict objectForKey:@"DAMAGEDFLAG"];
                seatInfo.seatId = [seatDict objectForKey:@"SEATID"];
                seatInfo.sectionId = [seatDict objectForKey:@"SECTIONID"];
                
                seatInfo.rowNum = ((NSString *)[seatDict objectForKey:@"ROWNUM"]).intValue;
                seatInfo.columnNum = ((NSString *)[seatDict objectForKey:@"COLUMNNUM"]).intValue;
                seatInfo.statusType = ((NSString *)[seatDict objectForKey:@"STATUSTYPE"]).intValue;
                
				[seatList addObject:seatInfo];
				[seatInfo release];
			}
            
            [delegateSeat performSelectorOnMainThread:@selector(fetchSeatListSucceed:) withObject:seatList waitUntilDone:NO];
		}else {
			[delegateSeat setResponseMessage:@"目前暂无数据"];
			[delegateSeat performSelectorOnMainThread:@selector(displayChangeActivityView) withObject:nil waitUntilDone:NO];
		}
	}
    else{
		[delegateSeat performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
}

@end


@implementation YXTSeatInfo

@synthesize rowId, columnId, damageFlag, seatId, sectionId;
@synthesize rowNum, columnNum, statusType;

-(NSString *)infoDescription{
	return @"";
}

-(void)dealloc{
    [rowId release];
    [columnId release];
    [damageFlag release];
    [seatId release];
    [sectionId release];
    
    [super dealloc];
}

@end