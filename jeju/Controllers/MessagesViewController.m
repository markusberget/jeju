//
//  MessagesTableViewController.m
//  jeju
//
//  Created by Markus Berget on 2014-04-09.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)setConversation:(OCTIssue *)newConversation andRepo:(OCTRepository *)newRepo
{
    if (_conversation != newConversation || _repo != newRepo) {
        _conversation = newConversation;
        _repo = newRepo;
        
        // Update the view.
        [self configureView];
    }
}


- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.conversation) {
        [self fetchMessages];
    }
}

- (void)fetchMessages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                andUserName:[defaults objectForKey:@"user"]];
    // we get the repositories
    [[self.octokitModel getMessages:self.repo forConversation:self.conversation] continueWithBlock:^id(BFTask *task) {
        
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
            self.messages = results;
            [self.tableView reloadData];
        }
        return nil;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Adding top border to writeMessageView
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.writeMessageView.frame.size.width, 0.5f);
    topBorder.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.3].CGColor;
    [self.writeMessageView.layer addSublayer:topBorder];
    
    
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
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    OCTIssueComment *message = [self.messages objectAtIndex:indexPath.row];
    
    // Configure the cell..
    
    cell.textLabel.text = message.body;
    cell.detailTextLabel.text = message.commenterLogin;
    
    return cell;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
