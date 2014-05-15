//
//  ContextSingleton.h
//  jeju
//
//  Created by Mathias Dosé on 15/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContextSingleton : NSObject

+(NSManagedObjectContext*) context;

+(void) setContext:(NSManagedObjectContext*)context;

@end

