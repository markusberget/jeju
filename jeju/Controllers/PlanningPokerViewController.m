//
//  PlanningPokerViewController.m
//  jeju
//
//  Created by Mathias Dosé on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PlanningPokerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PlanningPokerCardViewController.h"

@interface PlanningPokerViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *planningPokerCards;
@property (strong, nonatomic) NSString *textOfLastClickedPlanningPokerCardButton;
@end

@implementation PlanningPokerViewController

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
    
    [self configureView];
    // Do any additional setup after loading the view.
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.story) {
        self.navigationItem.title = self.story.name;
    }
    [self setBordersForPlanningPokerCards];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.title) {
        self.navigationItem.title = self.title;
    }
//    [self setBordersForPlanningPokerCards];
}

- (void)setBordersForPlanningPokerCards
{
   
    for (UIButton *pokerCardButton in self.planningPokerCards) {
//        [pokerCardButton.layer setBorderWidth:1.0f];
        pokerCardButton.layer.borderWidth = 1.0f;
//        [pokerCardButton.layer setBorderColor:pokerCard.tintColor.CGColor];
        pokerCardButton.layer.borderColor = pokerCardButton.tintColor.CGColor;
        pokerCardButton.layer.cornerRadius = 10;
        pokerCardButton.clipsToBounds = YES;
        
    }
}
- (IBAction)touchPlanningPokerCardButton:(UIButton *)sender {
    NSLog(@"%@", sender.titleLabel.text);
    self.textOfLastClickedPlanningPokerCardButton = sender.titleLabel.text;
    [self performSegueWithIdentifier:@"Planning Poker Card" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Planning Poker Card"]) {
        if ([segue.destinationViewController isKindOfClass:[PlanningPokerCardViewController class]]) {
            PlanningPokerCardViewController *ppcvc = (PlanningPokerCardViewController *)segue.destinationViewController;
            [ppcvc setCardButtonText:self.textOfLastClickedPlanningPokerCardButton];
        }
    }
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
