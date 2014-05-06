//
//  NotesTableViewController.h
//  jeju
//
//  Created by Viktor Ansund on 11/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) IBOutlet UITableView *notesTable;

@end
