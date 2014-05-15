//
//  PlanningPokerCardViewController.h
//  jeju
//
//  Created by Mathias Dosé on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface PlanningPokerCardViewController : UIViewController
- (void)setCardButtonText:(NSString *)text;
@property (strong, nonatomic) StoryModel* story;
@end
