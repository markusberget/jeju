//
//  MessagesTableViewController.h
//  jeju
//
//  Created by Markus Berget on 2014-04-09.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OctoKit.h"

@interface MessagesTableViewController : UITableViewController

@property (nonatomic, strong) OCTIssue *conversation;


-(void) setConversation:(OCTIssue *)conversation;
@end
