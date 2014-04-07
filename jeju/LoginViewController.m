//
//  LoginViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-03.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "LoginViewController.h"
#import "Octokit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view.
    
    [self styleButtons];
}

-(void)login
{
    [[OCTClient signInToServerUsingWebBrowser:OCTServer.dotComServer scopes:OCTClientAuthorizationScopesRepository | OCTClientAuthorizationScopesUser ] subscribeNext:^(OCTClient *authenticatedClient) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[authenticatedClient user].rawLogin forKey:@"user"];
            [defaults setObject:[authenticatedClient token] forKey:@"token"];
        }];
        NSLog(@"Success!");
    } error:^(NSError *error) {
        
    }];
}

-(void)styleButtons
{
    [[self.loginButton layer] setBorderWidth:0.25f];
    [[self.loginButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.loginButton layer] setCornerRadius:6];
    
    [[self.signUpButton layer] setBorderWidth:0.25f];
    [[self.signUpButton layer] setCornerRadius:6];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
