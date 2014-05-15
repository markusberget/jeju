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
@property (strong, nonatomic) NSMutableArray *startedStories;
@property (strong, nonatomic) NSMutableArray *unstartedStories;
@property (strong, nonatomic) NSMutableArray *storiesToShow;





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
        self.startedStories = [self.pivotalTrackerRepository getStoriesFrom:self.project.id With:[[NSUserDefaults standardUserDefaults] objectForKey:@"pttoken"] FilterOn:@"started"];
        
        self.storiesToShow = [self.pivotalTrackerRepository getStoriesFrom:self.project.id With:[[NSUserDefaults standardUserDefaults] objectForKey:@"pttoken"] FilterOn:@"started"];
        
        
        
        self.unstartedStories = [self.pivotalTrackerRepository getStoriesFrom:self.project.id With:[[NSUserDefaults standardUserDefaults] objectForKey:@"pttoken"] FilterOn:@"unstarted"];
        
        [self fillList];
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

    NSMutableArray *startedStories = [[self pivotalTrackerRepository] getStoriesFrom:self.project.id With:[defaults objectForKey:@"pttoken"] FilterOn:@"started"];
    
    NSMutableArray *storiesToShow = [[self pivotalTrackerRepository] getStoriesFrom:self.project.id With:[defaults objectForKey:@"pttoken"] FilterOn:@"started"];
    
    
    
    NSMutableArray *unstartedStories = [[self pivotalTrackerRepository] getStoriesFrom:self.project.id With:[defaults objectForKey:@"pttoken"] FilterOn:@"unstarted"];
    
    
    
    self.startedStories = startedStories;
    self.unstartedStories = unstartedStories;
    self.storiesToShow = storiesToShow;
    
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
    return self.storiesToShow.count;
}

- (IBAction) segmentedControlIndexChanged
{
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
            [self fillList];
            break;
        case 1:
            [self fillList];
            break;
        default:
            break;
    }
}

-(void)fillList
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self.storiesToShow removeAllObjects];
        
        for(StoryModel *story in self.startedStories)
        {
            [self.storiesToShow insertObject:story atIndex:0];
        }
    }
    else
    {
        [self.storiesToShow removeAllObjects];
        for(StoryModel *story in self.unstartedStories)
        {
            [self.storiesToShow insertObject:story atIndex:0];
        }
    }
    [self.tableView reloadData];
}


- (StoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StoryTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    
    StoryModel *story = [self.storiesToShow objectAtIndex:indexPath.row];
    
    
    cell.storyNameLabel.text = story.name;
    
    cell.estimateLabel.text = [story.estimate stringValue];
    cell.typeLabel.text = story.state;

    cell.ownerLabel.text = story.owner;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryModel *story = [self.storiesToShow objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPlanningPoker" sender:self];
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
        StoryModel *story = [self.storiesToShow objectAtIndex:indexPath.row];
        [[segue destinationViewController] setStory:story];
        //        [[segue destinationViewController] setRepo:repo];
    }

}


@end
