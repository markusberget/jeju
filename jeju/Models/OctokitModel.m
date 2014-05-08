//
//  OctokitModel.m
//  jeju
//
//  Created by Davíð Arnarsson on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "OctokitModel.h"
#import "OCTUser.h"
#import "DateUtil.h"

@implementation OctokitModel

- (instancetype)initWithToken:(NSString *)token andUserName:(NSString *)userName
{
    self = [super init];
    if (self) {
        self.token = token;
        self.userName = userName;
    }
    return self;
}

+(BFTask *) authenticateWithScopes:(OCTClientAuthorizationScopes)scopes
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];

    //Loading clientID and clientSecret from jeju-info.plist
    NSString *clientID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Github.clientID"];
    NSString *clientSecret = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Github.clientSecret"];

    [OCTClient setClientID:clientID clientSecret:clientSecret];
    
    [[OCTClient signInToServerUsingWebBrowser:[OCTServer dotComServer]  scopes:scopes]
     subscribeNext:^(OCTClient* authenticatedClient) {

         OctokitModel * model = [[OctokitModel alloc] initWithToken:authenticatedClient.token
                                                        andUserName:authenticatedClient.user.rawLogin];
         
         [source setResult:model];
     } error:^(NSError *error) {
         [source setError:error];
     }];
    
    return source.task;
}

-(BFTask *) getRepository:(NSString *)name :(NSString *)owner
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
    RACSignal * signal = [[self getAuthenticatedClient] fetchRepositoryWithName:name owner:owner];
    
    [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(OCTRepository* repo) {
        [source setResult:repo];
    } error:^(NSError *error) {
        [source setError:error];
    }];
    
    return source.task;
}

-(OCTClient *) getAuthenticatedClient
{
    OCTUser * user = [OCTUser userWithRawLogin:self.userName server:[OCTServer dotComServer]];
    return [OCTClient authenticatedClientWithUser:user token:self.token];
}

-(BFTask *) getRepositories
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];

    RACSignal * signal = [[self getAuthenticatedClient] fetchUserRepositories];
    [[[signal deliverOn:[RACScheduler mainThreadScheduler]] collect] subscribeNext:^(NSArray * repos) {
        [source setResult:repos];
    }
     error:^(NSError *error) {
         [source setError:error];
     }];
    
    return source.task;
}

-(BFTask *) getDataForPath: (NSString *) path andParameters: (NSDictionary *) params returnClass: (Class) resultClass
{
    return [self getDataForPath:path andParameters:params returnClass:resultClass notMatching:nil];
}

-(BFTask *) getDataForPath: (NSString *) path andParameters: (NSDictionary *) params returnClass: (Class) resultClass notMatching:(NSString *) etag
{
    BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableURLRequest *request = [[self getAuthenticatedClient] requestWithMethod:@"GET" path:path parameters:params notMatchingEtag:etag ];

    RACSignal *signal = [[self getAuthenticatedClient] enqueueRequest:request resultClass:resultClass];
    
    [[[signal deliverOn:[RACScheduler mainThreadScheduler]] collect] subscribeNext:^(NSArray *issues) {
        [source setResult:issues];
    }
     error:^(NSError *error) {
         [source setError:error];
     }];
    
    return source.task;
}

-(BFTask *) getConversations:(OCTRepository *)repo
{
    
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/issues", repo.ownerLogin, repo.name];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"labels", @"message", nil];
    
    return [self getDataForPath:path andParameters:parameters returnClass:OCTIssue.class];
}

-(BFTask *) getMessages:(OCTRepository *)repo forConversation:(OCTIssue *)conversation
{
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/issues/%@/comments", repo.ownerLogin, repo.name, conversation.objectID];
    
    
    return [self getDataForPath:path andParameters:nil returnClass:OCTIssueComment.class];
}

-(BFTask *) getLastMessageForRepo:(OCTRepository *)repo forConversation:(OCTIssue *)conversation
{
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/issues/%@/comments", repo.ownerLogin, repo.name, conversation.objectID];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"sort", @"updated", nil];
    
    return [self getDataForPath:path andParameters:parameters returnClass:OCTIssueComment.class];
}

-(BFTask *) getUserFromLoginName:(NSString *)loginName
{
    NSString *path = [[NSString alloc] initWithFormat:@"users/%@", loginName];
    
    return [self getDataForPath:path andParameters:nil returnClass:OCTUser.class];
    
}

-(BFTask *) getBranches:(NSString *)repo withOwner:(NSString *)owner
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
    RACSignal * request = [[self getAuthenticatedClient] fetchBranchesForRepositoryWithName:repo owner:owner];
    
    [[[request deliverOn:[RACScheduler  mainThreadScheduler]] collect] subscribeNext:^(NSArray * x) {
        [source setResult:x];
    }
    error:^(NSError *error) {
        [source setError:error];
    }];

    return source.task;
}

-(BFTask *) getCommits:(NSString *)forRepo withOwner:(NSString *)owner notMatchingEtag:(NSString *) etag
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
    NSString * path = [[NSString alloc] initWithFormat:@"/repos/%@/%@/commits", owner, forRepo];
    
    NSMutableArray * results = [[NSMutableArray alloc] init];
    OCTClient * client = [self getAuthenticatedClient];
    
    NSMutableURLRequest * request = [client requestWithMethod:@"GET" path:path parameters:nil notMatchingEtag:etag ];

    RACSignal * signal = [client enqueueRequest:request resultClass:OCTGitCommit.class];

    [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        [results addObject:(OCTResponse*) x];
    } completed:^{
        [source setResult:results];
    }];
    
    return source.task;
}

-(BFTask *) getCommit:(NSString *)sha fromRepo:(OCTRepository *)repo
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
    RACSignal * signal = [[self getAuthenticatedClient] fetchCommitFromRepository:repo SHA:sha];
    [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(OCTGitCommit * x) {
        [source setResult:x];
    }];
    
    return source.task;
}

-(BFTask *) getFilePaths:(OCTRepository *) repo
{
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/contents", repo.ownerLogin, repo.name];
    return [self getDataForPath:path andParameters:nil returnClass:OCTContent.class];

}

-(BFTask *) getTree:(OCTRepository *) repo sha:(NSString *) sha
{
    //Get the latest commit
    
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/git/trees/%@?recursive=1", repo.ownerLogin, repo.name, sha];
    
    return [self getDataForPath:path andParameters:nil returnClass:OCTTree.class];
}

-(BFTask *) getHeadOfMaster: (OCTRepository *) repo {
    
    NSString *path = [[NSString alloc] initWithFormat:@"repos/%@/%@/git/refs/heads/master", repo.ownerLogin, repo.name];
    
    return [self getDataForPath:path andParameters:nil returnClass:OCTRef.class];
}


@end
