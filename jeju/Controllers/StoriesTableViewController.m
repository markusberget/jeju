//
//  StoriesTableViewController.m
//  jeju
//
//  Created by Mathias Dosé on 07/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "StoriesTableViewController.h"
#import "PivotalTrackerRepository.h"
#import "StoryModel.h"

@interface StoriesTableViewController ()
@property (strong, nonatomic) PivotalTrackerRepository *pivotalTrackerRepository;
@property (strong, nonatomic) NSArray *stories;


@end

@implementation StoriesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.project) {
        self.navigationItem.title = self.project.name;
    }
}

- (PivotalTrackerRepository *)pivotalTrackerRepository
{
    if (_pivotalTrackerRepository == nil) {
        _pivotalTrackerRepository = [[PivotalTrackerRepository alloc] init];
    }
    return _pivotalTrackerRepository;
}

- (void) viewDidAppear:(BOOL)animated
{
    if (self.project != nil) {
        self.stories = [self.pivotalTrackerRepository getStoriesFrom:self.project.id With:[[NSUserDefaults standardUserDefaults] objectForKey:@"pttoken"]];
        
        [self.tableView reloadData];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self configureView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *stories = [[self pivotalTrackerRepository] getStoriesFrom:self.project.id With:[defaults objectForKey:@"pttoken"]];
    
    self.stories = stories;
    
    for (StoryModel *story in stories) {
        NSLog(@"%@", story.name);
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.stories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    StoryModel *story = [self.stories objectAtIndex:indexPath.row];
    cell.textLabel.text = story.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", story.estimate];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
