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
#import "CommitBlock.h"
#import "CommitObserver.h"

@interface CommitPoller : NSObject

@property (atomic) BOOL initialFetch;
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


-(NSString *)addObserver:(HandlingBlock) block;
-(NSString *) addObserver:(HandlingBlock)block shouldSkipFirst:(BOOL) skip;
-(void)removeObserver:(NSString *) observerId;


-(void) getDetailsForCommitAtIndex: (NSUInteger) index withContinuation: (ReturnBlock) block;
-(void) getDetailsForCommitWithSHA: (NSString *) sha withContinuation: (ReturnBlock) block;
@end
