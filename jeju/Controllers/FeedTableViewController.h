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

@interface FeedTableViewController : UITableViewController <NSCopying>

@property (strong, nonatomic) OCTRepository * repo;
@property (weak, nonatomic) IBOutlet UIView *pollingView;


@end
