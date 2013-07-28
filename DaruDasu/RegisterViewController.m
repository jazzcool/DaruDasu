//
//  RegisterViewController.m
//  DaruDasu
//
//  Created by shahid on 7/9/13.
//
//

#import "RegisterViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "DetectNetworkConnection.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Action Method

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)onClickRegister:(id)sender
{
    
    if ([DetectNetworkConnection isNetworkConnectionActive] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet connection is not available, please connect to internet and try again."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
        return;
        
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[NSNumber numberWithInteger:2147483647] forKey:@"prpCountryId"];
	[dic setObject:@"nadimUmar" forKey:@"prpDisplayName"];
	[dic setObject:@"nadim@gmail.com" forKey:@"prpEmailId"];
	[dic setObject:@"nadim" forKey:@"prpFirstName"];
	[dic setObject:@"male" forKey:@"prpGender"];
	[dic setObject:[NSNumber numberWithBool:true] forKey:@"prpIsActive"];
	[dic setObject:@"umar" forKey:@"prpLastName"];
	[dic setObject:@"123456" forKey:@"prpPassword"];
	[dic setObject:[NSNumber numberWithInteger:2147483647] forKey:@"prpRole"];
	[dic setObject:[NSNumber numberWithInteger:2147483647] forKey:@"prpUserId"];
	[dic setObject:@"nadim" forKey:@"prpUserName"];
    NSString *json = [dic JSONRepresentation];
    
    NSURL *url = [NSURL URLWithString:@"http://darudasu.com/DaruServices/RegisterNewUser"];
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
  //  jsonrequest,json
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/jsonrequest"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];

}

#pragma matrk- TextField Delegate
 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_txtCountry resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtUserName resignFirstResponder];
}

- (void)resineKeyBoard:(id)sender
{
    [_txtCountry resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtUserName resignFirstResponder];
}

- (void)selectTimePicker
{
    //[barDoneButton setTintColor:[UIColor blackColor]];//feb-12
    _actionSheet = [[UIActionSheet alloc]init];
    _actionSheet.delegate = (id)self;
    [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame         = CGRectMake(0, 44,320, 216+20);
    //CGRect pickerFrame         = CGRectMake(0, 44,320, 216+20);
    _datePicker                = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    
    [_datePicker setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [_actionSheet addSubview:_datePicker];
    
        
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(getSelectedTime)];
    
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.frame    = CGRectMake(85, 15, 150, 14);
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    lblTitle.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    lblTitle.alpha = 0.7;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor       = [UIColor whiteColor];
    
        lblTitle.text = @"Choose To Time";
    
    UIBarButtonItem *flexibleButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *barButtonCancle = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(canclePickerButtonClicked)];
    
    [barButtonDone setTintColor:[UIColor blueColor]];
    NSArray *barButtons = [NSArray arrayWithObjects:barButtonCancle,flexibleButton,barButtonDone, nil];
    
    [toolbar setItems:barButtons];
    [_actionSheet addSubview:toolbar];
    [toolbar addSubview:lblTitle];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [_actionSheet showInView:self.view];
    
    CGFloat height = 0.0;
    
    if(IS_IPHONE_5) {
        //height = self.view.frame.size.height+40;
        height = self.view.frame.size.height;
    } else {
        
        //height = self.view.frame.size.height+130;
        height = self.view.frame.size.height+80;
    }
    
    [_actionSheet setBounds:CGRectMake(0, 0, 320, height)];
    [UIView commitAnimations];
}


@end
