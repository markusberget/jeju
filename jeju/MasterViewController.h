//
//  MasterViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-01.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSArray *repos;

@property (strong, nonatomic) OctokitModel *octokitModel;

@property (strong, nonatomic) LoginViewController *loginViewController;

@end
