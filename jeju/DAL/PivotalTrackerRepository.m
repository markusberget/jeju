//
//  PivotalTrackerRepository.m
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PivotalTrackerRepository.h"
#import "StoryModel.h"

@implementation PivotalTrackerRepository

-(PivotalTrackerUser *)getUserFrom:(NSString *)name And:(NSString *)password
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://%@:%@@www.pivotaltracker.com/services/v5/me", name, password]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    NSError *jsonParseError;
    NSMutableDictionary  *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &jsonParseError];
    
    NSLog(@"%@", json[@"username"]);
    PivotalTrackerUser *userToReturn = [[PivotalTrackerUser alloc] init];
    userToReturn.userName = json[@"username"];
    userToReturn.token = json[@"api_token"];
    userToReturn.name = json[@"name"];
    
    return userToReturn;
    
}

-(NSMutableArray *)getProjects:(NSString *)token
{
    NSURL *url = [NSURL URLWithString: @"https://www.pivotaltracker.com/services/v5/projects"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:token forHTTPHeaderField:@"X-TrackerToken"];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *jsonParseError;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonParseError];
    
    NSMutableArray *projectsToReturn = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *projectDictionary in jsonArray) {
        ProjectModel *project = [[ProjectModel alloc] init];
        project.name = projectDictionary[@"name"];
        project.id = projectDictionary[@"id"];
        [projectsToReturn addObject:project];
    }
    
    
    
    return projectsToReturn;
    
    
                  
}

-(NSMutableArray *)getStoriesFrom:(NSNumber *)projectId With:(NSString *)token FilterOn:(NSString *)storyState
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v5/projects/%@/stories?date_format=millis&with_state=%@", projectId, storyState]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:token forHTTPHeaderField:@"X-TrackerToken"];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", newStr);
    NSError *jsonParseError;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonParseError];
    
    NSMutableArray *storiesToReturn = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *storyDictionary in jsonArray) {
        StoryModel *story = [[StoryModel alloc] init];
        story.name = storyDictionary[@"name"] != nil ? storyDictionary[@"name"] : @"N/A";
        story.estimate = storyDictionary[@"estimate"];
        story.url = storyDictionary[@"url"];
        story.state = storyDictionary[@"current_state"];
        NSLog(@"%@", storyDictionary[@"url"]);
        
        [storiesToReturn addObject:story];
    }
    
    return storiesToReturn;

}


@end
