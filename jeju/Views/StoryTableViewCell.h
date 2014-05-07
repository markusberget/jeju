//
//  StoryTableViewCell.h
//  jeju
//
//  Created by Ivar Johannesson on 7.5.2014.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface StoryTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *storyNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bottomImage;
@property (nonatomic, weak) IBOutlet UIImageView *middleImage;
@property (nonatomic, weak) IBOutlet UIImageView *topImage;
@property (nonatomic, strong) StoryModel *story;



@end