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

@end
