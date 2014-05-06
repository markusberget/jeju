//
//  ProjectsTableViewController.h
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PivotalTrackerLoginViewController.h"

@interface ProjectsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *projects;

@property (strong, nonatomic) PivotalTrackerLoginViewController *pivotalTrackerLoginViewController;



@end
