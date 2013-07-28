//
//  ViewController.m
//  DaruDasu
//
//  Created by shahid on 7/7/13.
//
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "OurWorldViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "LoaderView.h"
#import "DetectNetworkConnection.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Action Method



- (void)endFirstResponder:(id)sender
{
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
}

- (IBAction)onClickRegisterButton:(id)sender {
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self presentViewController:registerViewController animated:YES completion:nil];
}

#pragma mark- Action Method

- (IBAction)onClickSignInButton:(id)sender {
    
    if ([DetectNetworkConnection isNetworkConnectionActive] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Internet connection is not available, please connect to internet and try again."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
        return;
        
    }
    
    [_txtPassword resignFirstResponder];
    [_txtUserName resignFirstResponder];
    
    if (!_txtUserName.text.length || ![(NSString*)(_txtUserName.text) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the user name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    
    if (!_txtPassword.text.length || ![(NSString*)(_txtPassword.text) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return;
    }
    
    if(IS_IPHONE_5) {
        _loaderView = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_IPHONE_5)];
    } else {
        _loaderView = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_IPHONE_4)];
    }
   
    [self.view.window addSubview:_loaderView];
    [_loaderView showLoader];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_txtPassword.text forKey:@"prpPassword"];
    [dic setObject:_txtUserName.text forKey:@"prpUserName"];
    
    NSString *json = [dic JSONRepresentation];
    
    NSURL *url = [NSURL URLWithString:@"http://darudasu.com/DaruServices/GetLogindetails"];
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        
        [_loaderView.indicator stopAnimating];
        [_loaderView removeFromSuperview];
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        if (responseString.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"User Name or password wrong?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            return ;
        }
        
        OurWorldViewController *_OurWorldViewController = [[OurWorldViewController alloc]initWithNibName:@"OurWorldViewController" bundle:nil];
        [self presentViewController:_OurWorldViewController animated:YES completion:nil];
        
        
    }];
    [request setFailedBlock:^{
        
        [_loaderView.indicator stopAnimating];
        [_loaderView removeFromSuperview];
        NSError *error = [request error];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        alert = nil;

    }];
    [request startAsynchronous];
}

@end
