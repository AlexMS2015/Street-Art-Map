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
#import <CoreLocation/CoreLocation.h>

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, PhotoLibraryInterfaceDelegate>

@property (strong, nonatomic) Artist *artistForArtwork;
@property (strong, nonatomic) NSString *localIdentifierForArtworkImage;
@property (strong, nonatomic) CLLocation *locationForArtworkImage;
@property (strong, nonatomic) PhotoLibraryInterface *photoLibInterface;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UITextField *artworkArtistTextField;
@property (weak, nonatomic) IBOutlet UITextField *artworkTitleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation AddAndViewArtworkVC

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    if (self.artworkToView) {
        self.artworkTitleTextField.text = self.artworkToView.title;
        self.artistForArtwork = self.artworkToView.artist;
        
        if (self.artworkToView.imageLocation)
            self.localIdentifierForArtworkImage = self.artworkToView.imageLocation;
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = @"View/Edit Art";
    } else {
        self.navigationItem.title = @"Add Art";
    }
}

#pragma mark - Helpers

#warning THIS SHOULD BE A CATEGORY ON THE UIALERTCONTROLLER CLASS
-(void)showSingleButtonAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:NULL];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - Segues

-(void)updateArtworkFromView:(Artwork *)artworkToUpdate
{
    
    // THIS METHOD SHOULD BE IN A CATEGORY ON THE ARTIST CLASS !!!
    
    BOOL changesMade = NO;
    
    // has the title changed?
    if (![artworkToUpdate.title isEqualToString:self.artworkTitleTextField.text]) {
        artworkToUpdate.title = self.artworkTitleTextField.text;
        changesMade = YES;
    }
    
    // has the artist changed?
    if (artworkToUpdate.artist != self.artistForArtwork) {
        artworkToUpdate.artist = self.artistForArtwork;
        changesMade = YES;
    }
    
    // has the image changed?
    if (![artworkToUpdate.imageLocation isEqualToString:self.localIdentifierForArtworkImage]) {
        artworkToUpdate.imageLocation = self.localIdentifierForArtworkImage;
        artworkToUpdate.lattitude = [NSNumber numberWithDouble:self.locationForArtworkImage.coordinate.latitude];
        artworkToUpdate.longitude = [NSNumber numberWithDouble:self.locationForArtworkImage.coordinate.longitude];
        artworkToUpdate.imageUploadDate = [NSDate date];
        changesMade = YES;
    }
    
    if (changesMade) {
        artworkToUpdate.lastEditDate = [NSDate date];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo Unwind"]) {
        Artwork *artworkToUpdate;
        
        if (!self.artworkToView) {
            artworkToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                                                inManagedObjectContext:self.context];
        } else {
            artworkToUpdate = self.artworkToView;
        }
        
        [self updateArtworkFromView:artworkToUpdate];
    
    } else if ([segue.identifier isEqualToString:@"Select Artist"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[ArtistsCDTVC class]]) {
                ArtistsCDTVC *artistSelection = (ArtistsCDTVC *)[navController.viewControllers firstObject];
                artistSelection.context = self.context;
                artistSelection.screenMode = SelectionMode;
                artistSelection.selectedArtist = self.artistForArtwork;
            }
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Add Photo Unwind"]) {
        if ([self.artworkTitleTextField.text length] == 0 || !self.artworkImageView.image) {
            [self showSingleButtonAlertWithMessage:@"Photo title or image not set" andTitle:nil];
            return NO;
        }
    }

    return YES;
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Select Artist Unwind"]) {
        if ([segue.sourceViewController isMemberOfClass:[ArtistsCDTVC class]]) {
            ArtistsCDTVC *artistSelection = (ArtistsCDTVC *)segue.sourceViewController;
            self.artistForArtwork = artistSelection.selectedArtist;
        }
    }
}

#pragma mark - Properties

-(PhotoLibraryInterface *)photoLibInterface
{
    if (!_photoLibInterface) {
        _photoLibInterface = [[PhotoLibraryInterface alloc] init];
        _photoLibInterface.delegate = self;
    }
    
    return _photoLibInterface;
}

-(void)setArtistForArtwork:(Artist *)artistForArtwork
{
    _artistForArtwork = artistForArtwork;
    self.artworkArtistTextField.text = _artistForArtwork.name;
}

-(void)setLocalIdentifierForArtworkImage:(NSString *)localIdentifierForArtworkImage
{
    _localIdentifierForArtworkImage = localIdentifierForArtworkImage;
    
    [[PhotoLibraryInterface sharedLibrary] setImageInImageView:self.artworkImageView
                                    toImageWithLocalIdentifier:self.localIdentifierForArtworkImage
                               andExecuteBlockOnceImageFetched:^{}];

}

-(CLLocation *)locationForArtworkImage
{
    if (self.localIdentifierForArtworkImage) {
        return [self.photoLibInterface locationForImageWithLocalIdentifier:self.localIdentifierForArtworkImage];
    } else {
        return [[CLLocation alloc] init];
    }
}

#pragma mark - Actions

-(void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else {
        [self showSingleButtonAlertWithMessage:@"Sorry, that option is not available on your device"
                                      andTitle:nil];
    }
}

- (IBAction)addPhotoToArtwork:(UIBarButtonItem *)sender
{
    UIAlertController *addPhotoAlert =
            [UIAlertController alertControllerWithTitle:nil
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    [addPhotoAlert addAction:cancelButton];
    
    UIAlertAction *fromCameraButton = [UIAlertAction actionWithTitle:@"Take photo"
                                                               style:UIAlertActionStyleDefault handler:
                                       ^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [addPhotoAlert addAction:fromCameraButton];
    
    UIAlertAction *fromExistingButton = [UIAlertAction actionWithTitle:@"Choose photo"
                                                                 style:UIAlertActionStyleDefault handler:
                                         ^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [addPhotoAlert addAction:fromExistingButton];
    
    [self presentViewController:addPhotoAlert animated:YES completion:NULL];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info[UIImagePickerControllerReferenceURL]) {
        self.localIdentifierForArtworkImage = [self.photoLibInterface localIdentifierForALAssetURL:info[UIImagePickerControllerReferenceURL]];
    } else {
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        [self.photoLibInterface getLocalIdentifierForImage:artworkImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - PhotoLibraryInterfaceDelegate

-(void)localIdentifier:(NSString *)identifier forProvidedImage:(UIImage *)image
{
    self.localIdentifierForArtworkImage = identifier;
}

@end
