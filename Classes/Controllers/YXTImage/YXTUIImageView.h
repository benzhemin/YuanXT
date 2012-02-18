//
//  YXTUIImageView.h
//  YuanXT
//
//  Created by zhe zhang on 12-2-18.
//  Copyright 2012 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXTUIImageView : UIImageView {
	UIActivityIndicatorView *spiner;
}

-(void)addAnimateLoadingImage;
-(void)startAnimateLoadingImage;
-(void)stopAnimateLoadingImage;

@property (nonatomic, retain) UIActivityIndicatorView *spiner;

@end
