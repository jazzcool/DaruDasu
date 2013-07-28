//
//  ViewController.h
//  DaruDasu
//
//  Created by shahid on 7/7/13.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    
    __weak IBOutlet UITextField *_txtPassword;
    __weak IBOutlet UITextField *_txtUserName;
}

- (IBAction)endFirstResponder:(id)sender;
- (IBAction)onClickRegisterButton:(id)sender;
- (IBAction)onClickSignInButton:(id)sender;

@end
