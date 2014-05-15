//
//  PivotalTrackerLoginViewController.m
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PivotalTrackerLoginViewController.h"
#import "PivotalTrackerRepository.h"
#import "PivotalTrackerUser.h"

@interface PivotalTrackerLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) PivotalTrackerRepository *pivotalTrackerRepository;

@end

@implementation PivotalTrackerLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (PivotalTrackerRepository *)pivotalTrackerRepository
{
    if (_pivotalTrackerRepository == nil) {
        _pivotalTrackerRepository = [[PivotalTrackerRepository alloc] init];
    }
    return _pivotalTrackerRepository;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    PivotalTrackerUser *user = [[self pivotalTrackerRepository] getUserFrom:self.userNameTextField.text And:self.passwordTextField.text];
    NSLog(@"%@", user.token);
    
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:@"pttoken"];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
