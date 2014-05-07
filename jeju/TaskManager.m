//
//  TaskManager.m
//  jeju
//
//  Created by Davíð Arnarsson on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskManager

static TaskManager *  _instance = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+(instancetype) instance
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [[TaskManager alloc] init];
        }
        
        return _instance;
    }
}

@end
