//
//  FeedTableViewController.m
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "FeedTableViewController.h"
#import <NSNotificationCenter+RACSupport.h>
#import "OctokitModel.h"
#import "CommitTableViewCell.h"
#import "Octokit.h"
#import "CommitViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "CommitPoller.h"
#import <UIKit/UILocalNotification.h>

@implementation FeedTableViewController

@synthesize repo = _repo;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        

    }
    return self;
}

-(void) viewDidLoad
{    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommitTableViewCell" bundle:nil] forCellReuseIdentifier:@"commitCell"];

    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    [activityIndicator startAnimating];
}

-(NSMutableArray *) commits {
    return [[CommitPoller instance] commits];
}

-(void) setRepo:(OCTRepository *)repo
{
    if(_repo != repo) {
        _repo = repo;
        
        [[CommitPoller instance] addObserver:^(NSArray * array, int num) {
            [self.tableView reloadData];
        }];
    }
}

-(OCTRepository *)repo
{
    return _repo;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commits ? self.commits.count : 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"commitCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"commitCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (self.commits) {
        OCTGitCommit * commit = [self.commits objectAtIndex:indexPath.row];
        [cell setCommit:commit];
        
        cell.repo = self.repo;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CommitPoller instance] getDetailsForCommitAtIndex:indexPath.row withContinuation:^(OCTGitCommit * commit) {
          [self performSegueWithIdentifier:@"showCommitDetail" sender: commit];
    }];
}

#pragma mark Navigation


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CommitViewController * ctrl = [segue destinationViewController];
    [ctrl setCommit:sender];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(id) copyWithZone:(NSZone *)zone
{
    FeedTableViewController * cpy = [[FeedTableViewController allocWithZone:zone] init];
    return cpy;
}

@end