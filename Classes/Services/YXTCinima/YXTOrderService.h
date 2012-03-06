//
//  YXTOrderService.h
//  YuanXT
//
//  Created by zhe zhang on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"
#import "YXTBasicViewController.h"
#import "BasicInfo.h"

@class YXTOrderInfo;

@interface YXTOrderService : NSObject<OFXPResponseJSON>{
    YXTBasicViewController *delegateSeat;
	OFXPRequest *mReq;
    
    NSString *showSeqNo;
    NSMutableArray *pickList;
    
    YXTOrderInfo *orderInfo;
}

@property (nonatomic, assign) YXTBasicViewController *delegateSeat;
@property (nonatomic, copy) NSString *showSeqNo;
@property (nonatomic, retain) NSMutableArray *pickList;

@property (nonatomic,retain) YXTOrderInfo *orderInfo;

-(void)startToFetchFilmOrder;

@end

@interface YXTOrderInfo : NSObject<BasicInfo> {
    NSString *subscriptId;
    NSString *productNo;
    NSString *partnerId;
    NSString *partnerName;
    NSString *partnerOrderId;
    NSString *orderId;
    NSString *txnAmount;
    NSString *rating;
    NSString *goodsName;
    NSString *goodsCount;
    NSString *sig;
}    

@property (nonatomic, copy) NSString *subscriptId;
@property (nonatomic, copy) NSString *productNo;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *partnerName;
@property (nonatomic, copy) NSString *partnerOrderId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *txnAmount;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *sig;
    
@end
