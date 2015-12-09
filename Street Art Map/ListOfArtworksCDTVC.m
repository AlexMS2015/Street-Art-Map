//
//  ListOfPhotosCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ListOfArtworksCDTVC.h"
#import "Artwork.h"
#import "Artist.h"
#import "AddAndViewArtworkVC.h"
#import "ArtworkTVC.h"
#import "PhotoLibraryInterface.h"
#import "UIAlertController+TwoButtonAlertWithAction.h"
#import "Artwork+Create.h"

@implementation ListOfArtworksCDTVC

#pragma mark - View Life Cycle

#define CELL_IDENTIFIER @"ArtworkCell"

-(void)viewDidLoad
{
    // load the custom table view cell for an 'Artwork'
    UINib *nib = [UINib nibWithNibName:@"ArtworkTVC" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];

    // allow row deletion
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Implemented Abstract Methods

// subclass will set up a query for some artworks from the database
-(void)setupFetchedResultsController { }

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Artwork"] ||
                    [segue.identifier isEqualToString:@"View Artwork"]) {
        
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *addAndViewArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                //addAndViewArtworkVC.context = self.context;
                
                if ([segue.identifier isEqualToString:@"View Artwork"]) {
                    if ([sender isKindOfClass:[UITableViewCell class]]) {
                        UITableViewCell *selectedArtwork = (UITableViewCell *)sender;
                        NSIndexPath *pathOfSelectedArtwork = [self.tableView indexPathForCell:selectedArtwork];
                        [addAndViewArtworkVC loadExistingArtwork:[self.fetchedResultsController objectAtIndexPath:pathOfSelectedArtwork]];
                    }
                } else {
                    [addAndViewArtworkVC newArtworkWithTitle:nil andArtist:nil inContext:self.context];
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArtworkTVC cellHeight];
}

// need to do this in code because using a custom cell loaded from a nib/xib
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"View Artwork"
                              sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self presentViewController:[UIAlertController twoButtonAlertWithTitle:@"Delete Photo" andMessage:@"Are you sure you want to delete this photo?" andAction:^(UIAlertAction *action) {
            Artwork *artworkToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [artworkToDelete deleteFromDatabase];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }] animated:YES completion:NULL];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"refreshing table view");
    
    ArtworkTVC *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = artwork.title;
    cell.artistLabel.text = artwork.artist.name;
    cell.artworkImageView.image = nil;
    
    NSDateFormatter *lastEditDateFormatter = [[NSDateFormatter alloc] init];
    lastEditDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.lastEditDateLabel.text = [lastEditDateFormatter stringFromDate:artwork.lastEditDate];
    
    if (cell.tag != 0) // cancel any existing requests on the cell (perhaps being re-used)
        [[PhotoLibraryInterface shared] cancelRequestWithID:(PHImageRequestID)cell.tag];
    
    cell.tag = [[PhotoLibraryInterface shared] imageWithLocalIdentifier:artwork.imageLocation size:cell.artworkImageView.bounds.size completion:^(UIImage *image) {
        cell.artworkImageView.image = image;
        NSLog(@"setting image for artwork: %@ in location: %@", artwork.title, artwork.imageLocation);
        cell.tag = 0;
    }];
    
    return cell;
}

@end
