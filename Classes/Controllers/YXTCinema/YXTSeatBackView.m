//
//  YXTSeatBackView.m
//  YuanXT
//
//  Created by zhe zhang on 2012－3－7.
//  Copyright 2011 Ideal Information Industry. All rights reserved.
//

#import "YXTSeatBackView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YXTSeatBackView

@synthesize delegateSeat;

-(id)initWithFrame:(CGRect)rect{
	if (self=[super initWithFrame:rect]) {
		//initialscale = 1;
		//origionRect = rect;
        //[self addGestureRecognizersView:self];
        [self setUserInteractionEnabled:YES];
	}
	return self;
}

- (void)addGestureRecognizersView:(UIView *)uiview{
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleView:)];
    [uiview addGestureRecognizer:pinchGesture];
    [pinchGesture release];
}

#define STRETCHTONOMALSIZEDURATION 0.3

- (void)scaleView:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		
		initialscale = initialscale*[gestureRecognizer scale];
        
        if (initialscale < 1.5 && initialscale > 0.9) {
    
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
            
            
        }else{
            if (initialscale > 1.5) {
                
                initialscale = 1.5;
            }
            if (initialscale < 0.9) {
                
                initialscale = 0.9;
            }
        }
		
		NSLog(@"current gesture scale:%f, extend scale:%f",[gestureRecognizer scale], initialscale);
        NSLog(@"view bounds:%f, %f", [gestureRecognizer view].bounds.size.width, [gestureRecognizer view].bounds.size.height);
		
		
    }
    
	[gestureRecognizer setScale:1];
    
    /*
    if (initialscale > 1.5 || initialscale < 0.9) {
        if (initialscale > 1.5) {
            initialscale = 1.5;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:STRETCHTONOMALSIZEDURATION];
            
            self.transform = CGAffineTransformScale([self transform], 1.0/initialscale, 1.0/initialscale);
            
            [UIView commitAnimations];
            
            
        }
		if (initialscale < 0.7) {
            initialscale = 0.7;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:STRETCHTONOMALSIZEDURATION];
            
            self.transform = CGAffineTransformScale([self transform], 1.0/initialscale, 1.0/initialscale);
            
            [UIView commitAnimations];
        }
	}
    */
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
    if (gestureRecognizer.view != self)
        return YES;
    
    return NO;
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *uiview = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:uiview];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:uiview.superview];
        NSLog(@"locationInView:x=%f, y=%f", locationInView.x, locationInView.y);
		NSLog(@"locationInSuperview:x=%f, y=%f", locationInSuperview.x, locationInSuperview.y);
        //uiview.layer.anchorPoint = CGPointMake(locationInView.x / uiview.bounds.size.width, locationInView.y / uiview.bounds.size.height);
        //uiview.center = locationInSuperview;
    }
}


-(IBAction)stretchToInitial:(id)sender{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:STRETCHTONOMALSIZEDURATION];
	
	self.transform = CGAffineTransformScale([self transform], 1.0/initialscale, 1.0/initialscale);
	
	[UIView commitAnimations];
	
	initialscale = 1.0;
}

@end
