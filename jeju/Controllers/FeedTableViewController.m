//
//  FeedTableViewController.m
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "FeedTableViewController.h"
#import "OctokitModel.h"
#import "CommitTableViewCell.h"
#import "Octokit.h"
#import "CommitViewController.h"

@implementation FeedTableViewController

@synthesize repo = _repo;
@synthesize model = _model;

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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    SEL selector = @selector(fetchData);
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    self.pollTimer = [NSTimer timerWithTimeInterval:10 invocation:invocation repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.pollTimer forMode:NSDefaultRunLoopMode];

}


-(void) viewWillDisappear:(BOOL)animated
{
    if (self.pollTimer) {
        [self.pollTimer invalidate];
        self.pollTimer = nil;
    }
}

-(OctokitModel *)model
{
    if(!_model) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        _model = [[OctokitModel alloc]
                      initWithToken:[defaults objectForKey:@"token"]
                      andUserName:@"user"];
    }
   
    return _model;
}

-(void) setRepo:(OCTRepository *)repo
{
    if(_repo != repo) {
        _repo = repo;
        
        [self fetchData];
    }
}

-(OCTRepository *)repo
{
    return _repo;
}



-(void) handleNewCommits:(NSArray *) newCommits {
    if (!self.commits) {
        self.commits = [[NSMutableArray alloc] init];
    }
    
    if(newCommits.count) {
        // add new commits to the front of the list
        for(int i = newCommits.count-1; i >= 0 ; --i) {
            OCTResponse * response = [newCommits objectAtIndex:i];
            [self.commits insertObject:response.parsedResult atIndex:0];
        }
        
        self.lastEtag = ((OCTResponse *)[newCommits firstObject]).etag;
        self.lastPollDate = [NSDate date];
    }
}

-(void) fetchData
{
    if(self.repo) {
        
        [[self.model getCommits: self.repo.name
                      withOwner:self.repo.ownerLogin
                          notMatchingEtag:self.lastEtag
                          since:self.lastPollDate]
         
              continueWithBlock:^id(BFTask *task) {
            if (task.error) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                                 message:@"I'm afraid I can't do that, Dave."
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:nil];
                [alert show];
            } else {
                NSArray * response = task.result;
                
                [self handleNewCommits: response];
                [self.tableView reloadData];
            }
            return nil;
        }];
    }
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
    OCTGitCommit * commit = [self.commits objectAtIndex:indexPath.row];
    
    [[self.model getCommit:commit.SHA fromRepo:self.repo] continueWithBlock:^id(BFTask *task) {
        [self performSegueWithIdentifier:@"showCommitDetail" sender: task.result];
        return nil;
    }];
}

#pragma mark Navigation


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CommitViewController * ctrl = [segue destinationViewController];
    [ctrl setCommit:sender];
}


- (IBAction)onDismissTouch:(id)sender {
    if (!self.pollingView.hidden) {
        self.pollingView.hidden = YES;
        int height = 62;
        /**http://stackoverflow.com/questions/8542506/how-to-show-hide-a-uiview-with-animation-in-ios */
        CGRect fz = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y - height,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height + height);

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 0.300];
        self.view.frame = fz;
        [UIView commitAnimations];
        
    }
}
@end