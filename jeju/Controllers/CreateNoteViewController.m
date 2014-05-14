//
//  CreateNoteViewController.m
//  
//
//  Created by Viktor Ansund on 07/05/14.
//
//

#import "CreateNoteViewController.h"

@interface CreateNoteViewController ()

@end

@implementation CreateNoteViewController

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
    [self fetchData];
    [super viewDidLoad];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView  *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.octTree.entries count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    OCTTreeEntry *content = [self.octTree.entries objectAtIndex:row];
    return content.path;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.octTreeEntry = [self.octTree.entries objectAtIndex:row];
    self.selectedLabel.text = self.octTreeEntry.path;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
//    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveNote:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    //Testing to set an attribute
    [newManagedObject setValue:self.note.text forKey:@"note"];

    [newManagedObject setValue:self.octTreeEntry.path forKey:@"filePath"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

//Fetching the latest commit, then using that sha to fetch all files in repo
- (void) fetchData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                andUserName:[defaults objectForKey:@"user"]];
    // we get the repositories
    
    [[self.octokitModel getHeadOfMaster:self.repo] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                            message:task.error.description //@"Something went wrong."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            for(OCTResponse *object in task.result) {
                OCTRef *ref = [object parsedResult];
                self.SHA = ref.SHA;
            }
            [self fetchTree];
        }
        return nil;
    }];
}

- (void)fetchTree
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.octokitModel = [[OctokitModel alloc] initWithToken:[defaults objectForKey:@"token"]
                                                andUserName:[defaults objectForKey:@"user"]];
    // we get the repositories
    
    [[self.octokitModel getTree:self.repo sha:self.SHA] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                            message:task.error.description //@"Something went wrong."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            for(OCTResponse *object in task.result) {
                self.octTree = [object parsedResult];
            }
            self.octTreeEntry = [self.octTree.entries firstObject];
            self.selectedLabel.text = self.octTreeEntry.path;
            [self.filePicker reloadAllComponents];
        }
        return nil;
    }];
}

@end
