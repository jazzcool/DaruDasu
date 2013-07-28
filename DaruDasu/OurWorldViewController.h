//
//  OurWorldViewController.h
//  DaruDasu
//
//  Created by shahid on 7/15/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OurWorldViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIView *_backGroundView;
    __weak IBOutlet UIButton *btnCountry;
    __weak IBOutlet UIButton *btnChameleon;
    __weak IBOutlet UIButton *btnAppPals;
    __weak IBOutlet UINavigationBar *_navigationBar;
}
- (IBAction)onClickChemeloneEye:(id)sender;

@end
