//
//  HUD.h
//  SmartLayover
//
//  Created by Nazkat on 07/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoaderView : UIView {
    
    IBOutlet  UILabel  *_messageLabel;
}

@property (nonatomic, retain)   UILabel  *messageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)showLoader;
- (void)hideLoader;
- (void)setLoaderTitle:(NSString*)loaderTitle;
- (void)setLoaderTitleForDeal:(NSString*)loaderTitle;
@end
