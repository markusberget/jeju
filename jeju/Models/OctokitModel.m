//
//  OctokitModel.m
//  jeju
//
//  Created by Davíð Arnarsson on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "OctokitModel.h"
#import "OCTUser.h"

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

-(BFTask *) getBranches:(NSString *)repo withOwner:(NSString *)owner
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
    RACSignal * request = [[self getAuthenticatedClient] fetchBranchesForRepositoryWithName:repo owner:owner];
    
    [[request collect] subscribeNext:^(NSArray * x) {
        [source setResult:x];
    }
    error:^(NSError *error) {
        [source setError:error];
    }];

    return source.task;
}

-(BFTask *) getIssues:(NSURL *) issueURL
{
    BFTaskCompletionSource * source = [BFTaskCompletionSource taskCompletionSource];
    
  
    
    return nil;

}
@end
