//
//  MyRootViewController.m
//  jeju
//
//  Created by Mathias Dosé on 15/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "MyRootViewController.h"

@interface MyRootViewController ()

@end

@implementation MyRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OCTRepository *repo = [self.repos objectAtIndex:indexPath.row];
        [[segue destinationViewController] setRepo:repo];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}
*/
@end
