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
    
//    OurWorldViewController *_OurWorldViewController = [[OurWorldViewController alloc]initWithNibName:@"OurWorldViewController" bundle:nil];
//    [self presentViewController:_OurWorldViewController animated:YES completion:nil];
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self presentViewController:registerViewController animated:YES completion:nil];
}

- (IBAction)onClickSignInButton:(id)sender {
    
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

@end
