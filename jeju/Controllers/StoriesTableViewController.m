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
#import "StoryTableViewCell.h"
#import "PlanningPokerViewController.h"
#import <QuartzCore/QuartzCore.h>


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
        self.stories = [self.pivotalTrackerRepository getStoriesFrom:self.project.id With:[[NSUserDefaults standardUserDefaults] objectForKey:@"pttoken"] FilterOn:@"started"];
        
        [self.tableView reloadData];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoryTableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self configureView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *stories = [[self pivotalTrackerRepository] getStoriesFrom:self.project.id With:[defaults objectForKey:@"pttoken"] FilterOn:@"started"];
    
    self.stories = stories;
    
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


- (StoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StoryTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    StoryModel *story = [self.stories objectAtIndex:indexPath.row];
    cell.storyNameLabel.text = story.name;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryModel *story = [self.stories objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPlanningPoker" sender:self];
}

- (void)configureCell:(StoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    StoryModel *story = [self.stories objectAtIndex:indexPath.row];
    cell.storyNameLabel.text = story.name;
    NSLog(@"Story name and namelabel:");
    NSLog(@"%@", story.name);
    NSLog(@"%@", cell.storyNameLabel.text);
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
    if ([[segue identifier] isEqualToString:@"showPlanningPoker"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        StoryModel *story = [self.stories objectAtIndex:indexPath.row];
        [[segue destinationViewController] setStory:story];
        //        [[segue destinationViewController] setRepo:repo];
    }

}


@end
