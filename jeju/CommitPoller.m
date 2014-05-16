    //
//  RepoPoller.m
//  jeju
//
//  Created by Davíð Arnarsson on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//


#import "CommitPoller.h"


@implementation CommitPoller

static CommitPoller * _poller = nil;
NSMutableDictionary * commits;
NSMutableDictionary * observers;
static NSMutableDictionary * commitDetails;
bool polling = NO;

@synthesize model = _model;

-(OctokitModel *) model {
    //TODO: Make better.
    if(!_model) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        _model = [[OctokitModel alloc]
                  initWithToken:[defaults objectForKey:@"token"]
                  andUserName:@"user"];
    }
    
    return _model;
}

+(instancetype)instance
{
    @synchronized(self) {
        if (!_poller) {
            _poller = [[CommitPoller alloc] initWithBranch:nil];
        }
        
        return _poller;
    }
}

- (instancetype)initWithBranch:(NSString *) branch
{
    self = [super init];
    if (self) {
        self.branch = branch;
        self.initialFetch = true;
    }
    return self;
}


-(void)stopPolling
{
    [self.pollTimer invalidate];
    polling = NO;
    _model = nil;
}


-(void)startPollingRepo:(OCTRepository *) repo
{
    polling = YES;
    if(!commitDetails) {
        commitDetails = [[NSMutableDictionary alloc] init];
    }
    if (self.repo != repo) {
        self.repo = repo;
        
        observers = [[NSMutableDictionary alloc] init];

        self.commits = [[NSMutableArray alloc] init];
        self.lastEtag = nil;
        self.lastPollDate = nil;
        
        SEL selector = @selector(fetchData);
        NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:self];
        [invocation setSelector:selector];
        
        self.pollTimer = [NSTimer timerWithTimeInterval:2 invocation:invocation repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.pollTimer forMode:NSDefaultRunLoopMode];
        
    }
}

-(void) handleNewCommits:(NSArray *) newCommits {
     if (!self.commits) {
         self.commits = [[NSMutableArray alloc] init];
     }
    
     NSMutableArray * newActualCommits = [[NSMutableArray alloc] init];
     if(newCommits.count) {
         // add new commits to the front of the list
         for(int i = newCommits.count-1; i >= 0 ; --i) {
             OCTResponse * response = [newCommits objectAtIndex:i];
             OCTGitCommit * commit = response.parsedResult;
             [self.commits insertObject:commit atIndex:0];
             [newActualCommits addObject:commit];
         }
         
         self.lastEtag = ((OCTResponse *)[newCommits firstObject]).etag;
         self.lastPollDate = [NSDate date];
         
         for(id key in observers) {
             CommitObserver * observer = [observers objectForKey:key];
             
             if (!observer.skipFirst || !self.initialFetch) {
                 observer.block(newActualCommits, newActualCommits.count);
             }
         }
         
         // this should only be true for the initial fetch.
         self.initialFetch = false;
     }
}

-(void) fetchData
    {
        if (polling) {
            if(self.repo) {
               [[self.model getCommits: self.repo.name
                           withOwner:self.repo.ownerLogin
                       notMatchingEtag:self.lastEtag
                               since:self.lastPollDate
                        fromBranch:self.branch]
            
               continueWithBlock:^id(BFTask *task) {
                
                   [self handleNewCommits: task.result];
                
                    return nil;
                }];
            }
        }
    }

-(NSString *) addObserver:(HandlingBlock)block
{
    return [self addObserver:block shouldSkipFirst:false];
}


-(NSString *) addObserver:(HandlingBlock)block shouldSkipFirst:(BOOL) skip
{
    CommitObserver * obs = [[CommitObserver alloc] init];
    obs.block = block;
    obs.skipFirst = skip;
    obs.key = [NSString stringWithFormat:@"%d", ++self.ids];
    
    [observers setObject:obs forKey:obs.key];
    return obs.key;
}

-(void)removeObserver:(NSString *)observer
{
    [observers removeObjectForKey:observer];
}

-(void) getDetailsForCommitAtIndex:(NSUInteger)index withContinuation:(ReturnBlock)block
{
    if (!self.commits || self.commits.count < index) {
        block(nil);
    }
    else {
        OCTGitCommit * commit = (OCTGitCommit *)[self.commits objectAtIndex:index];
        OCTGitCommit * details = [commitDetails objectForKey:commit.SHA];
        if (details) {
            block(details);
        } else {
            [self getDetailsForCommitWithSHA:commit.SHA withContinuation: block];
        }
    }
}


-(void) getDetailsForCommitWithSHA:(NSString *)sha withContinuation:(ReturnBlock)block
{
    OCTGitCommit * commit = [commitDetails objectForKey:sha];
    
    if(commit) {
        block(commit);
    } else {
        [[self.model getCommit:sha fromRepo:self.repo] continueWithBlock:^id(BFTask *task) {
            [commitDetails setObject:task.result forKey:sha];
            block(task.result);
            return nil;
        }];
    }
}


@end
