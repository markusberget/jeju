//
//  RepoDetailTableViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-07.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OctoKit.h"

@interface RepoDetailTableViewController : UITableViewController

@property (strong, nonatomic) OCTRepository *repo;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSArray *items;


@end
