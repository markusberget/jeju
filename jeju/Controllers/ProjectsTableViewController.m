//
//  ProjectsTableViewController.m
//  jeju
//
//  Created by Mathias Dosé on 06/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "PivotalTrackerRepository.h"
#import "StoriesTableViewController.h"

@interface ProjectsTableViewController ()

@property (strong, nonatomic) PivotalTrackerRepository *pivotalTrackerRepository;
@property (strong, nonatomic) NSArray *projects;
@property (strong, nonatomic) PivotalTrackerLoginViewController *pivotalTrackerLoginViewController;

@end

@implementation ProjectsTableViewController

- (void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"pttoken"] != nil) {
        self.projects = [[self pivotalTrackerRepository] getProjects:[defaults objectForKey:@"pttoken"]];
        
        [self.tableView reloadData];
    }

    
}

- (PivotalTrackerRepository *)pivotalTrackerRepository
{
    if (_pivotalTrackerRepository == nil) {
        _pivotalTrackerRepository = [[PivotalTrackerRepository alloc] init];
    }
    return _pivotalTrackerRepository;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.pivotalTrackerLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PivotalTrackerLoginViewController"];
    
    
    if ([defaults objectForKey:@"pttoken"] == nil) {
        [self presentViewController:self.pivotalTrackerLoginViewController animated:YES completion:nil];
    }
    
    self.projects = [[self pivotalTrackerRepository] getProjects:[defaults objectForKey:@"pttoken"]];
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ProjectModel *project = [self.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showProjectDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProjectModel *project = [self.projects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setProject:project];
//        [[segue destinationViewController] setRepo:repo];
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
