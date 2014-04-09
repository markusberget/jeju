//
//  RepoDetailTableViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-07.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "RepoDetailTableViewController.h"
#import "PlanningPokerViewController.h"

@interface RepoDetailTableViewController ()

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
        
        // Update the view.
        [self configureView];
    }
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

    self.items = [[NSArray alloc] initWithObjects:@"Feed", @"Conversations", @"Planning Poker", nil];
    
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
    } else if ([[segue identifier] isEqualToString:@"showPlanningPoker"]) {
        if ([segue.destinationViewController isKindOfClass:[PlanningPokerViewController class]]) {
            PlanningPokerViewController *ppvc = (PlanningPokerViewController *)segue.destinationViewController;
            ppvc.title = @"Planning Poker";
        }
    }
}


@end