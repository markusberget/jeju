//
//  FeedTableViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-07.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OctoKit.h"

@interface BranchTableViewController : UITableViewController

@property (strong, nonatomic) OCTRepository *repo;

@property (strong, nonatomic) NSArray * branches;

@end
