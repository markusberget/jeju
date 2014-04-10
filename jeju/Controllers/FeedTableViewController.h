//
//  FeedTableViewController.h
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OctokitModel.h"
#import "Octokit.h"

@interface FeedTableViewController : UITableViewController

@property (strong, nonatomic) OCTRepository * repo;
@property (strong, nonatomic) NSMutableArray * commits;
@property (strong, nonatomic) NSTimer * pollTimer;
@property (strong, nonatomic) NSString * lastEtag;
@property (strong, nonatomic) OctokitModel * model;
@property (weak, nonatomic) IBOutlet UIView *pollingView;
- (IBAction)onDismissTouch:(id)sender;

@end
