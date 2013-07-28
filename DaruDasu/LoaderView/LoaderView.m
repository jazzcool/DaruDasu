//
//  HUD.m
//  SmartLayover
//
//  Created by nazakat on 07/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "LoaderView.h"
#import "UILabelExtended.h"

@implementation LoaderView
@synthesize indicator   = _indicator;
@synthesize messageLabel=_messageLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
        
        UIView *mainView = [subviewArray objectAtIndex:0];
        [_indicator stopAnimating];
        [self addSubview:mainView];
        mainView.frame = self.frame;
        self.alpha = 1.0;
        
    }
    return self;
}



- (void)setLoaderTitle:(NSString*)loaderTitle {
    
    _messageLabel.text = loaderTitle;
    [_messageLabel setHeightOfLabel];
    
    CGRect frame = _indicator.frame;
    frame.origin.y = self.frame.size.height/2-10;
    _indicator.frame = frame;
    
     frame = _messageLabel.frame;
    frame.origin.y = _indicator.frame.origin.y+ _indicator.frame.size.height+10;
    _messageLabel.frame = frame;
    
    

}
- (void)setLoaderTitleForDeal:(NSString*)loaderTitle {
    
    _messageLabel.text = loaderTitle;
    [_messageLabel setHeightOfLabel];
    
    CGRect frame = _indicator.frame;
    frame.origin.y = self.frame.size.height/2-70;
    _indicator.frame = frame;
    
    frame = _messageLabel.frame;
    frame.origin.y = _indicator.frame.origin.y+ _indicator.frame.size.height+10;
    _messageLabel.frame = frame;
    
    
    
}


- (void)showLoader {
    
    [self bringSubviewToFront:_indicator];
    [_indicator startAnimating];
}

- (void)hideLoader {
    
    [_indicator stopAnimating];
}

@end
