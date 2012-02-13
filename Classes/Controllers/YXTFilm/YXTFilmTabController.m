//
//  YXTFileTabController.m
//  YuanXT
//
//  Created by benzhemin on 12-2-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YXTFilmTabController.h"
#import "YXTLocation.h"
#import "YXTActionSheet.h"
#import "YXTPickerDelegate.h"

enum REQUEST_TYPE {
	city_request = 0
};

@implementation YXTFilmTabController

@synthesize location;

@synthesize cityBtn, citySheet, cityPicker, cityPickerDelegate;

- (void)dealloc {
	[location release];
	
	[cityBtn release];
	[citySheet release];
	[cityPicker release];
	[cityPickerDelegate release];
    [super dealloc];
}

-(id)init{
	if (self = [super init]) {
		
		
	}
	return self;
}

-(void)viewDidLoad{
	
	self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cityBtn setBackgroundColor:[UIColor clearColor]];
	UIImage *cityImg = [UIImage imageNamed:@"dropselect.png"];
	[cityBtn setFrame:CGRectMake(0, 0, cityImg.size.width+15.0, cityImg.size.height+8.0)];
	[cityBtn setBackgroundImage:cityImg forState:UIControlStateNormal];
	[cityBtn addTarget:self action:@selector(pressCitySwitchBtn) forControlEvents:UIControlEventTouchUpInside];
	[[cityBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2.0, -11.0, 0.0, 0.0)];
	[cityBtn setTitle:@"上海市" forState:UIControlStateNormal];
	
	
	UIBarButtonItem *cityBarItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];	
	self.navigationItem.rightBarButtonItem = cityBarItem;
	//viewController.navigationItem.backBarButtonItem = backBar;
	
	[cityBarItem release];
	
	[super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
	
}


-(void)pressCitySwitchBtn{
	self.location = [[YXTLocation alloc] init];
	[location setDelegateFilm:self];
	[location startToFetchCityList];
}

-(void)popUpCityChangePicker:(NSMutableArray *)array{
	self.citySheet = [[YXTActionSheet alloc] initWithHeight:234.0f WithSheetTitle:@"" delegateClass:self 
											   confirm:@selector(selectCityConfirm:) cancel:@selector(selectCityCancel:)];
	
	self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 225)];
	
	cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	cityPicker.showsSelectionIndicator = YES;	// note this is default to NO
	
	self.cityPickerDelegate = [[YXTPickerDelegate alloc] init];
	cityPickerDelegate.pickerDataArray = array;
	cityPicker.dataSource = cityPickerDelegate;
	cityPicker.delegate = cityPickerDelegate;
	
	[citySheet.view addSubview:cityPicker];
	
	
	[citySheet showInView:[self.view superview]];
}

-(IBAction)selectCityConfirm:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
	NSInteger row = [cityPicker selectedRowInComponent:0];
    NSString *selected = [[cityPickerDelegate pickerDataArray] objectAtIndex:row];
	[cityBtn setTitle:selected forState:UIControlStateNormal];
}

-(IBAction)selectCityCancel:(id)sender{
	[citySheet dismissWithClickedButtonIndex:0 animated:YES];
}



-(NSString *)getNavTitle{ return @"正在热映";}
-(NSString *)getTabTitle{ return @"影片"; }
-(NSString *)getTabImage{ return @"icon_yingpian.png";}
-(int) getTabTag{ return 1;}

@end
