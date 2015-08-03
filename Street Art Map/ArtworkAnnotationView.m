//
//  ArtworkAnnotationView.m
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkAnnotationView.h"
#import "PhotoLibraryInterface.h"
#import "Artwork+Annotation.h"
#import <UIKit/UIKit.h>

@interface ArtworkAnnotationView () <PhotoLibraryInterfaceDelegate>

@property (strong, nonatomic) PhotoLibraryInterface *photoLibInterface;

@end

@implementation ArtworkAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self) {
        self.canShowCallout = YES;
        [self setupImage];
    }
    
    return self;
}

#pragma mark - Helper

-(void)setupImage
{
    Artwork *artwork = (Artwork *)self.annotation;
    [self.photoLibInterface getImageForLocalIdentifier:artwork.imageLocation
                                              withSize:self.image.size];
    
}

#pragma mark - PhotoLibraryInterfaceDelegate

-(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier
{
    self.image = image;
}

#pragma mark - Properties

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    [self setupImage];
}

-(PhotoLibraryInterface *)photoLibInterface
{
    if (!_photoLibInterface) {
        _photoLibInterface = [[PhotoLibraryInterface alloc] init];
        _photoLibInterface.delegate = self;
    }
    
    return _photoLibInterface;
}


@end
