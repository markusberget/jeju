//
//  ConversationTableViewController.m
//  jeju
//
//  Created by Joel Lundell on 4/8/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "ConversationsTableViewCell.h"
#import "MessagesViewController.h"
#import "DateUtil.h"

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
        [self fetchConversations];
    }
}
//Fetching issues from Github with message as label
- (void)fetchConversations
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //initialize arrays for last message per conversation
    self.lastMessages = [[NSMutableArray alloc] init];
    self.lastMessagesUsers = [[NSMutableArray alloc] init];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                andUserName:[defaults objectForKey:@"user"]];
    // fetch the conversations
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
            
            //fetch the last message in each conversation
            for (int i = 0; i < self.conversations.count; i++) {
                OCTIssue *conversation = [self.conversations objectAtIndex:i];
                
                [[self.octokitModel getLastMessageForRepo:self.repo forConversation:conversation] continueWithBlock:^id(BFTask *task) {
                    
                    if (task.error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                                        message:@"Something went wrong."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [alert show];
                    } else {
                        
                        OCTIssueComment *lastComment = nil;
                        for(OCTResponse *object in task.result) {
                            OCTIssueComment *comment = [object parsedResult];
                            if (lastComment == nil) {
                                lastComment = comment;
                            }
                            if ([comment.updatedDate compare:lastComment.updatedDate] == NSOrderedDescending) {
                                lastComment = comment;
                            }
                        }

                        [self.lastMessages addObject:lastComment];
                        //if all last comments are fetched
                        if (self.lastMessages.count == self.conversations.count) {
                            
                            //fetch the image of the last commenter for each conversation
                            for (OCTIssueComment *comment in self.lastMessages) {
                                
                                [[self.octokitModel getUserFromLoginName:comment.commenterLogin] continueWithBlock:^id(BFTask *task) {
                                    
                                    if (task.error) {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                                                        message:@"Something went wrong."
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"Ok"
                                                                              otherButtonTitles:nil];
                                        [alert show];
                                    } else {
                                        
                                        OCTUser *user = [[task.result objectAtIndex:0] parsedResult];
                                        [self.lastMessagesUsers addObject:user];

                                        //if all users are fetched reload table view
                                        if (self.lastMessages.count == self.conversations.count) {
                                            [self.tableView reloadData];
                                        }
                                    }
                                    return nil;
                                }];
                            }
// MIght want to reload here if you want to load last comment of each conversation before the images has loaded                            [self.tableView reloadData];
                        }
                    }
                    return nil;
                }];
            }

        }
        return nil;
    }];
    
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConversationTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConversationTableViewCell"];
    
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
    ConversationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConversationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    OCTIssue *conversation = [self.conversations objectAtIndex:indexPath.row];

    
    cell.titleLabel.text = conversation.title;
    cell.bodyLabel.text = @"";
    cell.lastActivityLabel.text = @"";
    
    if (self.lastMessages.count > indexPath.row) {
        OCTIssueComment *lastMessage = [self.lastMessages objectAtIndex:indexPath.row];
        cell.bodyLabel.text = lastMessage.body;
        cell.lastActivityLabel.text = [DateUtil formatDate:lastMessage.updatedDate WithFormat:@"yyyy-MM-dd hh:mm"];
    }
    if (self.lastMessagesUsers.count > indexPath.row) {
        NSURL *url = [[self.lastMessagesUsers objectAtIndex:indexPath.row] avatarURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        cell.thumbnailImageView.image = image;
        
    }
    
    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier:@"showMessages" sender:self];
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
    if ([[segue identifier] isEqualToString:@"showMessages"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OCTIssue *conversation = [self.conversations objectAtIndex:indexPath.row];
        [[segue destinationViewController] setConversation:conversation andRepo: self.repo];
    }
    
}

@end
