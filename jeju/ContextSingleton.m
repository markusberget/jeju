//
//  ContextSingleton.m
//  jeju
//
//  Created by Mathias Dosé on 15/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "ContextSingleton.h"

@interface ContextSingleton ()

@end
@implementation ContextSingleton
static NSManagedObjectContext* c = nil;


+(NSManagedObjectContext *)context
{
    return c;
}

+(void)setContext:(NSManagedObjectContext *)context
{
    c = context;
}

@end
