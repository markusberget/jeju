//
//  ConversationTableViewController.h
//  jeju
//
//  Created by Joel Lundell on 4/8/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OctoKit.h"
#import "OctokitModel.h"


@interface ConversationTableViewController : UITableViewController

@property (strong, nonatomic) OCTRepository *repo;

@property (strong, nonatomic) NSArray *conversations;

@property (strong, nonatomic) OctokitModel *octokitModel;

@end
