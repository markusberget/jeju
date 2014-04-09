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

@interface MessagesTableViewController : UITableViewController

@property (nonatomic, strong) OctokitModel *octokitModel;

@property (nonatomic, strong) OCTIssue *conversation;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) OCTRepository *repo;


-(void) setConversation:(OCTIssue *)conversation andRepo:(OCTRepository *) newRepo;

@end
