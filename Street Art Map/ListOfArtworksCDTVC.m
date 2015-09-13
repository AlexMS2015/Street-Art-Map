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
#import "ArtworkTableViewCell.h"
#import "PhotoLibraryInterface.h"
//#import <Photos/Photos.h>

@implementation ListOfArtworksCDTVC

#pragma mark - View Life Cycle

#define CELL_IDENTIFIER @"ArtworkCell"

-(void)viewDidLoad
{
    UINib *nib = [UINib nibWithNibName:@"ArtworkTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - Implemented Abstract Methods

// subclass will set up a query for some artworks from the database
-(void)setupFetchedResultsController { }

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo"] ||
                    [segue.identifier isEqualToString:@"View Photo"]) {
        
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *addAndViewArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                addAndViewArtworkVC.context = self.context;
                
                if ([segue.identifier isEqualToString:@"View Photo"]) {
                    if ([sender isKindOfClass:[UITableViewCell class]]) {
                        UITableViewCell *selectedArtwork = (UITableViewCell *)sender;
                        NSIndexPath *pathOfSelectedArtwork = [self.tableView indexPathForCell:selectedArtwork];
                        addAndViewArtworkVC.artworkToView = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedArtwork];
                    }
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArtworkTableViewCell cellHeight];
}

// need to do this in code because using a custom cell loaded from a nib/xib
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"View Photo"
                              sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArtworkTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = artwork.title;
    cell.artistLabel.text = artwork.artist.name;
    cell.artworkImageView.image = nil;
    
    NSDateFormatter *lastEditDateFormatter = [[NSDateFormatter alloc] init];
    lastEditDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.lastEditDateLabel.text = [lastEditDateFormatter stringFromDate:artwork.lastEditDate];
    
    PhotoLibraryInterface *interface = [PhotoLibraryInterface sharedLibrary];
    
    if (cell.tag != 0) { // is the cell already loading an image and has been re-used? cancel that request if so
        [interface cancelRequestWithID:(PHImageRequestID)cell.tag];
    }
    
    cell.tag = [interface setImageInImageView:cell.artworkImageView
                   toImageWithLocalIdentifier:artwork.imageLocation
              andExecuteBlockOnceImageFetched:^{cell.tag = 0;}];
    
    return cell;
    
    /*PHImageManager *manager = [PHImageManager defaultManager];
    
    // if we are re-using a cell that has an image request going then cancel it
    if (cell.tag != 0) {
        [manager cancelImageRequest:(PHImageRequestID)cell.tag];
    }
    
    //PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    //options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[artwork.imageLocation]
                                                             options:nil];
    
    cell.tag = [manager requestImageForAsset:[result firstObject] targetSize:cell.artworkImageView.bounds.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            if (info[PHImageErrorKey]) {
                // error handling
            } else {
                // make sure cell is visible before setting image
                if ([tableView cellForRowAtIndexPath:indexPath]) {
                    cell.artworkImageView.image = result;
                    //cell.tag = 0;
                }
            }
    }];*/
}

@end
