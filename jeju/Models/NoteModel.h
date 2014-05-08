//
//  NoteModel.h
//  jeju
//
//  Created by Davíð Arnarsson on 08/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, weak) NSManagedObjectContext * context;

-(instancetype) initWithContext:(NSManagedObjectContext *) context;


-(NSArray *)containsFiles:(NSArray *) files;

@end
