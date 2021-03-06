//
//  CreateNoteViewController.h
//  
//
//  Created by Viktor Ansund on 07/05/14.
//
//

#import <UIKit/UIKit.h>
#import "OctoKitModel.h"

@interface CreateNoteViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *note;
@property (strong, nonatomic) IBOutlet UIPickerView *filePicker;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) OctokitModel *octokitModel;
@property (nonatomic, strong) OCTRepository *repo;


@property (strong, nonatomic) OCTTree *octTree;
@property (strong, nonatomic) OCTTreeEntry *octTreeEntry;
@property (strong, nonatomic) NSString *SHA;

-(IBAction)dismissModal:(id)sender;
-(IBAction)saveNote:(id)sender;

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView  *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end
