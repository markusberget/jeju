//
//  StoriesTableViewController.h
//  jeju
//
//  Created by Mathias Dosé on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface StoriesTableViewController : UITableViewController
{
    UISegmentedControl *segmentControl;
}


@property (strong, nonatomic) ProjectModel *project;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)segmentedControlIndexChanged;

@end
