//
//  MyRootViewController.h
//  jeju
//
//  Created by Mathias Dosé on 15/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRootViewController : UITabBarController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
