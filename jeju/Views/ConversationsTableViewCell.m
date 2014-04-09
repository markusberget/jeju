//
//  ConversationsTableViewCell.m
//  jeju
//
//  Created by Joel Lundell on 4/9/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "ConversationsTableViewCell.h"

@implementation ConversationsTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize bodyLabel = _bodyLabel;
@synthesize lastActivityLabel = _lastActivityLabel;
@synthesize thumbnailImageView = _thumbnailImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
