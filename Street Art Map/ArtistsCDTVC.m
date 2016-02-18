//
//  ArtistsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtistsCDTVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "PhotoLibraryInterface.h"
#import "ViewArtistTVC.h"
#import "SelectArtistTVC.h"
#import "GridVC.h"
#import "ArtworkImageView.h"
#import "AddAndViewArtworkVC.h"
#import "UIAlertController+ConvinienceMethods.h"

@interface ArtistsCDTVC ()
@property (strong, nonatomic) NSMutableArray *artworkImageGridVCs;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;
@end

@implementation ArtistsCDTVC

#pragma mark - Constants

static NSString * const CELL_IDENTIFIER = @"ArtistTableViewCell";

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

-(void)setSelectedArtist:(Artist *)selectedArtist
{
    _selectedArtist = selectedArtist;
    self.screenMode = SelectionMode;
    
#warning - THIS CODE DOES NOT WORK
    NSIndexPath *pathOfSelectedArtist = [self.fetchedResultsController indexPathForObject:self.selectedArtist];
    [self.tableView scrollToRowAtIndexPath:pathOfSelectedArtist atScrollPosition:UITableViewScrollPositionNone animated:NO];
    NSLog(@"path of selected artist %@ is %ld", _selectedArtist.name, (long)pathOfSelectedArtist.row);
}

-(void)setScreenMode:(ArtistScreenMode)screenMode
{
    _screenMode = screenMode;
    
    // load the correct type of cell depending on whether we are in selection or viewing mode
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
    
    // allow row deletion
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData]; // reload on appearing in case user has added new artworks
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

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.screenMode == SelectionMode;
}

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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self presentViewController:[UIAlertController YesNoAlertWithMessage:@"Are you sure you want to delete this artist (the attached photos will not be deleted)?" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
            Artist *artistToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [artistToDelete deleteFromDatabase];
            //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }] animated:YES completion:NULL];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];

    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.screenMode == ViewingMode) {
        ViewArtistTVC *viewingCell = (ViewArtistTVC *)cell;
        [viewingCell setTitle:artist.name andImageCount:(int)artist.artworks.count];
        
        int numArtworkCVCs = (int)[artist.artworks count] + 1;
        
        GridVC *artworkImagesCVC = [[GridVC alloc] initWithgridSize:(GridSize){1, numArtworkCVCs} collectionView:viewingCell.artworkImagesCV andCellConfigureBlock:^(UICollectionViewCell *cvc, Position position, int index) {
     
#warning - Make a separate 'imageCache' class?
            
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
    } else {
        SelectArtistTVC *selectionCell = (SelectArtistTVC *)cell;
        selectionCell.titleLabel.text = artist.name;
        selectionCell.selected = [self.selectedArtist isEqualToArtist:artist];
        /*if ([self.selectedArtist isEqualToArtist:artist]) {
            NSLog(@"highlight: %@", artist.name);
            selectionCell.selected = YES;
        } else {
            NSLog(@"UN-highlight: %@", artist.name);
            selectionCell.selected = NO;
        }*/
    }
    
    return cell;
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { [self.tableView reloadData]; }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Artist Unwind"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cellSelected = (UITableViewCell *)sender;
            NSIndexPath *pathOfSelectedCell = [self.tableView indexPathForCell:cellSelected];
            self.selectedArtist = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedCell];
        }
    } else if ([segue.identifier isEqualToString:@"View Artwork"] ||
               [segue.identifier isEqualToString:@"Add Artwork"]) {
        
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
            if ([[nc.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *artworkView = (AddAndViewArtworkVC *)[nc.viewControllers firstObject];
                //artworkView.context = self.context;
                if ([sender isMemberOfClass:[Artwork class]]) { // viewing an artwork
                    [artworkView loadExistingArtwork:(Artwork *)sender];
                } else if ([sender isMemberOfClass:[Artist class]]) { // adding an artwork
                    [artworkView newArtworkWithTitle:nil andArtist:(Artist *)sender inContext:self.context];
                }
            }
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
    UIAlertController *newArtistAlert = [UIAlertController OKCancelAlertWithMessage:@"Please type the artist's name" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        NSString *newArtistName = ((UITextField *)[alertVC.textFields firstObject]).text;
        self.selectedArtist = [Artist artistWithName:newArtistName inManagedObjectContext:self.context];
        
        if (self.screenMode == SelectionMode)
            [self performSegueWithIdentifier:@"Select Artist Unwind" sender:newArtistAlert];
    }];
    
    [newArtistAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:newArtistAlert animated:YES completion:NULL];
}

@end
