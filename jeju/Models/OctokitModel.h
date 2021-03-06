//
//  OctokitModel.h
//  jeju
//
//  Created by Davíð Arnarsson on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OctoKit.h"
#import "Bolts.h"

@interface OctokitModel : NSObject

@property (nonatomic, weak) NSString* token;
@property (nonatomic, weak) NSString* userName;


-(instancetype) initWithToken:(NSString *) token
                  andUserName:(NSString *) userName;

/**
 * Authenticates a user against Github.
 *
 * scopes - A bitflag of the scopes the access_token should support.
 * 
 * Returns a BFTask task, which will contain an initialized OctokitModel instance.
 */
+(BFTask *) authenticateWithScopes:(OCTClientAuthorizationScopes) scopes;

/**
 * Fetches a single repository from github
 *  
 * name - The name of the repository
 * owner - The owner of the repository. 
 *
 * Returns a BTTask, whos result will contain the OCTRepository.
 */
-(BFTask *) getRepository:(NSString *)name :(NSString *)owner;

/**
 * Fetches all available repositories for a given user.
 * 
 * Returns a BFTask whose result will be an array of OCTRepository.
 */
-(BFTask *) getRepositories;

/**
 * Fetches all the branches for a given repository.
 * 
 * repo - The repo to get the branches for.
 * owner - The owner of the repo
 *
 * Returns a BFTask task, whose result will be an array of OCTBranch.
 */
-(BFTask *) getBranches:(NSString *) repo
                       withOwner:(NSString *) owner;

/**
 *Fetches all issues with the label message
 **/
-(BFTask *) getConversations:(OCTRepository *) repo;

-(BFTask *) getMessages:(OCTRepository *) repo forConversation: (OCTIssue *) conversation;

-(BFTask *) getLastMessageForRepo:(OCTRepository *)repo forConversation:(OCTIssue *) conversation;

-(BFTask *) getUserFromLoginName:(NSString *)loginName;


-(BFTask *) getCommits:(NSString *)forRepo
             withOwner:(NSString *)owner
                 notMatchingEtag:(NSString *)etag
                 since:(NSDate *) date
            fromBranch:(NSString *) branch;

-(BFTask *) getCommit:(NSString *) sha
             fromRepo:(OCTRepository *) repo;

-(BFTask *) getFilePaths:(OCTRepository *) repo;

-(BFTask *) getTree: (OCTRepository *) repo sha: (NSString *) sha;

-(BFTask *) getHeadOfMaster: (OCTRepository *) repo;

-(BFTask *) sendMessage: (NSString *)message forConversation: (OCTIssue *) conversation inRepo: (OCTRepository *) repo;

+(instancetype) instanceFromDefaults;

@end
