//
//  DetailViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-01.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Octokit.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) OCTRepository *repo;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
