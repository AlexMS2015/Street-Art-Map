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
    }
    
    return self;
}

#pragma mark - Helper

-(void)setupCallout
{
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

-(void)setupImage
{
    Artwork *artwork = (Artwork *)self.annotation;
    
    CGSize imageSize = CGSizeMake(self.image.size.width * 10, self.image.size.height * 10);
    
    [self.photoLibInterface getImageForLocalIdentifier:artwork.imageLocation
                                              withSize:imageSize];
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
    Artwork *artwork = (Artwork *)annotation;
    NSLog(@"%@ at %p is setting it's annotation with artwork %@", NSStringFromClass([self class]), &self, artwork.title);
    if ([annotation isMemberOfClass:[Artwork class]]) {
        [self setupImage];
    }
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
