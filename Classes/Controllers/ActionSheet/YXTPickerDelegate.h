//
//  GeneralSinglePickerDelegate.h
//  yuanxiantong
//
//  Created by zhe zhang on 11-4-3.
//  Copyright 2011 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXTPickerDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>{
	NSArray	*pickerDataArray;
}

@property (nonatomic, retain) NSArray *pickerDataArray;

@end
