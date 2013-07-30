//
//  UILabelExtended.m

//
//  Created by Tarun on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILabelExtended.h"


@implementation UILabelExtended
@synthesize selector,customDelegate,labelInfo,selectorForTouchBegin;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.selector)
        if([self.customDelegate respondsToSelector:self.selectorForTouchBegin]) {
            
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.customDelegate performSelector:self.selectorForTouchBegin withObject:self];
           // return;
        }
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.selector)
        if([self.customDelegate respondsToSelector:self.selector]) {
            
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.customDelegate performSelector:self.selector withObject:self];
            return;
        }
}

- (void)dealloc {
    
	self.customDelegate = nil;
    self.selector = NULL;
}

@end


@implementation UILabel(UILabelCategory)

- (void)setHeightOfLabel {
   
    UILabel* label = self;
	
    //get the height of label content
	CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 99999) lineBreakMode:UILineBreakModeWordWrap].height;
	
    //set the frame according to calculated height
    CGRect frame = label.frame;
    frame.size.height = ([label.text length] > 0) ? height : 0;
	label.frame = frame;
}


- (void)setWidthOfLabel {
    
	UILabel* label = self;
    
    //get the height of label content
	CGFloat width = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(99999, label.bounds.size.height) lineBreakMode:UILineBreakModeWordWrap].width;
    
    //set the frame according to calculated height
	CGRect frame = label.frame;
    frame.size.width = ([label.text length] > 0) ? width+5 : 0;
	label.frame = frame;
}

- (void)setHeightOfLabelWithMaxHeight:(float)maxHeight {
    
    UILabel* label = self;
    
	//get the height of label content
	CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, maxHeight) lineBreakMode:UILineBreakModeWordWrap].height;
	
    //set the frame according to calculated height
	CGRect frame = label.frame;
    frame.size.height = ([label.text length] > 0) ? 
        ((height > maxHeight) ? maxHeight : height) : 0;
	label.frame = frame;
}

- (void)setWidthOfLabelWithMaxWidth:(float)maxWidth  {
	
    UILabel* label = self;
    
	//get the height of label content
	CGFloat width = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(99999, label.bounds.size.height) lineBreakMode:UILineBreakModeWordWrap].width;
	
    //set the frame according to calculated height
	CGRect frame = label.frame;
    frame.size.width = ([label.text length] > 0) ? 
        ((width > maxWidth) ? maxWidth : width) : 0;
	label.frame = frame;
}

@end