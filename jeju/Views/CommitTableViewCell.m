//
//  CommitTableViewCell.m
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "CommitTableViewCell.h"
#import "DateUtil.h"

@implementation CommitTableViewCell

@synthesize commit = _commit;

-(void)setCommit:(OCTGitCommit *)commit
{
    if(_commit != commit){
        _commit = commit;
        
        [self configureView];
    }
}



- (IBAction)onOpenTouch:(id)sender
{
    NSString * url = [NSString stringWithFormat:@"https://github.com/%@/%@/commit/%@", self.repo.ownerLogin, self.repo.name, _commit.SHA];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void) configureView
{
    
    if (_commit.committer) {
         [self.image setImageWithURL:_commit.committer.avatarURL];
    } else {
        [self.image setImage:[UIImage imageNamed:@"noAvatar"]];
    }
    
    self.author.text = _commit.committer ? _commit.committer.name : _commit.committerName;

    self.commitNumber.text = _commit.SHA;
    self.timestamp.text = [DateUtil formatDate:_commit.commitDate WithFormat:@"HH:mm:ss dd.MMM YYYY"];
    self.message.text = _commit.message;
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
