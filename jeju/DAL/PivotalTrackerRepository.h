//
//  PivotalTrackerRepository.h
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PivotalTrackerUser.h"
#import "ProjectModel.h"
#import "VerdictModel.h"

@interface PivotalTrackerRepository : NSObject

- (PivotalTrackerUser *)getUserFrom:(NSString *)name And:(NSString *)password;

- (NSMutableArray *)getProjects:(NSString *)token;

-(NSMutableArray *)getStoriesFrom:(NSNumber *)projectId With:(NSString *)token FilterOn:(NSString *)storyState;

-(PivotalTrackerUser *)getUserFrom:(NSNumber *)projectId :(NSNumber *)storyId :(NSString *)token;

-(VerdictModel *) uploadEstimate:(NSNumber *)estimate :(NSNumber *)projectId :(NSNumber *)storyId :(NSString *)token;
@end
