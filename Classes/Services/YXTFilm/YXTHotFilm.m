//
//  YXTHotFilm.m
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTHotFilm.h"


@implementation YXTHotFilm

@synthesize filmList;

-(void)dealloc{
	[filmList release];
	[super dealloc];
}



- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode{
	
}

@end

@implementation YXTFilmInfo

@synthesize filmId, filmName, duration, director, mainPerformer;
@synthesize webPoster, webPoster2, filmClass, area;
@synthesize description, trailer, attention, showCount;

-(void)dealloc{
	[filmId release];
	[filmName release];
	[duration release];
	[director release];
	[mainPerformer release];
	[webPoster release];
	[webPoster2 release];
	[filmClass release];
	[area release];
	[description release];
	[trailer release];
	[attention release];
	[showCount release];
	
	[super dealloc];
}

@end

