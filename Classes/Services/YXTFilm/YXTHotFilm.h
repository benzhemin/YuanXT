//
//  YXTHotFilm.h
//  YuanXT
//
//  Created by benzhemin on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFXPRequest.h"


@interface YXTHotFilm : NSObject<OFXPResponseJSON> {
	NSMutableArray *filmList;
}

@property (nonatomic, retain) NSMutableArray *filmList;

@end


@interface YXTFilmInfo : NSObject{
	NSString *filmId;
	NSString *filmName;
	NSString *duration;
	NSString *director;
	NSString *mainPerformer;
	NSString *webPoster;
	NSString *webPoster2;
	NSString *filmClass;
	NSString *area;
	NSString *description;
	NSString *trailer;
	NSString *attention;
	NSString *showCount;
}

@property (nonatomic, copy) NSString *filmId;
@property (nonatomic, copy) NSString *filmName;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *mainPerformer;
@property (nonatomic, copy) NSString *webPoster;
@property (nonatomic, copy) NSString *webPoster2;
@property (nonatomic, copy) NSString *filmClass;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *trailer;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *showCount;

@end


















