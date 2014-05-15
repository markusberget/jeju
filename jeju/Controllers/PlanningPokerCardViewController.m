//
//  PlanningPokerCardViewController.m
//  jeju
//
//  Created by Mathias Dosé on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PlanningPokerCardViewController.h"
#import "PivotalTrackerRepository.h"
#import "VerdictModel.h"

@interface PlanningPokerCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *planningPokerCardButton;
@property (strong, nonatomic) NSString *textToInstantiatePlanningCardButtonWith;
@property (nonatomic) BOOL *cardIsUp;
@property (strong, nonatomic) PivotalTrackerRepository *pivotalTrackerRepository;
@property (weak, nonatomic) IBOutlet UIButton *uploadEstimateButton;

@end

@implementation PlanningPokerCardViewController

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
    [self setBorderForPlanningPokerCard];
    if ([self.textToInstantiatePlanningCardButtonWith isEqualToString:@"?"]) {
        [self.uploadEstimateButton setHidden:YES];
    }
    
//    [self.planningCardButton setTitle:self.textToInstantiatePlanningCardButtonWith forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}

- (PivotalTrackerRepository *)pivotalTrackerRepository
{
    if (_pivotalTrackerRepository == nil) {
        _pivotalTrackerRepository = [[PivotalTrackerRepository alloc] init];
    }
    return _pivotalTrackerRepository;
}


- (void)setStory:(StoryModel *)story
{
    _story = story;
    self.navigationItem.title = story.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCardButtonText:(NSString *)text {
    
    self.textToInstantiatePlanningCardButtonWith = text;
    self.cardIsUp = NO;
}

- (void)setBorderForPlanningPokerCard
{
    self.planningPokerCardButton.layer.borderWidth = 1.0f;
    self.planningPokerCardButton.layer.borderColor = self.planningPokerCardButton.tintColor.CGColor;
    self.planningPokerCardButton.layer.cornerRadius = 10;
    self.planningPokerCardButton.clipsToBounds = YES;
        
    
}
- (IBAction)touchPlanningPokerCardButton:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:self.textToInstantiatePlanningCardButtonWith]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:nil
                forState:UIControlStateNormal];
        
        
    } else {
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        [sender setTitle:self.textToInstantiatePlanningCardButtonWith forState:UIControlStateNormal];
    }
    
}
- (IBAction)uploadEstimateToPivotalTracker:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:self.textToInstantiatePlanningCardButtonWith];
    VerdictModel *verdict = [self.pivotalTrackerRepository uploadEstimate:myNumber :self.story.projectId :self.story.storyId :[defaults objectForKey:@"pttoken"] ];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: verdict.succeeded ? @"Success" : @"An error occurred" message: verdict.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    
    [alert show];
//    if (verdict) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"We're unable to upload the estimate for your story" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        [alert show];
//    } else {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Upload succeeded" message:[NSString stringWithFormat:@"The estimate of %@ was successfully uploaded to the userstory %@", self.textToInstantiatePlanningCardButtonWith, self.story.name] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }
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
