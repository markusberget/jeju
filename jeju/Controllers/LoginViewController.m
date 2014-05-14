//
//  LoginViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-03.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "LoginViewController.h"
#import "Octokit.h"
#import "CommitPoller.h"

@interface LoginViewController ()



@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    OCTClientAuthorizationScopes scopes = OCTClientAuthorizationScopesRepository | OCTClientAuthorizationScopesUser;
    
    
    
    [[OctokitModel authenticateWithScopes:scopes] continueWithBlock:^id(BFTask *task) {
        OctokitModel * model = task.result;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.userName forKey:@"user"];
        [defaults setObject:model.token forKey:@"token"];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        return nil;
    }];
    
    /*[[OCTClient signInToServerUsingWebBrowser:OCTServer.dotComServer scopes:OCTClientAuthorizationScopesRepository | OCTClientAuthorizationScopesUser ] subscribeNext:^(OCTClient *authenticatedClient) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[authenticatedClient user].rawLogin forKey:@"user"];
        [defaults setObject:[authenticatedClient token] forKey:@"token"];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        NSLog(@"Success!");
    } error:^(NSError *error) {
        
    }];*/
}

-(void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([self isLoggedIn]) {
        [defaults setObject:nil forKey:@"user"];
        [defaults setObject:nil forKey:@"token"];
    }
    [self styleButtons];
    [[CommitPoller instance] stopPolling];
    
}

-(BOOL)isLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"user"] != nil && [defaults objectForKey:@"token"] != nil;

}

-(void)styleButtons
{
    if ([self isLoggedIn]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loginButton.hidden = YES;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            self.logoutButton.hidden = NO;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loginButton.hidden = NO;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            self.logoutButton.hidden = YES;
        });

    }
    [[self.loginButton layer] setBorderWidth:0.25f];
    [[self.loginButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.loginButton layer] setCornerRadius:6];
    
    [[self.logoutButton layer] setBorderWidth:0.25f];
    [[self.logoutButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.logoutButton layer] setCornerRadius:6];
    
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
