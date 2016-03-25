//
//  SelectArtistCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 18/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "SelectArtistCDTVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "UIAlertController+ConvinienceMethods.h"

@implementation SelectArtistCDTVC

static NSString * const SELECT_ARTIST_CELL = @"Select Artist Cell";

#pragma mark - Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[nameSort];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - Actions

- (IBAction)addArtist:(UIBarButtonItem *)sender
{
    UIAlertController *newArtistAlert = [UIAlertController OKCancelAlertWithMessage:@"Please type the artist's name" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        NSString *newArtistName = ((UITextField *)[alertVC.textFields firstObject]).text;
        if (newArtistName.length > 0) {
            Artist *newArtist = [Artist artistWithName:newArtistName inManagedObjectContext:self.context];
            self.selectedArtist = newArtist;
            [self performSegueWithIdentifier:@"Select Artist Unwind" sender:nil];
        }
    }];
    
    [newArtistAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:newArtistAlert animated:YES completion:NULL];
}

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

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];

    UITableViewCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:SELECT_ARTIST_CELL];
    UILabel *artistNameLabel = (UILabel *)[cell viewWithTag:1];
    artistNameLabel.text = artist.name;
    
    return cell;
}

#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
