//
//  AddArtworkVC.m
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AddAndViewArtworkVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "Location.h"
#import "ImageFileLocation.h"
#import "ArtistsCDTVC.h"
#import "PhotoLibraryInterface.h"
#import "UIAlertController+ConvinienceMethods.h"
#import "DoubleTapToZoomScrollViewDelegate.h"
#import "GridVC.h"
#import <CoreLocation/CoreLocation.h>

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Artwork *artwork;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) DoubleTapToZoomScrollViewDelegate *svZoomDelegate;
@property (strong, nonatomic) GridVC *scrollingImagesGridVC;
@property (nonatomic) int indexOfCurrentlyDisplayedPhoto;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButtonItem;
@property (weak, nonatomic) IBOutlet UIScrollView *artworkScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCV;

@end

@implementation AddAndViewArtworkVC

#pragma mark - Constants

static NSString * const ADD_ARTWORK_UNWINDSEG = @"Add Artwork Unwind";
static NSString * const SELECT_ARTIST_SEGUE = @"Select Artist";
static NSString * const SELECT_ARTIST_UNWINDSEG = @"Select Artist Unwind";
static const int MINIMUM_ZOOM_SCALE = 1;
static const int MAXIMUM_ZOOM_SCALE = 4;

-(void)loadExistingArtwork:(Artwork *)artworkToview
{
    self.artwork = artworkToview;
    self.context = artworkToview.managedObjectContext;
}

-(void)newArtworkWithTitle:(NSString *)title andArtist:(Artist *)artist inContext:(NSManagedObjectContext *)context
{
    self.artwork = [Artwork artworkWithTitle:title artist:artist inContext:context];
    self.context = context;
}

#pragma mark - Properties

-(void)setIndexOfCurrentlyDisplayedPhoto:(int)indexOfCurrentlyDisplayedPhoto
{
    _indexOfCurrentlyDisplayedPhoto = indexOfCurrentlyDisplayedPhoto;
    
    if (self.indexOfCurrentlyDisplayedPhoto >=0) {
        ImageFileLocation *imageLocation = self.artwork.imageFileLocations[self.indexOfCurrentlyDisplayedPhoto];
        NSString *imageLocationIdentifier = imageLocation.fileLocation;
        [[PhotoLibraryInterface shared] imageWithLocalIdentifier:imageLocationIdentifier size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
            self.artworkImageView.image = image;
        }];
        [self.imageCV reloadData];
    }
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.artwork.title) {
        self.navigationItem.title = self.artwork.title;
    }
    
    self.indexOfCurrentlyDisplayedPhoto = -1;
    if ([self.artwork.imageFileLocations count] > 0) {
        self.indexOfCurrentlyDisplayedPhoto = 0;
        self.navigationItem.leftBarButtonItem = nil; // if there's an image we must be viewing an existing artwork. Hence, remove the 'cancel' button present when creating an artwork.
    } else {
        self.deleteBarButtonItem.tintColor = [UIColor clearColor];
        self.deleteBarButtonItem.enabled = NO;
    }
    
    self.svZoomDelegate = [[DoubleTapToZoomScrollViewDelegate alloc] initWithViewToZoom:self.artworkImageView inScrollView:self.artworkScrollView withMinZoomScale:MINIMUM_ZOOM_SCALE andMaxZoomScale:MAXIMUM_ZOOM_SCALE];
    
    self.scrollingImagesGridVC = [[GridVC alloc] initWithgridSize:(GridSize){1, 3} collectionView:self.imageCV andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, int index) {
        ImageFileLocation *imageLocation = self.artwork.imageFileLocations[index];
        NSString *imageLocationIdentifier = imageLocation.fileLocation;
        NSLog(@"hi");
        [[PhotoLibraryInterface shared] imageWithLocalIdentifier:imageLocationIdentifier size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:image];
        }];
    } andCellTapHandler:^(UICollectionViewCell *cell, Position position, int index) {
        NSLog(@"tapped");
    }];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SELECT_ARTIST_SEGUE]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[ArtistsCDTVC class]]) {
                ArtistsCDTVC *selectArtistVC = (ArtistsCDTVC *)[navController.viewControllers firstObject];
                selectArtistVC.context = self.context;
                selectArtistVC.screenMode = SelectionMode;
                selectArtistVC.selectedArtist = self.artwork.artist;
            }
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:ADD_ARTWORK_UNWINDSEG]) {
        if ([self.artwork.title length] == 0 || [self.artwork.imageFileLocations count] == 0) {
            [self presentViewController:[UIAlertController OKAlertWithMessage:@"Artwork title or image not set"] animated:YES completion:NULL];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Actions

-(IBAction)lastPhoto:(UIBarButtonItem *)sender
{
    if (self.indexOfCurrentlyDisplayedPhoto > 0) {
        self.indexOfCurrentlyDisplayedPhoto--;
    }
}

-(IBAction)nextPhoto:(UIBarButtonItem *)sender
{
    if (self.indexOfCurrentlyDisplayedPhoto < [self.artwork.imageFileLocations count] - 1) {
        self.indexOfCurrentlyDisplayedPhoto++;
    }
}

- (IBAction)changeTitle:(UIBarButtonItem *)sender
{
    UIAlertController *changeTitleAlert = [UIAlertController OKCancelAlertWithMessage:@"Please type a title for this street art" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        NSString *title = ((UITextField *)[alertVC.textFields firstObject]).text;
        self.artwork.title = title;
        self.navigationItem.title = self.artwork.title;
    }];
    
    [changeTitleAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:changeTitleAlert animated:YES completion:NULL];
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:SELECT_ARTIST_UNWINDSEG]) {
        if ([segue.sourceViewController isMemberOfClass:[ArtistsCDTVC class]]) {
            ArtistsCDTVC *artistSelection = (ArtistsCDTVC *)segue.sourceViewController;
            self.artwork.artist = artistSelection.selectedArtist;
        }
    }
}

-(void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        //imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else {
        [self presentViewController:[UIAlertController OKAlertWithMessage:@"Sorry, that option is not available on your device"] animated:YES completion:NULL];
    }
}

- (IBAction)addPhotoToArtwork:(UIBarButtonItem *)sender
{
    UIAlertController *addPhotoAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [self presentViewController:addPhotoAlert animated:YES completion:NULL];
}

-(void)deleteAndExit
{
    [self.artwork deleteFromDatabase];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self deleteAndExit];
}

- (IBAction)deleteCurrentArtwork:(UIBarButtonItem *)sender
{
    [self presentViewController:[UIAlertController YesNoAlertWithMessage:@"Are you sure you want to delete this artwork?" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        [self deleteAndExit];
    }] animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block NSString *imageFileLocation;
    if (info[UIImagePickerControllerReferenceURL]) { // chose an existing photo
        imageFileLocation = [[PhotoLibraryInterface shared] localIdentifierForALAssetURL:info[UIImagePickerControllerReferenceURL]];
        ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:self.context];
        [self.artwork addImageFileLocationsObject:fileLocation];
        
        self.indexOfCurrentlyDisplayedPhoto++;
        /*[[PhotoLibraryInterface shared] imageWithLocalIdentifier:imageFileLocation size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
            self.artworkImageView.image = image;
        }];*/
    } else { // took a new photo
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
            imageFileLocation = identifier;
            ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:self.context];
            [self.artwork addImageFileLocationsObject:fileLocation];
        }];
        self.artworkImageView.image = artworkImage;
    }
    self.artworkScrollView.zoomScale = MINIMUM_ZOOM_SCALE;

    if (self.indexOfCurrentlyDisplayedPhoto == 0) {
        CLLocation *location = [[PhotoLibraryInterface shared] locationForImageWithLocalIdentifier:imageFileLocation];
        self.artwork.location.lattitude = location.coordinate.latitude;
        self.artwork.location.longitude = location.coordinate.longitude;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
