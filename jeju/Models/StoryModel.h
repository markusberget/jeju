//
//  StoryModel.h
//  jeju
//
//  Created by Mathias Dosé on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PivotalTrackerUser.h"

@interface StoryModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *estimate;
@property (strong , nonatomic) NSString *url;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *projectId;
@property (strong, nonatomic) NSNumber *storyId;

@end
