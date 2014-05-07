//
//  CommitViewController.m
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "CommitViewController.h"
#import "DateUtil.h"

@interface CommitViewController ()

@end

@implementation CommitViewController

@synthesize commit = _commit;

-(void) setCommit:(OCTGitCommit *)commit
{
    if (_commit != commit){
        _commit = commit;
        
//        [self configureView];
    }
}

-(void) configureView
{
    self.added.text = [NSString stringWithFormat:@"+%d", _commit.countOfAdditions];
    self.changed.text = [NSString stringWithFormat:@"±%d", _commit.countOfChanges];
    self.deleted.text = [NSString stringWithFormat:@"-%d", _commit.countOfDeletions];
    
    self.date.text = [DateUtil formatDate:_commit.commitDate WithFormat:@"HH:mm:ss dd.MMM YYYY"];
    
    
    if (_commit.committer) {
        [self.avatar setImageWithURL:_commit.committer.avatarURL];
    } else {
        [self.avatar setImage:[UIImage imageNamed:@"noAvatar"]];
    }
    
    self.author.text = _commit.committer ? _commit.committer.name : _commit.committerName;
    self.message.text = _commit.message;
    
    [self.fileTable setFiles:_commit.files];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
