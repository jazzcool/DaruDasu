//
//  ChameleonViewController.h
//  DaruDasu
//
//  Created by shahid on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ChameleonViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UINavigationBar *_navigationBar;
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
- (IBAction)onClickPostImage:(id)sender;

@end
