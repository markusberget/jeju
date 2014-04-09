//
//  ConversationTableViewController.m
//  jeju
//
//  Created by Joel Lundell on 4/8/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "ConversationTableViewController.h"

@interface ConversationTableViewController ()

@end

@implementation ConversationTableViewController

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
        [self fetchMessages];
    }
}
//Fetching issues from Github with message as label
- (void)fetchMessages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                andUserName:[defaults objectForKey:@"user"]];
    // we get the repositories
    [[self.octokitModel getConversations:self.repo] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                            message:@"Something went wrong."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for(OCTResponse *object in task.result) {
                [results addObject: [object parsedResult]];
            }
            self.conversations = results;
            [self.tableView reloadData];
        }
        return nil;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell" forIndexPath:indexPath];
    
    OCTIssue *issue = [self.conversations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = issue.title;
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"messageCell"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OCTIssue *conversation = [self.conversations objectAtIndex:indexPath.row];
        //[[segue destinationViewController] setConversation:conversation];
    }
    
}

@end
