//
//  RegisterViewController.h
//  DaruDasu
//
//  Created by shahid on 7/9/13.
//
//

#import <UIKit/UIKit.h>

@class LoaderView;


@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *_txtPassword;
    __weak IBOutlet UITextField *_txtUserName;
    __weak IBOutlet UITextField *_txtEmail;
    __weak IBOutlet UITextField *_txtCountry;
    
    NSString    *_strGender;
    UIActionSheet *_actionSheet;
    UIDatePicker *_datePicker;
    
    LoaderView *_loaderView;
}
- (IBAction)onClickRegister:(id)sender;
- (IBAction)resineKeyBoard:(id)sender;
@end
