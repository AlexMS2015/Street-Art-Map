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

typedef enum {
    Create, Existing
} CreateArtworkScreenMode;

@interface AddAndViewArtworkVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

// properties for the artwork that a user is viewing or adding
@property (strong, nonatomic) NSString *titleForArtwork;
@property (strong, nonatomic) Artist *artistForArtwork;
@property (strong, nonatomic) NSString *localIdentifierForArtworkImage;
@property (strong, nonatomic) CLLocation *locationForArtworkImage;
@property (nonatomic) CreateArtworkScreenMode screenMode;
@property (strong, nonatomic) Artwork *artworkToView;
@property (strong, nonatomic) Artwork *artwork;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UITextField *artworkArtistTextField;
@property (weak, nonatomic) IBOutlet UITextField *artworkTitleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation AddAndViewArtworkVC

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"managed object changed");
    }];
}

-(void)loadExistingArtwork:(Artwork *)artworkToview
{
    //self.artworkToView = artworkToview;
    self.artwork = artworkToview;
    self.screenMode = Existing;
}

-(void)newArtworkWithTitle:(NSString *)title andArtist:(Artist *)artist
{
    //self.artworkToView = [Artwork artworkWithTitle:title artist:artist inContext:self.context];
    self.artwork = [Artwork artworkWithTitle:title artist:artist inContext:self.context];
    self.screenMode = Create;
}

#pragma mark - View Life Cycle

-(void)setViewFromCurrentArtwork
{
    self.titleForArtwork = self.artwork.title;
    self.artworkArtistTextField.text = self.artwork.artist.name;
    if (self.artwork.imageLocation) {
        [[PhotoLibraryInterface shared] imageWithLocalIdentifier:self.localIdentifierForArtworkImage size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
            self.artworkImageView.image = image;
        }];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.artwork) {
        self.artwork = [Artwork artworkWithTitle:nil artist:nil inContext:self.context];
    }
    
    [self setViewFromCurrentArtwork];

    /*if (self.artworkToView) {
        self.artworkTitleTextField.text = self.artworkToView.title;
        self.artistForArtwork = self.artworkToView.artist;
        
        if (self.artworkToView.imageLocation) {
            self.localIdentifierForArtworkImage = self.artworkToView.imageLocation;
            NSLog(@"loading image for existing artwork");
        }
    }*/
    
    if (self.screenMode == Existing) { // viewing an existing artwork
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = @"View/Edit Art";
    } else { // creating an new artwork
        self.navigationItem.title = @"Add Art";
    }
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Artwork Unwind"]) { // rewind segue from the add artwork screen
        /*Artwork *artworkToUpdate;
        if (!self.artworkToView) {
            artworkToUpdate = [Artwork artworkWithTitle:self.artworkTitleTextField.text artist:self.artistForArtwork inContext:self.context];
        } else {
            artworkToUpdate = self.artworkToView;
        }
        [artworkToUpdate updateWithTitle:self.artworkTitleTextField.text artist:self.artistForArtwork imageLocation:self.localIdentifierForArtworkImage location:self.locationForArtworkImage];*/
        
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
    if ([identifier isEqualToString:@"Add Artwork Unwind"]) {
        if ([self.artworkTitleTextField.text length] == 0 || !self.artworkImageView.image) {
            [self presentViewController:[UIAlertController singleButtonAlertWithMessage:@"Photo title or image not set"] animated:YES completion:NULL];
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

/*-(void)setArtistForArtwork:(Artist *)artistForArtwork
{
    _artistForArtwork = artistForArtwork;
    self.artworkArtistTextField.text = _artistForArtwork.name;
}

-(void)setLocalIdentifierForArtworkImage:(NSString *)localIdentifierForArtworkImage
{
    _localIdentifierForArtworkImage = localIdentifierForArtworkImage;
    [[PhotoLibraryInterface shared] imageWithLocalIdentifier:self.localIdentifierForArtworkImage size:self.artworkImageView.bounds.size completion:^(UIImage *image) {
        self.artworkImageView.image = image;
        NSLog(@"setting image for artwork %@", self.localIdentifierForArtworkImage);
    }];
}

-(CLLocation *)locationForArtworkImage
{
    if (self.localIdentifierForArtworkImage) {
        return [[PhotoLibraryInterface shared] locationForImageWithLocalIdentifier:self.localIdentifierForArtworkImage];
    } else {
        return [[CLLocation alloc] init];
    }
}*/

#pragma mark - Actions

-(void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        
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

#warning - THE KEYBOARD BLOCKS THE FIELD BEING TYPED IN
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info[UIImagePickerControllerReferenceURL]) { // chose an existing photo
        self.localIdentifierForArtworkImage = [[PhotoLibraryInterface shared] localIdentifierForALAssetURL:info[UIImagePickerControllerReferenceURL]];
    } else { // took a new photo
        UIImage *artworkImage = info[UIImagePickerControllerOriginalImage];
        [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
            self.localIdentifierForArtworkImage = identifier;
        }];
        // [[PhotoLibraryInterface shared] locationForImageWithLocalIdentifier:self.localIdentifierForArtworkImage];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
