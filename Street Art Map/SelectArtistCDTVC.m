//
//  SelectArtistCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 18/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "SelectArtistCDTVC.h"
#import "Artist.h"
#import "SelectArtistTVC.h"

@interface SelectArtistCDTVC ()

@end

@implementation SelectArtistCDTVC

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Artist Unwind"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cellSelected = (UITableViewCell *)sender;
            NSIndexPath *pathOfSelectedCell = [self.tableView indexPathForCell:cellSelected];
            self.selectedArtist = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedCell];
        }
    }
}

#pragma mark - View Life Cycle
    
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SelectArtistTVC" bundle:nil];
    self.navigationItem.title = @"Select Artist";
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void)setSelectedArtist:(Artist *)selectedArtist
{
    _selectedArtist = selectedArtist;
    
#warning - THIS CODE DOES NOT WORK
    NSIndexPath *pathOfSelectedArtist = [self.fetchedResultsController indexPathForObject:self.selectedArtist];
    [self.tableView scrollToRowAtIndexPath:pathOfSelectedArtist atScrollPosition:UITableViewScrollPositionNone animated:NO];
    NSLog(@"path of selected artist %@ is %ld", self.selectedArtist.name, (long)pathOfSelectedArtist.row);
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectArtistTVC cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"Select Artist Unwind" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectArtistTVC *selectionCell  = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    selectionCell.titleLabel.text = artist.name;
    selectionCell.selected = [self.selectedArtist isEqualToArtist:artist];
    /*if ([self.selectedArtist isEqualToArtist:artist]) {
     NSLog(@"highlight: %@", artist.name);
     selectionCell.selected = YES;
     } else {
     NSLog(@"UN-highlight: %@", artist.name);
     selectionCell.selected = NO;
     }*/
    
    return selectionCell;
}

#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)addedArtist:(Artist *)artist
{
    self.selectedArtist = artist;
    [self performSegueWithIdentifier:@"Select Artist Unwind" sender:nil];
}

@end
