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
#import "ArtworkImageView.h"
#import "AddAndViewArtworkVC.h"
#import "CollectionViewDataSource.h"
#import "UICollectionViewFlowLayout+GridLayout.h"
#import "UIAlertController+ConvinienceMethods.h"

@interface ViewArtistsCDTVC () <UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *artworkImageDataSources;

@end

@implementation ViewArtistsCDTVC

static NSString * const CVC_IDENTIFIER = @"CollectionViewCell";

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
    
    self.tableView.allowsSelection = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData]; // reload on appearing in case user has added new artworks (fetched results controller won't pickup this change due to the cells containing collection views
}

#pragma mark - Properties

-(NSMutableArray *)artworkImageDataSources
{
    if (!_artworkImageDataSources) {
        _artworkImageDataSources = [NSMutableArray array];
    }
    
    return _artworkImageDataSources;
}

-(void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    [super setFetchedResultsController:fetchedResultsController];
    NSArray *artists = [fetchedResultsController fetchedObjects];
    
    NSMutableArray *imageIdentifiers = [NSMutableArray array];
    for (Artist *artist in artists) {
        for (Artwork *artwork in artist.artworks) {
            [imageIdentifiers addObject:[artwork defaultImageLocation]];
        }
    }
    
    [[PhotoLibraryInterface shared] cacheImagesForLocalIdentifiers:imageIdentifiers withSize:CGSizeMake(100, 100)];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger artistIndex = [self.artworkImageDataSources indexOfObject:collectionView.dataSource];
    Artist *selectedArtist = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:artistIndex inSection:0]];
    
    NSInteger artworkIndex = indexPath.item;
    if (artworkIndex < [selectedArtist.artworks count]) { // user selected an existing artwork
        Artwork *artworkToView = [selectedArtist.artworks allObjects][artworkIndex];
        [self performSegueWithIdentifier:@"View Artwork" sender:artworkToView];
    } else { // user selected the '+' button
        [self performSegueWithIdentifier:@"Add Artwork" sender:selectedArtist];
    }
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
        
    [viewingCell.artworkImagesCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVC_IDENTIFIER];
    
    CollectionViewDataSource *dataSource = [[CollectionViewDataSource alloc] initWithSections:1 itemsPerSection:numArtworkCVCs cellIdentifier:CVC_IDENTIFIER cellConfigureBlock:^(NSInteger section, NSInteger item, UICollectionViewCell *cell) {
        
        __block UIImage *artworkImage;
        if (item < [artist.artworks count]) {
            
            Artwork *artworkToDisplayImageFor = [artist.artworks allObjects][item];
            
            [[PhotoLibraryInterface shared] imageWithLocalIdentifier:[artworkToDisplayImageFor defaultImageLocation] size:cell.bounds.size completion:^(UIImage *image) {
                artworkImage = image;
            } cached:YES];
            
        } else {
            // DOES THIS EVER GET EXECUTED?
            artworkImage = nil;
        }
        cell.backgroundView = [[ArtworkImageView alloc] initWithFrame:cell.frame andImage:artworkImage andContentMode:UIViewContentModeScaleAspectFill bordered:YES];
    }];

    if ([self.artworkImageDataSources count] > indexPath.item) {
        self.artworkImageDataSources[indexPath.item] = dataSource;
    } else {
        [self.artworkImageDataSources addObject:dataSource];
    }
        
    viewingCell.artworkImagesCV.dataSource = dataSource;
    viewingCell.artworkImagesCV.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)viewingCell.artworkImagesCV.collectionViewLayout;
    [layout layoutAsGrid];

    return viewingCell;
}


@end
