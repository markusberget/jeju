//
//  NoteModel.m
//  jeju
//
//  Created by Davíð Arnarsson on 08/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

-(instancetype) initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    
    if(self) {
        self.context = context;
    }

    return self;
}


-(NSArray *)containsFiles:(NSArray *) files {
    NSEntityDescription * description = [NSEntityDescription entityForName:@"Note" inManagedObjectContext: self.context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    [request setEntity:description];
    
    
    NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"ANY %K IN %@", @"filePath", files];
    [request setPredicate:predicate];
    NSError * error;
    NSArray * results = [self.context executeFetchRequest:request error:&error];
    
    if (results == nil) {
        //DEALWITHIT.gif /--O^O/
    }
    
    NSLog(results[0]);
    return results;
}


@end
