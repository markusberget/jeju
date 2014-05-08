//
//  RepoDetailTableViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-07.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "RepoDetailTableViewController.h"
#import "PlanningPokerViewController.h"
#import "CommitPoller.h"

@interface RepoDetailTableViewController ()
@property (strong, nonatomic) NSMutableArray * watchedFiles;
@end

@implementation RepoDetailTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setRepo:(OCTRepository *) newRepo
{
    if (_repo != newRepo) {
        _repo = newRepo;
        self.watchedFiles = [[NSMutableArray alloc] init];
        
        
        
        [[CommitPoller instance] startPollingRepo:_repo];
        [[CommitPoller instance] addObserver:^(NSArray * commits, int count) {
            NSMutableArray * toNotify = [[NSMutableArray alloc] init];
            if (count) {
                
                for (int i = 0; i < count; ++i) {
                    OCTGitCommit * commit = [commits objectAtIndex:i];

                    [[CommitPoller instance] getDetailsForCommitAtIndex:i withContinuation:^(OCTGitCommit * cmt) {
                        for (NSString * file in cmt.files) {
                            if ([self.watchedFiles containsObject:file]) {
                                [toNotify addObject:file];
                            }
                        }
                        
                        
                        if (i == count - 1) {
                            NSMutableString * body = [[NSMutableString alloc] init];
                            for(NSString * file in toNotify) {
                                [body appendFormat:@"%@, ", file];
                            }
                            [self displayAlert:@"Your files were changed!" :[body substringToIndex:body.length - 1]];
                        }
                    }];
                }
            }
        }];
        
        // Update the view.
        [self configureView];
    }
}

-(void) startMasterNotificationPoller
{
    CommitPoller * poller = [[CommitPoller alloc] initWithBranch:@"master"];

    [poller addObserver:^(NSArray * commits, int count) {

    }];
    
    [poller startPollingRepo:self.repo];
}

-(void) displayAlert:(NSString *) title  :(NSString *) body {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = body;
    localNotification.alertAction = title;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];

}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.repo) {
        self.navigationItem.title = self.repo.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.items = [[NSArray alloc] initWithObjects:@"Feed", @"Conversations", @"Planning Poker", @"Notes", nil];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"%ld", (long)indexPath.row);
 
    NSString *identifier = [self.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = identifier;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showFeed"] || [[segue identifier] isEqualToString:@"showConversations"]) {
        [[segue destinationViewController] setRepo:self.repo];
    }
    else if ([[segue identifier] isEqualToString:@"showPlanningPoker"]) {
        if ([segue.destinationViewController isKindOfClass:[PlanningPokerViewController class]]) {
            PlanningPokerViewController *ppvc = (PlanningPokerViewController *)segue.destinationViewController;
            ppvc.title = @"Planning Poker";
        }
    }
    else if ([[segue identifier] isEqualToString:@"showNotes"]) {
        [[segue destinationViewController] setManagedObjectContext: self.managedObjectContext];
    }
}


@end
