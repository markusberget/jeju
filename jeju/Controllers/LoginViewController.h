//
//  LoginViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-03.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OctokitModel.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

-(IBAction)login;

@end
