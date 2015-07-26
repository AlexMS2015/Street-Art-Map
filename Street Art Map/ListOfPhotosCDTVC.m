//
//  ListOfPhotosCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ListOfPhotosCDTVC.h"
#import "Artwork.h"
#import "Artist.h"
#import "AddAndViewArtworkVC.h"
#import <Photos/Photos.h>

@interface ListOfPhotosCDTVC ()

@end

@implementation ListOfPhotosCDTVC

#pragma mark - Implemented Abstract Methods

-(void)setupFetchedResultsController
{

}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *addArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                addArtworkVC.context = self.context;
            }
            
        }
    } else if ([segue.identifier isEqualToString:@"View Photo"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *viewArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                viewArtworkVC.context = self.context;
                if ([sender isMemberOfClass:[UITableViewCell class]]) {
                    UITableViewCell *selectedArtwork = (UITableViewCell *)sender;
                    NSIndexPath *pathOfSelectedArtwork = [self.tableView indexPathForCell:selectedArtwork];
                    viewArtworkVC.artworkToView = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedArtwork];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

#define CELL_IDENTIFIER @"ArtworkCell"

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *artistLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *artworkImageView = (UIImageView *)[cell viewWithTag:103];
    
    titleLabel.text = artwork.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    artistLabel.text = artwork.artist.name;
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateLabel.text = [dateFormatter stringFromDate:artwork.uploadDate];
    
    if (artwork.imageLocation) {
        PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[artwork.imageLocation] options:nil];
        PHAsset *assetForArtworkImage = [result firstObject];
        [[PHImageManager defaultManager] requestImageForAsset:assetForArtworkImage
                                                   targetSize:artworkImageView.bounds.size
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (info[PHImageErrorKey]) {
                                                        // error handling
                                                    } else {
                                                        artworkImageView.image = result;
                                                    }
                                                }];
    } else {
        artworkImageView.image = nil;
    }
    
    return cell;
}

@end
