//
//  TaskManager.h
//  jeju
//
//  Created by Davíð Arnarsson on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskManager : NSObject

@property (nonatomic, strong) NSMutableArray* watchedFiles;

-(instancetype) init;

+(instancetype) instance;



@end
