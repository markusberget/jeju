//
//  MessagesTableViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-09.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OctoKit.h"
#import "OctoKitModel.h"
#import "DAKeyboardControl.h"

@interface MessagesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OctokitModel *octokitModel;

@property (nonatomic, strong) OCTIssue *conversation;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) OCTRepository *repo;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *writeMessageView;

@property (nonatomic, strong) IBOutlet UITextField *message;

-(IBAction)sendMessage:(id)sender;

-(void) setConversation:(OCTIssue *)conversation andRepo:(OCTRepository *) newRepo;

@end
