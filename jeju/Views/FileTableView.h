//
//  FileTableView.h
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Octokit.h"

@interface FileTableView : UITableView <UITableViewDataSource>

@property (strong, nonatomic) NSArray * files;

@end
