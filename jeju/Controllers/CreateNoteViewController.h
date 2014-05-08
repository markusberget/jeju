//
//  CreateNoteViewController.h
//  
//
//  Created by Viktor Ansund on 07/05/14.
//
//

#import <UIKit/UIKit.h>

@interface CreateNoteViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *note;
@property (strong, nonatomic) IBOutlet UIPickerView *filePicker;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)dismissModal:(id)sender;
-(IBAction)saveNote:(id)sender;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView  *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end
