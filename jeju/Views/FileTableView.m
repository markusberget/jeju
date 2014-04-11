//
//  FileTableView.m
//  jeju
//
//  Created by Davíð Arnarsson on 10/04/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "FileTableView.h"

@implementation FileTableView

@synthesize files = _files;

-(void) setFiles:(NSArray *)files
{
    if (_files != files) {
        _files = files;
        
        [self configure];
    }
}

-(void) configure
{
    [self setDataSource: self];
    [self reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return _files ? _files.count : 0;
}

-(NSInteger)tableView:(UITableView *)numberOfSections
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _files ? _files.count : 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"fileCell";
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    
    OCTGitCommitFile * file = [_files objectAtIndex:indexPath.row];
    
    cell.textLabel.text = file.filename;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%d ±%d -%d", file.countOfAdditions, file.countOfChanges, file.countOfDeletions];
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Modified files";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
