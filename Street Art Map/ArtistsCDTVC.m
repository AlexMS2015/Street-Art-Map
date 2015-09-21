//
//  ArtistsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtistsCDTVC.h"
#import "Artist.h"
#import "Artist+Equality.h"
#import "Artist+Create.h"
#import "ArtworksForArtistCDTVC.h"
#import "Artwork.h"
#import "PhotoLibraryInterface.h"
#import "ViewArtistTVC.h"
#import "SelectArtistTVC.h"
#import "GridVC.h"
#import "ArtworkImageView.h"
#import "AddAndViewArtworkVC.h"
#import "Artwork+Update.h"

@interface ArtistsCDTVC ()
@property (strong, nonatomic) NSMutableArray *artworkImageGridVCs;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;
@end

@implementation ArtistsCDTVC

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

#define CELL_IDENTIFIER @"ArtistTableViewCell"
-(void)setScreenMode:(ArtistScreenMode)screenMode
{
    _screenMode = screenMode;
    UINib *nib;
    if (self.screenMode == ViewingMode) {
        nib = [UINib nibWithNibName:@"ViewArtistTVC" bundle:nil];
        self.navigationItem.title = @"Artists";
    } else if (self.screenMode == SelectionMode) {
        nib = [UINib nibWithNibName:@"SelectArtistTVC" bundle:nil];
        self.navigationItem.title = @"Select Artist";
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    self.screenMode = ViewingMode;
}

#pragma mark - Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[nameSort];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.screenMode == ViewingMode ?
        [ViewArtistTVC cellHeight] : [SelectArtistTVC cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.screenMode == SelectionMode)
        [self performSegueWithIdentifier: @"Select Artist Unwind" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning - The table should auto scroll to the selected artist if in selection mode (might be offscreen)
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];

    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if (self.screenMode == ViewingMode) {
        ViewArtistTVC *viewingCell = (ViewArtistTVC *)cell;
        [viewingCell setTitle:artist.name andImageCount:(int)artist.artworks.count];
        
        int numArtworkCVCs = [artist.artworks count] + 1;
        
        GridVC *artworkImagesCVC = [[GridVC alloc] initWithgridSize:(GridSize){1, numArtworkCVCs} collectionView:viewingCell.artworkImagesCV andCellConfigureBlock:^(UICollectionViewCell *cvc, Position position, int index) {
     
#warning - Make a separate 'imageCache' class?
            
            __block UIImage *artworkImage;
            if (index < [artist.artworks count]) {
                
                Artwork *artworkToDisplayImageFor = [artist.artworks allObjects][index];
                
                // is the image for this artwork already cached?
                if (!self.cachedImages[artworkToDisplayImageFor.imageLocation]) {
                    // fetch the photo and add it to the cache if not
                    [[PhotoLibraryInterface shared] imageWithLocalIdentifier:artworkToDisplayImageFor.imageLocation size:cvc.bounds.size completion:^(UIImage *image) {
                        artworkImage = image;
                        if (image)
                            self.cachedImages[artworkToDisplayImageFor.imageLocation] = image;
                    }];
                } else { // retrieve the image from cache
                    artworkImage = self.cachedImages[artworkToDisplayImageFor.imageLocation];
                }
            } else {
                artworkImage = nil;
            }
            cvc.backgroundView = [[ArtworkImageView alloc] initWithFrame:cvc.frame
                                                                andImage:artworkImage];
            
        } andCellTapHandler:^(UICollectionViewCell *cell, Position position, int index) {
            Artwork *artworkToView;
            
            if (index < [artist.artworks count]) {
                artworkToView = [artist.artworks allObjects][index];
            } else {
                artworkToView = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"inManagedObjectContext:self.context];
                artworkToView.artist = artist;
            }
            
            [self performSegueWithIdentifier:@"Add or View Artwork" sender:artworkToView];

            
        }];
        [self.artworkImageGridVCs addObject:artworkImagesCVC]; // need to hang on to the view controllers that are responsible for the collection view in each table view cell
    } else {
        SelectArtistTVC *selectionCell = (SelectArtistTVC *)cell;
        selectionCell.titleLabel.text = artist.name;
        selectionCell.selected = [self.selectedArtist isEqualToArtist:artist];
    }
    
    return cell;
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cellSelected = (UITableViewCell *)sender;
        NSIndexPath *pathOfSelectedCell = [self.tableView indexPathForCell:cellSelected];
        self.selectedArtist = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedCell];
    } else {
        if ([segue.identifier isEqualToString:@"Add or View Artwork"]) {
            UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
            AddAndViewArtworkVC *artworkView = (AddAndViewArtworkVC *)[nc.viewControllers firstObject];
            
            Artwork *artworkToView = (Artwork *)sender;
            artworkView.artworkToView = artworkToView;
            artworkView.context = self.context;
        }
    }
}

#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addArtist:(UIBarButtonItem *)sender
{
    UIAlertController *newArtistAlert = [UIAlertController alertControllerWithTitle:@"New Artist" message:@"Please type the artist's name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:NULL];
    [newArtistAlert addAction:cancelAction];
    
#warning THIS MIGHT CREATE A STRONG REFERECNE CYCLE
    
    UIAlertAction *addArtistAction = [UIAlertAction actionWithTitle:@"Add"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
            NSString *newArtistName = ((UITextField *)[newArtistAlert.textFields firstObject]).text;
            self.selectedArtist = [Artist artistWithName:newArtistName inManagedObjectContext:self.context];
            
            if (self.screenMode == SelectionMode)
                [self performSegueWithIdentifier:@"Select Artist Unwind" sender:newArtistAlert];
    }];
    [newArtistAlert addAction:addArtistAction];
    
    [newArtistAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:newArtistAlert animated:YES completion:NULL];
}

@end
