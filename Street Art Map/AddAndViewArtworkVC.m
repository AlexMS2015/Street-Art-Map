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
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Artist *artistForArtwork;
@property (strong, nonatomic) NSURL *URLForArtworkImage;
@property (strong, nonatomic) NSURL *URLForArtworkThumbnail;
@property (strong, nonatomic) ALAssetsLibrary *library;

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
        self.title = @"View/Edit Art";
        self.artworkTitleTextField.text = self.artworkToView.title;
        self.artistForArtwork = self.artworkToView.artist;
        self.URLForArtworkImage = [NSURL URLWithString:self.artworkToView.imageURL];
        self.URLForArtworkThumbnail = [NSURL URLWithString:self.artworkToView.thumbnailURL];
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.title = @"Add Art";
    }
}

#pragma mark - Helpers

-(void)showSingleButtonAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertController *notAvailableAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
    [notAvailableAlert addAction:okButton];
    
    [self presentViewController:notAvailableAlert animated:YES completion:NULL];
}

#pragma mark - Segues

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
        
        artworkToUpdate.title = self.artworkTitleTextField.text;
        artworkToUpdate.artist = self.artistForArtwork;
        artworkToUpdate.uploadDate = [NSDate date];
        artworkToUpdate.imageURL = [self.URLForArtworkImage absoluteString];
        
    } else if ([segue.identifier isEqualToString:@"Select Artist"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[ArtistsCDTVC class]]) {
                ArtistsCDTVC *artistSelection = (ArtistsCDTVC *)[navController.viewControllers firstObject];
                artistSelection.context = self.context;
            }
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Add Photo Unwind"]) {
        if (!self.artworkTitleTextField.text || !self.artworkImageView.image) {
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

-(ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    return _library;
}

-(void)setURLForArtworkImage:(NSURL *)URLForArtworkImage
{
    _URLForArtworkImage = URLForArtworkImage;
    
    [self.library assetForURL:URLForArtworkImage resultBlock:^(ALAsset *asset) {
        UIImage *artworkImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        self.artworkImageView.image = artworkImage;
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to load image");
    }];
}

-(void)setArtistForArtwork:(Artist *)artistForArtwork
{
    _artistForArtwork = artistForArtwork;
    self.artworkArtistTextField.text = _artistForArtwork.name;
}

#pragma mark - Actions

-(void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *fromExistingImage = [[UIImagePickerController alloc] init];
        fromExistingImage.sourceType = sourceType;
        fromExistingImage.delegate = self;
        
        [self presentViewController:fromExistingImage animated:YES completion:NULL];
    } else {
        [self showSingleButtonAlertWithMessage:@"Sorry, that option is not available on your device" andTitle:nil];
    }
}

- (IBAction)addPhotoToArtwork:(UIBarButtonItem *)sender
{
    UIAlertController *addPhotoAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    [addPhotoAlert addAction:cancelButton];
    
    UIAlertAction *fromCameraButton = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [addPhotoAlert addAction:fromCameraButton];
    
    UIAlertAction *fromExistingButton = [UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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

-(UIImage *)image:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(NSURL *)uniqueURL
{
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];    NSURL *documentDirectory = [documentDirectories firstObject];
    NSString *unique = [NSString stringWithFormat:@"%.0f", floor([NSDate timeIntervalSinceReferenceDate])];
    return [documentDirectory URLByAppendingPathComponent:unique];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info[UIImagePickerControllerReferenceURL]) {
        NSLog(@"selected an existing image");
        self.URLForArtworkImage = info[UIImagePickerControllerReferenceURL];
    } else {
        NSLog(@"took a new photo");
        
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        
        [self.library writeImageToSavedPhotosAlbum:artworkImage.CGImage
                                  orientation:ALAssetOrientationLeft
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  self.URLForArtworkImage = assetURL;
                              }];
        
        UIImage *thumbnailImage = [self image:artworkImage scaledToSize:CGSizeMake(117, 156)];
        self.URLForArtworkThumbnail = [self uniqueURL];
        NSData *imageJPEGData = UIImageJPEGRepresentation(thumbnailImage, 0.5);
        [imageJPEGData writeToURL:self.URLForArtworkThumbnail atomically:YES];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
