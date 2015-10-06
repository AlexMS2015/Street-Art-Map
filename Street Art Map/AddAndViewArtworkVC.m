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
#import "ArtistsCDTVC.h"
#import "PhotoLibraryInterface.h"
#import "UIAlertController+SingleButtonAlert.h"
#import "Artwork+Create.h"
#import <CoreLocation/CoreLocation.h>

// denotes whether this VC is being used to create a new artwork or view an existing one
typedef enum {
    Create, Existing
} ScreenMode;

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) ScreenMode screenMode;
@property (strong, nonatomic) Artwork *artwork;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@end

@implementation AddAndViewArtworkVC

-(void)loadExistingArtwork:(Artwork *)artworkToview
{
    self.artwork = artworkToview;
    self.screenMode = Existing;
}

-(void)newArtworkWithTitle:(NSString *)title andArtist:(Artist *)artist
{
    self.artwork = [Artwork artworkWithTitle:title artist:artist inContext:self.context];
    self.screenMode = Create;
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // if the user hasn't loaded an artwork or pre-filled one then this VC must be in 'Create' mode. set up a new artwork with attributes set to nil
    if (!self.artwork) {
        self.artwork = [Artwork artworkWithTitle:nil artist:nil inContext:self.context];
        self.screenMode = Create;
    } else {
        // set up the view from the loaded or pre-filled artwork
        self.navigationItem.title = self.artwork.title;
        if (self.artwork.imageLocation) {
            [[PhotoLibraryInterface shared] imageWithLocalIdentifier:self.artwork.imageLocation size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
                self.artworkImageView.image = image;
            }];
        }
    }
    
    if (self.screenMode == Existing) { // viewing an existing artwork
        self.navigationItem.leftBarButtonItem = nil;
    } else { // creating an new artwork
        self.navigationItem.title = @"Add Art";
    }
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Artwork Unwind"]) { // rewind segue from the add artwork screen
        
#warning - NEED TO UPDATE THE ARTWORK'S GEOLOCATION - Perhaps do this when setting the image?

    } else if ([segue.identifier isEqualToString:@"Select Artist"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[ArtistsCDTVC class]]) {
                ArtistsCDTVC *artistSelection = (ArtistsCDTVC *)[navController.viewControllers firstObject];
                artistSelection.context = self.context;
                artistSelection.screenMode = SelectionMode;
                artistSelection.selectedArtist = self.artwork.artist;
            }
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Add Artwork Unwind"]) {
        if ([self.artwork.title length] == 0 || !self.artwork.imageLocation) {
            [self presentViewController:[UIAlertController singleButtonAlertWithMessage:@"Photo title or image not set"] animated:YES completion:NULL];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)changeTitle:(UIBarButtonItem *)sender
{
    UIAlertController *changeTitleAlert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Please type a title for this street art" preferredStyle:UIAlertControllerStyleAlert];
    
    [changeTitleAlert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:NULL]];
    
#warning THIS MIGHT CREATE A STRONG REFERECNE CYCLE
    
    [changeTitleAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *title = ((UITextField *)[changeTitleAlert.textFields firstObject]).text;
        self.artwork.title = title;
        self.navigationItem.title = self.artwork.title;
    }]];
    
    [changeTitleAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:changeTitleAlert animated:YES completion:NULL];
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Select Artist Unwind"]) {
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
        [self presentViewController:[UIAlertController singleButtonAlertWithMessage:@"Sorry, that option is not available on your device"] animated:YES completion:NULL];
    }
}

- (IBAction)addPhotoToArtwork:(UIBarButtonItem *)sender
{
    UIAlertController *addPhotoAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    [addPhotoAlert addAction:cancelButton];
    
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [self presentViewController:addPhotoAlert animated:YES completion:NULL];
}

- (IBAction)deleteCurrentArtwork:(UIBarButtonItem *)sender
{
    [self.artwork deleteFromDatabase];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#warning - Should the following line be at the end of the method of start?
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (info[UIImagePickerControllerReferenceURL]) { // chose an existing photo
        self.artwork.imageLocation = [[PhotoLibraryInterface shared] localIdentifierForALAssetURL:info[UIImagePickerControllerReferenceURL]];
    } else { // took a new photo
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
            self.artwork.imageLocation = identifier;
        }];
    }
#warning - THIS CODE IS RUBBISH
    [[PhotoLibraryInterface shared] imageWithLocalIdentifier:self.artwork.imageLocation size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
        self.artworkImageView.image = image;
    }];
    CLLocation *location = [[PhotoLibraryInterface shared] locationForImageWithLocalIdentifier:self.artwork.imageLocation];
    self.artwork.lattitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    self.artwork.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
