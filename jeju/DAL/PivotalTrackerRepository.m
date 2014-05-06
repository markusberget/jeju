//
//  PivotalTrackerRepository.m
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PivotalTrackerRepository.h"

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

@end
