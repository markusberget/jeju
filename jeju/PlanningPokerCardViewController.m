//
//  PlanningPokerCardViewController.m
//  jeju
//
//  Created by Mathias Dosé on 08/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "PlanningPokerCardViewController.h"

@interface PlanningPokerCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *planningPokerCardButton;
@property (strong, nonatomic) NSString *textToInstantiatePlanningCardButtonWith;
@property (nonatomic) BOOL *cardIsUp;
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
//    [self.planningCardButton setTitle:self.textToInstantiatePlanningCardButtonWith forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
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
