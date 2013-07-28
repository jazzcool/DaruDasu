//
//  UILabelExtended.h
//  Elsevier
//
//  Created by Tarun on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 
 This custom class enhance the size of custom label.
 
*/

#import <Foundation/Foundation.h>


@interface UILabelExtended : UILabel {
    
   __unsafe_unretained id  customDelegate;
    SEL selector;
    id  labelInfo;
}

@property (nonatomic, strong) id  labelInfo;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) SEL selectorForTouchBegin;
@property (nonatomic, assign) id  customDelegate;

@end


@interface UILabel(UILabelCategory)

- (void)setHeightOfLabel;
- (void)setWidthOfLabel;
- (void)setHeightOfLabelWithMaxHeight:(float)maxHeight;
- (void)setWidthOfLabelWithMaxWidth:(float)maxWidth ;

@end