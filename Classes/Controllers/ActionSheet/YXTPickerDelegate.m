//
//  GeneralSinglePickerDelegate.m
//  yuanxiantong
//
//  Created by zhe zhang on 11-4-3.
//  Copyright 2011 Ideal Information Industry. All rights reserved.
//

#import "YXTPickerDelegate.h"


@implementation YXTPickerDelegate

@synthesize pickerDataArray;

-(void)dealloc{
	[pickerDataArray release];
	[super dealloc];
}


#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerDataArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	return 300.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0f;
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerDataArray objectAtIndex:row];
}

@end
