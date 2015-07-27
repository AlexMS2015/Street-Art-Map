//
//  ArtworkTableViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 27/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkTableViewCell.h"
#import "Artwork.h"
#import "Artist.h"
#import "PhotoLibraryInterface.h"
#import <Photos/Photos.h>

@interface ArtworkTableViewCell () <PhotoLibraryInterfaceDelegate>

@property (strong, nonatomic) PhotoLibraryInterface *photoLibInterface;

// outlets
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@end

@implementation ArtworkTableViewCell

#pragma mark - PhotoLibraryInterfaceDelegate

-(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier
{
    self.artworkImageView.image = image;
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

-(void)setArtwork:(Artwork *)artwork
{
    _artwork = artwork;
    self.titleLabel.text = artwork.title;
    self.artistLabel.text = artwork.artist.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.uploadDateLabel.text = [dateFormatter stringFromDate:artwork.uploadDate];
    
    NSString *location = artwork.imageLocation;
    if (location) {
        [self.photoLibInterface getImageForLocalIdentifier:location withSize:self.artworkImageView.bounds.size];
    }
}

@end
