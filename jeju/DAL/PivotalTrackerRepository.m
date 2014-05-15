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
    NSLog(@"%@", newStr);
    NSError *jsonParseError;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonParseError];
    
    NSMutableArray *storiesToReturn = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *storyDictionary in jsonArray) {
        StoryModel *story = [[StoryModel alloc] init];
        story.name = storyDictionary[@"name"] != nil ? storyDictionary[@"name"] : @"N/A";
        story.estimate = storyDictionary[@"estimate"];
        story.state = storyDictionary[@"current_state"];
        story.owner = [self getUserFrom:projectId :storyDictionary[@"id"] :token];
        story.type = storyDictionary[@"story_type"];
        story.projectId = projectId;
        story.storyId = storyDictionary[@"id"];
        [storiesToReturn addObject:story];
    }
    
    return storiesToReturn;

}
-(PivotalTrackerUser *)getUserFrom:(NSNumber *)projectId :(NSNumber *)storyId :(NSString *)token
{
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v5/projects/%@/stories/%@/owners", projectId, storyId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:token forHTTPHeaderField:@"X-TrackerToken"];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", newStr);
    
    NSError *jsonParseError;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonParseError];
    
    NSMutableDictionary *userDictionary = jsonArray[0];
    PivotalTrackerUser *user = [[PivotalTrackerUser alloc] init];
    user.name = userDictionary[@"name"];
    user.userName = userDictionary[@"username"];
    user.initials = userDictionary[@"initials"];
    
    return user;
    
}

- (VerdictModel *)uploadEstimate:(NSNumber *)estimate :(NSNumber *)projectId :(NSNumber *)storyId :(NSString *)token
{
    NSString *post = [NSString stringWithFormat:@"{\"estimate\":%@}", estimate];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v5/projects/%@/stories/%@", projectId, storyId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:token forHTTPHeaderField:@"X-TrackerToken"];
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", newStr);
    
    
    NSError *jsonParseError;
    NSMutableDictionary  *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &jsonParseError];
    VerdictModel *verdictToReturn = [[VerdictModel alloc] init];
    if (json[@"general_problem"] != nil) {
        verdictToReturn.message = json[@"general_problem"];
        verdictToReturn.succeeded = false;
        
    }
    else if(json[@"estimate"] != nil){
        verdictToReturn.message = [NSString stringWithFormat:@"Successfully uploaded the estimate %@ to %@.", json[@"estimate"], json[@"name"]];
        verdictToReturn.succeeded = true;
    }
    else {
        verdictToReturn.message = @"Something unexpected happened while trying to upload";
        verdictToReturn.succeeded = false;
    }
    
    return verdictToReturn;
}


@end
