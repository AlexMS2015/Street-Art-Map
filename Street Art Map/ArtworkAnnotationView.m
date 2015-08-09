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

#define WIDTH_AND_HEIGHT 85
-(void)setupImage
{
    CGRect frame = CGRectMake(0, 0, WIDTH_AND_HEIGHT, WIDTH_AND_HEIGHT);
    self.frame = frame;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    iv.layer.borderColor = [UIColor whiteColor].CGColor;
    iv.layer.borderWidth = 2;
    [self addSubview:iv];
    Artwork *artwork = (Artwork *)self.annotation;
    [self.photoLibInterface getImageForLocalIdentifier:artwork.imageLocation
                                              withSize:CGSizeMake(self.image.size.width * 2.0, self.image.size.width * 2.0)];
}

#pragma mark - PhotoLibraryInterfaceDelegate

-(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier
{
    //self.image = image;
    UIImageView *iv = (UIImageView *)[self.subviews firstObject];
    iv.image = image;
}

#pragma mark - Properties

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    if ([annotation isMemberOfClass:[Artwork class]])
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
