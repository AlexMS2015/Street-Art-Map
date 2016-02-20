//
//  ViewArtistsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 18/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ViewArtistsCDTVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "PhotoLibraryInterface.h"
#import "ViewArtistTVC.h"
#import "GridVC.h"
#import "ArtworkImageView.h"
#import "AddAndViewArtworkVC.h"
#import "UIAlertController+ConvinienceMethods.h"

@interface ViewArtistsCDTVC ()

@property (strong, nonatomic) NSMutableArray *artworkImageGridVCs;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation ViewArtistsCDTVC

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Artwork"] || [segue.identifier isEqualToString:@"Add Artwork"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
            if ([[nc.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *artworkView = (AddAndViewArtworkVC *)[nc.viewControllers firstObject];
                if ([sender isMemberOfClass:[Artwork class]]) { // viewing an artwork
                    [artworkView loadExistingArtwork:(Artwork *)sender];
                } else if ([sender isMemberOfClass:[Artist class]]) { // adding an artwork
                    [artworkView newArtworkWithTitle:nil andArtist:(Artist *)sender inContext:self.context];
                }
            }
        }
    }
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ViewArtistTVC" bundle:nil];
    self.navigationItem.title = @"Artists";
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData]; // reload on appearing in case user has added new artworks (fetched results controller won't pickup this change due to the cells containing collection views
}

#pragma mark - Properties

-(NSMutableArray *)artworkImageGridVCs
{
    if (!_artworkImageGridVCs) {
        _artworkImageGridVCs = [NSMutableArray array];
    }
    
    return _artworkImageGridVCs;
}

-(NSMutableDictionary *)cachedImages
{
    if (!_cachedImages) {
        _cachedImages = [NSMutableDictionary dictionary];
    }
    
    return _cachedImages;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ViewArtistTVC cellHeight];
}

#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Artist *artistToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *deleteArtistMessage = [NSString stringWithFormat:@"Are you sure you want to delete %@?", artistToDelete.name];
        
        [self presentViewController:[UIAlertController YesNoAlertWithMessage:deleteArtistMessage andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
            
            NSArray *artworksToDelete = [artistToDelete.artworks copy]; // need to hang onto this because the artist will be deleted before we can ask the user if they wish to delete the artworks!
            [artistToDelete deleteFromDatabase];
            
            if ([artworksToDelete count] > 0) {
                NSString *deleteArtworksMessage = [NSString stringWithFormat:@"Do you also want to delete %@'s artworks?", artistToDelete.name];
                
                [self presentViewController:[UIAlertController YesNoAlertWithMessage:deleteArtworksMessage andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
                    
                    for (Artwork *artwork in artworksToDelete) {
                        [artwork deleteFromDatabase];
                    }
                    
                }] animated:YES completion:NULL];
            }
        }] animated:YES completion:NULL];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewArtistTVC *viewingCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [viewingCell setTitle:artist.name andImageCount:(int)artist.artworks.count];
    
    int numArtworkCVCs = (int)[artist.artworks count] + 1;
    
    GridVC *artworkImagesCVC = [[GridVC alloc] initWithgridSize:(GridSize){1, numArtworkCVCs} collectionView:viewingCell.artworkImagesCV andCellConfigureBlock:^(UICollectionViewCell *cvc, Position position, int index) {
        
        __block UIImage *artworkImage;
        if (index < [artist.artworks count]) {
            
            Artwork *artworkToDisplayImageFor = [artist.artworks allObjects][index];
            
            // is the image for this artwork already cached?
            if (!self.cachedImages[[artworkToDisplayImageFor defaultImageLocation]]) {
                // fetch the photo and add it to the cache if not
                [[PhotoLibraryInterface shared] imageWithLocalIdentifier:[artworkToDisplayImageFor defaultImageLocation] size:cvc.bounds.size completion:^(UIImage *image) {
                    artworkImage = image;
                    if (image)
                        self.cachedImages[[artworkToDisplayImageFor defaultImageLocation]] = image;
                }];
            } else { // retrieve the image from cache
                artworkImage = self.cachedImages[[artworkToDisplayImageFor defaultImageLocation]];
            }
        } else {
            artworkImage = nil;
        }
        cvc.backgroundView = [[ArtworkImageView alloc] initWithFrame:cvc.frame
                                                            andImage:artworkImage];
        
    } andCellTapHandler:^(UICollectionViewCell *cell, Position position, int index) {
        Artwork *artworkToView;
        
        if (index < [artist.artworks count]) { // user selected an existing artwork
            artworkToView = [artist.artworks allObjects][index];
            [self performSegueWithIdentifier:@"View Artwork" sender:artworkToView];
        } else { // user selected the '+' button
            [self performSegueWithIdentifier:@"Add Artwork" sender:artist];
        }
        
    }];
    [self.artworkImageGridVCs addObject:artworkImagesCVC]; // need to hang on to the view controllers that are responsible for the collection view in each table view cell
    
    return viewingCell;
}


@end
