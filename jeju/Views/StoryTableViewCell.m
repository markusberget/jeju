//
//  StoryTableViewCell.m
//  jeju
//
//  Created by Ivar Johannesson on 7.5.2014.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "StoryTableViewCell.h"

@implementation StoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


/*-(void) setStory:(StoryModel *)story
{
    if(_story != story)
    {
        _story = story;
        [self configureView];
    }
        
}

-(void) configureView
{
    
    if (self.story != nil) {
        //self.storyNameLabel.text = self.story.name;
    }
   
}*/

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
