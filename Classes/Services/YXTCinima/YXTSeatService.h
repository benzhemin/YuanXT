//
//  YXTSeatService.h
//  YuanXT
//
//  Created by zhe zhang on 12-3-5.
//  Copyright (c) 2012年 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicViewController.h"
#import "BasicInfo.h"
#import "YXTBasicService.h"

@class YXTShowInfo;

@interface YXTSeatService : YXTBasicService<OFXPResponseJSON>{
    YXTBasicViewController *delegateSeat;
	OFXPRequest *mReq;
    
    YXTShowInfo *showInfo;
    
    NSMutableArray *seatList;
}

@property (nonatomic, assign) YXTBasicViewController *delegateSeat;
@property (nonatomic, retain) YXTShowInfo *showInfo;

@property (nonatomic, retain) NSMutableArray *seatList;

-(void)startToFetchSeatList;

@end

@interface YXTSeatInfo : NSObject<BasicInfo> {
    NSString *rowId;
    NSString *columnId;
    
    int rowNum;
    int columnNum;
    int statusType;
    
    NSString *damageFlag;
    NSString *seatId;
    NSString *sectionId;
}    

@property (nonatomic, copy) NSString *rowId;
@property (nonatomic, copy) NSString *columnId;

@property (nonatomic, assign) int rowNum;
@property (nonatomic, assign) int columnNum;
@property (nonatomic, assign) int statusType;

@property (nonatomic, copy) NSString *damageFlag;
@property (nonatomic, copy) NSString *seatId;
@property (nonatomic, copy) NSString *sectionId;
@end
