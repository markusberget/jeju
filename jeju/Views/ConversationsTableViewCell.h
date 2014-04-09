//
//  ConversationsTableViewCell.h
//  jeju
//
//  Created by Joel Lundell on 4/9/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastActivityLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
