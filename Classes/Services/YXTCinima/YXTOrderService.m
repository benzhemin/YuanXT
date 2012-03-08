//
//  YXTOrderService.m
//  YuanXT
//
//  Created by zhe zhang on 12-3-6.
//  Copyright (c) 2012年 Ideal Information Industry. All rights reserved.
//

#import "YXTOrderService.h"
#import "OFXPRequest.h"
#import "OFReachability.h"
#import "YXTSettings.h"
#import "YXTSeatService.h"

@implementation YXTOrderService

@synthesize delegateSeat;
@synthesize showSeqNo;
@synthesize pickList;

@synthesize orderInfo;

-(void)dealloc{
    [showSeqNo release];
    [pickList release];
    
    [orderInfo release];
    [super dealloc];
}

-(void)startToFetchFilmOrder{
	if ([OFReachability isConnectedToInternet]) {
		[delegateSeat setWaitingMessage:@"正在提交座位订单"];
		[delegateSeat displayActivityView];
		
		NSString* url = [NSString stringWithFormat:@"%@", @"/MTBM/httppost"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		
		[dict setValue:@"order" forKey:@"METHOD"];
		
        NSMutableString *seatStr = [NSMutableString string];
        for (YXTSeatInfo *seatInfo in pickList) {
            [seatStr appendFormat:@"%@:%@|", seatInfo.rowId, seatInfo.columnId];
        }
        
        [dict setValue:seatStr forKey:@"SEATLIST"];
		[dict setValue:showSeqNo forKey:@"SHOWSEQNO"];
		[dict setValue:[[YXTSettings instance] getSetting:@"mobile-number"] forKey:@"USERPHONE"];
		[dict setValue:@"a6126169c99301f105e742b57df63fb9" forKey:@"SIGN"];
		
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
		self.orderInfo = [[[YXTOrderInfo alloc] init] autorelease];
        orderInfo.subscriptId = [bodyDict objectForKey:@"SUBSCRIPTID"];
        orderInfo.productNo = [bodyDict objectForKey:@"PRODUCTNO"];
        orderInfo.partnerId = [bodyDict objectForKey:@"PARTNERID"];
        orderInfo.partnerName = [bodyDict objectForKey:@"PARTNERNAME"];
        orderInfo.partnerOrderId = [bodyDict objectForKey:@"PARTNERORDERID"];
        orderInfo.orderId = [bodyDict objectForKey:@"ORDERID"];
        orderInfo.txnAmount = [bodyDict objectForKey:@"TXNAMOUNT"];
        orderInfo.rating = [bodyDict objectForKey:@"RATING"];
        orderInfo.goodsName = [bodyDict objectForKey:@"GOODSNAME"];
        orderInfo.goodsCount = [bodyDict objectForKey:@"GOODSCOUNT"];
        orderInfo.sig = [bodyDict objectForKey:@"SIG"];
        
        [delegateSeat performSelectorOnMainThread:@selector(fetchFilmOrderSucceed:) withObject:orderInfo waitUntilDone:NO];
        [delegateSeat performSelectorOnMainThread:@selector(removeActivityView) withObject:nil waitUntilDone:NO];
	}
    else{
		[delegateSeat performSelectorOnMainThread:@selector(displayServerErrorActivityView) withObject:nil waitUntilDone:NO];
	}
}

@end


@implementation YXTOrderInfo

@synthesize subscriptId, productNo, partnerId, partnerName, partnerOrderId;
@synthesize orderId, txnAmount, rating, goodsName, goodsCount, sig;

-(NSString *)infoDescription{
	return @"";
}

-(void)dealloc{
    [subscriptId release];
    [productNo release];
    [partnerId release];
    [partnerName release];
    [partnerOrderId release];
    
    [orderId release];
    [txnAmount release];
    [rating release];
    [goodsName release];
    [goodsCount release];
    [sig release];
    
    [super release];
}

@end
