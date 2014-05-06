//
//  PivotalTrackerUser.h
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PivotalTrackerUser : NSObject

@property (nonatomic, weak) NSString* token;
@property (nonatomic, weak) NSString* userName;
@property (nonatomic, weak) NSString* name;

@end
