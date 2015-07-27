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
#import "PhotoLibraryInterface.h"
#import "ArtworkTableViewCell.h"
#import <Photos/Photos.h>

/*@interface ListOfPhotosCDTVC () <PhotoLibraryInterfaceDelegate>

@property (strong, nonatomic) PhotoLibraryInterface *photoLibInterface;
@property (strong, nonatomic) NSMutableDictionary *photosForTable;

@end*/

@implementation ListOfPhotosCDTVC

#pragma mark - View Life Cycle

#define CELL_IDENTIFIER @"ArtworkCell"

-(void)viewDidLoad
{
    UINib *nib = [UINib nibWithNibName:@"ArtworkTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - Implemented Abstract Methods

-(void)setupFetchedResultsController { }

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo"] || [segue.identifier isEqualToString:@"View Photo"]) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"View Photo"
                              sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

//#define CELL_IDENTIFIER @"ArtworkCell"

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArtworkTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.artwork = artwork;
    
    return cell;
}
    
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    /*UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = artwork.title;
    
    UILabel *artistLabel = (UILabel *)[cell viewWithTag:101];
    artistLabel.text = artwork.artist.name;
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateLabel.text = [dateFormatter stringFromDate:artwork.uploadDate];
    
    UIImageView *artworkImageView = (UIImageView *)[cell viewWithTag:103];
    NSString *location = artwork.imageLocation;
    if (location) {

        if (self.photosForTable[location]) {
            NSLog(@"image for %@ already loaded", titleLabel.text);
            artworkImageView.image = self.photosForTable[location];
        } else {
            NSLog(@"fetching image for %@", titleLabel.text);
            [self.photoLibInterface getImageForLocalIdentifier:location withSize:artworkImageView.bounds.size];
        }*/
        
        /*
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
                                                }];*/
    //}

#pragma mark - Properties

/*-(NSDictionary *)photosForTable
 {
 if (!_photosForTable) {
 _photosForTable = [NSMutableDictionary dictionary];
 }
 
 return _photosForTable;
 }
 
 -(PhotoLibraryInterface *)photoLibInterface
 {
 if (!_photoLibInterface) {
 _photoLibInterface = [[PhotoLibraryInterface alloc] init];
 _photoLibInterface.delegate = self;
 }
 
 return _photoLibInterface;
 }
 
 #pragma mark - PhotoLibraryInterfaceDelegate
 
 -(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier
 {
 self.photosForTable[identifier] = image;
 NSLog(@"dictionary: %@", self.photosForTable);
 NSLog(@"-------------");
 [self.tableView reloadData];
 }*/

@end
