//
//  AddArtworkVC.m
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AddAndViewArtworkVC.h"
#import "Artist+CoreDataProperties.h"
#import "Artwork+CoreDataProperties.h"
#import "ImageFileLocation.h"
#import "SelectArtistCDTVC.h"
#import "PhotoLibraryInterface.h"
#import "UIAlertController+ConvinienceMethods.h"
#import "DoubleTapToZoomScrollViewDelegate.h"
#import "AddImageCollectionViewCell.h"
#import "ImageZoomCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) Artwork *artwork;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *svZoomDelegates;

// outlets
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end

@implementation AddAndViewArtworkVC

#pragma mark - Constants

static NSString * const ADD_ARTWORK_UNWINDSEG = @"Add Artwork Unwind";
static NSString * const SELECT_ARTIST_SEGUE = @"Select Artist";
static NSString * const SELECT_ARTIST_UNWINDSEG = @"Select Artist Unwind";

static NSString * const ADD_IMAGE_CELL = @"Add Image Cell";
static NSString * const IMAGE_ZOOM_CELL = @"Image Zoom Cell";

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

-(NSMutableArray *)svZoomDelegates
{
    if (!_svZoomDelegates) {
        _svZoomDelegates = [NSMutableArray array];
    }
    
    return _svZoomDelegates;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= [self.artwork.imageFileLocations count]) {
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
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"Items in CV: %ld", [self.artwork.imageFileLocations count] + 1);
    return [self.artwork.imageFileLocations count] + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", [self.artwork.imageFileLocations count]);
    if (indexPath.item < [self.artwork.imageFileLocations count]) {
        ImageZoomCollectionViewCell *cell = (ImageZoomCollectionViewCell *)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:IMAGE_ZOOM_CELL forIndexPath:indexPath];
        DoubleTapToZoomScrollViewDelegate *delegate = [[DoubleTapToZoomScrollViewDelegate alloc] initWithViewToZoom:cell.imageView inScrollView:cell.scrollView withMinZoomScale:MINIMUM_ZOOM_SCALE andMaxZoomScale:MAXIMUM_ZOOM_SCALE];
        [self.svZoomDelegates addObject:delegate];
    
        ImageFileLocation *imageLocation = self.artwork.imageFileLocations[indexPath.item];
        NSString *imageLocationIdentifier = imageLocation.fileLocation;
        
        [[PhotoLibraryInterface shared] imageWithLocalIdentifier:imageLocationIdentifier size:cell.bounds.size completion:^(UIImage *image) {
            cell.imageView.image = image;
        } cached:NO];
        
        return cell;
        
    } else {
        AddImageCollectionViewCell *cell = (AddImageCollectionViewCell *)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:ADD_IMAGE_CELL forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
 
    if (self.artwork.title) {
        self.navigationItem.title = self.artwork.title;
    }
    
    if ([self.artwork.imageFileLocations count] > 0) {
        self.navigationItem.leftBarButtonItem = nil; // if there's an image we must be viewing an existing artwork. Hence, remove the 'cancel' button present when creating an artwork.
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.imageCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.imageCollectionView.bounds.size.width, self.imageCollectionView.bounds.size.height);
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SELECT_ARTIST_SEGUE]) {
        UINavigationController *navController = (UINavigationController *)segue
        .destinationViewController;
        SelectArtistCDTVC *selectArtistVC = (SelectArtistCDTVC *)navController.viewControllers[0];
        selectArtistVC.context = self.context;
        selectArtistVC.selectedArtist = self.artwork.artist;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:ADD_ARTWORK_UNWINDSEG]) { // unwinding self
        if ([self.artwork.title length] == 0 || [self.artwork.imageFileLocations count] == 0) {
            [self presentViewController:[UIAlertController OKAlertWithMessage:@"Artwork title or image not set"] animated:YES completion:NULL];
            return NO;
        }
        if (!self.artwork.artist) {
            self.artwork.artist = [Artist artistWithName:@"No Artist" inManagedObjectContext:self.context];
        }
    }
    return YES;
}

-(void)done:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:SELECT_ARTIST_UNWINDSEG]) {
        SelectArtistCDTVC *artistSelection = (SelectArtistCDTVC *)segue.sourceViewController;
        self.artwork.artist = artistSelection.selectedArtist;
    }
}

#pragma mark - Actions

- (IBAction)changeTitle:(UIBarButtonItem *)sender
{
    UIAlertController *changeTitleAlert = [UIAlertController OKCancelAlertWithMessage:@"Please type a title for this street art" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        NSString *title = ((UITextField *)[alertVC.textFields firstObject]).text;
        if (title.length > 0) {
            self.artwork.title = title;
            self.navigationItem.title = self.artwork.title;
        }
    }];
    
    [changeTitleAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:changeTitleAlert animated:YES completion:NULL];
}

-(void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else {
        [self presentViewController:[UIAlertController OKAlertWithMessage:@"Sorry, that option is not available on your device"] animated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.artwork deleteFromDatabase];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteCurrentPhoto:(UIBarButtonItem *)sender
{
    NSIndexPath *currentlyDisplayedItemPath = self.imageCollectionView.indexPathsForVisibleItems[0];
    if ([self.artwork.imageFileLocations count] > currentlyDisplayedItemPath.item) {
        [self.artwork.imageFileLocations[currentlyDisplayedItemPath.item] deleteFromDatabase];
        [self.context save:nil];
        [self.imageCollectionView deleteItemsAtIndexPaths:@[currentlyDisplayedItemPath]];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block NSString *imageFileLocation;
    if (info[UIImagePickerControllerReferenceURL]) { // chose an existing photo
        imageFileLocation = [[PhotoLibraryInterface shared] localIdentifierForALAssetURL:info[UIImagePickerControllerReferenceURL]];
        ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:self.context];
        fileLocation.artwork = self.artwork;
    } else { // took a new photo
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
            imageFileLocation = identifier;
            ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:self.context];
            [self.artwork addImageFileLocationsObject:fileLocation];
        }];
    }
    
    NSUInteger currPhotoIdx = [self.artwork.imageFileLocations count] - 1;
    [self.imageCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:currPhotoIdx inSection:0]]];
    
    if (currPhotoIdx == 0) {
        CLLocation *location = [[PhotoLibraryInterface shared] locationForImageWithLocalIdentifier:imageFileLocation];
        self.artwork.lattitude = location.coordinate.latitude;
        self.artwork.longitude = location.coordinate.longitude;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
