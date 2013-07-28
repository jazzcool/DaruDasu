//
//  ChameleonViewController.m
//  DaruDasu
//
//  Created by shahid on 7/17/13.
//
//

#import "ChameleonViewController.h"


@interface ChameleonViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ChameleonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         _dataArray = [[NSMutableArray alloc]initWithObjects:@"Can.png", @"Chi.png", @"Fra.png", @"Ind.png", @"Tur.png", @"UK.png", @"Uni.png", nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.text = @"All AppPals Photos";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [lblTitle sizeToFit];
    _navigationBar.topItem.titleView = lblTitle;
    lblTitle = nil;
    //configure carousel
   self.carousel.type = iCarouselTypeLinear;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickPostImage:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Effects", @"Post Photo", @"Preview", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
    sheet = nil;
}


#pragma mark- carlosel Delegate Datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return _dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 290.0f, 220.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:[_dataArray objectAtIndex:index]];
        view.contentMode = UIViewContentModeCenter;
        [view  setContentMode:UIViewContentModeScaleAspectFill];
    
    }
    else
    {
        //get a reference to the label in the recycled view
        ((UIImageView *)view).image = [UIImage imageNamed:[_dataArray objectAtIndex:index]];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 3;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)aCarousel
{
    NSLog(@"carouselDidEndScrollingAnimation == %d",aCarousel.currentItemIndex);
}


#pragma mark- ActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d====",buttonIndex);
    switch (buttonIndex) {
            
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]== NO) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
                return;
            }
            
            if (_imagePickerController == nil) {
                _imagePickerController = [[UIImagePickerController alloc]init];
                _imagePickerController.delegate = self;
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [ self presentViewController:_imagePickerController animated:YES completion:NULL];
            
            break;
        }
        case 1:
        {
            
            break;
        }
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Post to AppPals", @"Post to MyCircle", @"Post to both", nil];
            [alert show];
            alert = nil;
            break;
        }
        case 3:
        {
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark- Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
