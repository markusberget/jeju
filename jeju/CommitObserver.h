//
//  CommitObserver.h
//  jeju
//
//  Created by Davíð Arnarsson on 13/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitBlock.h"

@interface CommitObserver : NSObject

@property (strong, nonatomic) HandlingBlock block;
@property (strong, nonatomic) NSString * key;
@property (atomic) BOOL skipFirst;

-(instancetype) init;

@end