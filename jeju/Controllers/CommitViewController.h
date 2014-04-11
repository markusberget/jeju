//
//  CommitViewController.h
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Octokit.h"
#import "FileTableView.h"

@interface CommitViewController : UIViewController

@property (strong, nonatomic) OCTGitCommit* commit;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *added;
@property (weak, nonatomic) IBOutlet UILabel *changed;
@property (weak, nonatomic) IBOutlet UILabel *deleted;
@property (weak, nonatomic) IBOutlet FileTableView *fileTable;

@end
