//
//  AddArtworkVC.m
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AddArtworkVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "ArtistsCDTVC.h"

@interface AddArtworkVC ()

@property (strong, nonatomic) Artist *artistForArtwork;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UITextField *artworkArtistTextField;
@property (weak, nonatomic) IBOutlet UITextField *artworkTitleTextField;

@end

@implementation AddArtworkVC

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo Unwind"]) {
        Artwork *newArtwork = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                                            inManagedObjectContext:self.context];
        newArtwork.title = self.artworkTitleTextField.text;
        newArtwork.artist = nil;
        newArtwork.uploadDate = [NSDate date];
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

#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
