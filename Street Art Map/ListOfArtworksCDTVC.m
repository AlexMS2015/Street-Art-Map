//
//  ListOfPhotosCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ListOfArtworksCDTVC.h"
#import "Artwork.h"
#import "Artwork+Create.h"
#import "Artist.h"
#import "AddAndViewArtworkVC.h"
#import "ArtworkTVC.h"
#import "PhotoLibraryInterface.h"
#import "UIAlertController+ConvinienceMethods.h"

@implementation ListOfArtworksCDTVC

#pragma mark - Constants

static NSString * const CELL_IDENTIFIER = @"ArtworkCell";
static NSString * const ADD_ARTWORK_SEGUE = @"Add Artwork";
static NSString * const VIEW_ARTWORK_SEGUE = @"View Artwork";

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    // load the custom table view cell for an 'Artwork'
    UINib *nib = [UINib nibWithNibName:@"ArtworkTVC" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];

    // allow row deletion
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_ARTWORK_SEGUE] || [segue.identifier isEqualToString:VIEW_ARTWORK_SEGUE]) {
        
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *addAndViewArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                
                if ([segue.identifier isEqualToString:VIEW_ARTWORK_SEGUE]) {
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
        [self presentViewController:[UIAlertController YesNoAlertWithMessage:@"Are you sure you want to delete this artwork?" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
            Artwork *artworkToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [artworkToDelete deleteFromDatabase];
        }] animated:YES completion:NULL];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArtworkTVC *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = artwork.title;
    cell.artistLabel.text = artwork.artist.name;
    cell.artworkImageView.image = nil;
    
    NSDateFormatter *lastEditDateFormatter = [[NSDateFormatter alloc] init];
    lastEditDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.lastEditDateLabel.text = [lastEditDateFormatter stringFromDate:artwork.lastEditDate];
    
    if (cell.tag != 0) // cancel any existing requests on the cell (perhaps the cell is being re-used as the user has scrolled)
        [[PhotoLibraryInterface shared] cancelRequestWithID:(PHImageRequestID)cell.tag];
    
    cell.tag = [[PhotoLibraryInterface shared] imageWithLocalIdentifier:artwork.imageLocation size:cell.artworkImageView.bounds.size completion:^(UIImage *image) {
        cell.artworkImageView.image = image;
        cell.tag = 0;
    }];
    
    return cell;
}

@end
