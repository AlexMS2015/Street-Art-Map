//
//  ArtistsCDCVC.m
//  Street Art Map
//
//  Created by Alex Smith on 9/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ArtistsCDCVC.h"
#import "PhotoLibraryInterface.h"
#import "ArtworkCollectionViewCell.h"
#import "Artwork.h"
#import "AddAndViewArtworkVC.h"

@implementation ArtistsCDCVC

static NSString * const CELL_IDENTIFIER = @"Artwork Cell";

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArtworkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.tag != 0) // cancel any existing requests on the cell (perhaps the cell is being re-used as the user has scrolled)
        [[PhotoLibraryInterface shared] cancelRequestWithID:(PHImageRequestID)cell.tag];
    
    cell.tag = [[PhotoLibraryInterface shared] imageWithLocalIdentifier:[artwork defaultImageLocation] size:cell.imageView.bounds.size completion:^(UIImage *image) {
        cell.imageView.image = image;
        cell.tag = 0;
    } cached:NO];
    
    return cell;
}

#pragma mark - Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    
    NSSortDescriptor *artistNameSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"artist.name"
                                                                         ascending:YES];
    request.sortDescriptors = @[artistNameSortDesc];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"artist.name" cacheName:nil];
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Artwork"] || [segue.identifier isEqualToString:@"Add Artwork"]) {
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        AddAndViewArtworkVC *artworkView = (AddAndViewArtworkVC *)nc.viewControllers[0];

        if ([sender isKindOfClass:[UICollectionViewCell class]]) { // viewing an artwork
            NSIndexPath *path = [self.collectionView indexPathForCell:sender];
            Artwork *artworkToView = [self.fetchedResultsController objectAtIndexPath:path];
            [artworkView loadExistingArtwork:artworkToView];
        } else { // adding an artwork
            [artworkView newArtworkWithTitle:nil andArtist:nil inContext:self.context];
        }
    }
}

@end
