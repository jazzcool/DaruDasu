//
//  OurWorldViewController.m
//  DaruDasu
//
//  Created by shahid on 7/15/13.
//
//

#import "OurWorldViewController.h"
#import "OurWorldCustomCell.h"
#import "ChameleonViewController.h"

@interface OurWorldViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OurWorldViewController

@synthesize dataArray = _dataArray;

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
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.text = @"Our World";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    [lblTitle sizeToFit];
    _navigationBar.topItem.titleView = lblTitle;
    lblTitle = nil;
    
    _backGroundView.layer.cornerRadius = 5.0f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.layer.cornerRadius = 5.0f;
    
    //btnCountry.highlighted = YES;
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"Can.png", @"Chi.png", @"Fra.png", @"Ind.png", @"Tur.png", @"UK.png", @"Uni.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 121.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OurWorldCustomCell";
    OurWorldCustomCell *cell = (OurWorldCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *myCell = [[NSBundle mainBundle] loadNibNamed:@"OurWorldCustomCell" owner:self options:nil];
        for (id currentObject in myCell) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (OurWorldCustomCell*)currentObject;
                break;
            }
        }
    }
    
    cell.lblCountry.text = @"India";
    cell.imgFlag.image = [UIImage imageNamed:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark- Action Method

- (IBAction)onClickChemeloneEye:(id)sender {
    ChameleonViewController *objChaemelone = [[ChameleonViewController alloc]initWithNibName:@"ChameleonViewController" bundle:nil];
    [self presentViewController:objChaemelone animated:YES completion:nil];
}

@end
