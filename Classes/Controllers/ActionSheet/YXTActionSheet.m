//
//  VlionActionSheet.m
//  TestActionSheet
//
//  Created by benzhemin on 10-12-8.
//  Copyright 2010 ideal. All rights reserved.
//

#import "YXTActionSheet.h"


@implementation YXTActionSheet
@synthesize view;
@synthesize toolBar;

-(void)dealloc{
	[toolBar release];
	[view release];
	[super dealloc];
}

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title delegateClass:(id)delegate confirm:(SEL)selectDone cancel:(SEL)selectCancel{
	//height = 84, 134, 184, 234, 284, 334, 384, 434, 484
	self = [super init];
    if (self) 
	{
		[self setTitle:@"\n\n\n"];
		
		int theight = height - 40;
		int btnnum = theight/50;
		for(int i=0; i<btnnum; i++)
		{
			[self addButtonWithTitle:@" "];
		}
		 
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		toolBar.barStyle = UIBarStyleBlackTranslucent;
		
		//UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title style: UIBarButtonItemStylePlain target: nil action: nil];
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStyleDone target: delegate action: selectDone];
		UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: delegate action: selectCancel];
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, /*titleButton,fixedButton,*/ rightButton, nil];
		[toolBar setItems: array];	
		//[toolBar setOpaque:YES];
		
		//[titleButton release];
		[rightButton release];
		[leftButton  release];
		[fixedButton release];
		[array       release];
		
		[self addSubview:toolBar];
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, height-44)];
		view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		[self addSubview:view];
    }
    return self;
}
-(void)done
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)docancel
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
