//
//  PivotalTrackerRepository.h
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PivotalTrackerUser.h"

@interface PivotalTrackerRepository : NSObject

- (PivotalTrackerUser *)getUserFrom:(NSString *)name And:(NSString *)password;
@end
