//
//  MasterViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-01.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//
// Dosé rules!  

#import "MasterViewController.h"

#import "RepoDetailTableViewController.h"
#import "OctokitModel.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"user"] != nil && [defaults objectForKey:@"token"] != nil) {
        [self fetchData];
    }
    
    
    
    //Setting username for profile button
    self.navigationItem.rightBarButtonItem.title = self.octokitModel.userName ? self.octokitModel.userName : NSLocalizedString(@"Profile", nil);
}

- (void)fetchData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                  andUserName:[defaults objectForKey:@"user"]];
    // we get the repositories
    [[self.octokitModel getRepositories] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                            message:@"Something went wrong."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            [self presentViewController:self.loginViewController animated:YES completion:NULL];

        } else {
            self.repos = task.result;
            [self.tableView reloadData];
        }
        
        return nil;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    if ([defaults objectForKey:@"user"] == nil && [defaults objectForKey:@"token"] == nil) {
        [self presentViewController:self.loginViewController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OCTRepository *repo = [self.repos objectAtIndex:indexPath.row];
        [[segue destinationViewController] setRepo:repo];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    OCTRepository *repo = [self.repos objectAtIndex:indexPath.row];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.isPrivate ? NSLocalizedString(@"Private", nil) : NSLocalizedString(@"Public", nil);
}

@end
