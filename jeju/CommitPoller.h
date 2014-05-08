//
//  RepoPoller.h
//  jeju
//
//  Created by Davíð Arnarsson on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Octokit.h" 
#import "OctokitModel.h"


@interface CommitPoller : NSObject

@property (nonatomic, strong) NSMutableArray * commits;
@property (strong, nonatomic) NSTimer * pollTimer;
@property (strong, nonatomic) NSString * lastEtag;
@property (strong, nonatomic) NSDate  * lastPollDate;
@property (strong, nonatomic) OctokitModel * model;
@property (strong, nonatomic) NSString * branch;

@property (atomic)  NSUInteger ids;
@property (weak, nonatomic) OCTRepository * repo;

-(void)startPollingRepo:(OCTRepository *) repo;
-(void)stopPolling;

-(instancetype) initWithBranch:(NSString *) branch;
+(instancetype) instance;

typedef void (^ HandlingBlock)(id, int);
-(NSString *)addObserver:(HandlingBlock) block;
-(void)removeObserver:(NSString *) observerId;

typedef void (^ ReturnBlock)(OCTGitCommit *);
-(void) getDetailsForCommitAtIndex: (NSUInteger) index withContinuation: (ReturnBlock) block;
@end
