//
//  YXTCinimaService.m
//  YuanXT
//
//  Created by zhe zhang on 12-2-20.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import "YXTCinemaService.h"


@implementation YXTCinemaService

-(void)startToFetchCinimaList{
	
}

@end

@implementation YXTCinemaInfo

@synthesize cinimaId, cinimaName, address, hallCount;
@synthesize cityId, cityName, cinemaBusLine, description;
@synthesize cinemaPhoto, districtId, distName, couponOrder;
@synthesize onlineOrder, partnerId, partnerName, partnerPicId;

-(NSString *)infoDescription{
	return @"";
}

-(void)dealloc{
	[cinimaId release];
	[cinimaName release];
	[address release];
	[hallCount release];
	[cityId release];
	[cityName release];
	[cinemaBusLine release];
	[description release];
	[cinemaPhoto release];
	[districtId release];
	[distName release];
	[couponOrder release];
	[onlineOrder release];
	[partnerId release];
	[partnerName release];
	[partnerPicId release];
	[super dealloc];
}

@end
