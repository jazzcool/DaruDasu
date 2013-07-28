//
//  RegisterViewController.h
//  DaruDasu
//
//  Created by shahid on 7/9/13.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    
    __weak IBOutlet UITextField *_txtPassword;
    __weak IBOutlet UITextField *_txtUserName;
    __weak IBOutlet UITextField *_txtEmail;
    __weak IBOutlet UITextField *_txtCountry;
    
    NSString    *_strGender;
}
- (IBAction)onClickRegister:(id)sender;

@end
