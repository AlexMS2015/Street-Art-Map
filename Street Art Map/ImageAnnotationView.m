//
//  ImageAnnotationView.m
//  Street Art Map
//
//  Created by Alex Smith on 25/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ImageAnnotationView.h"

@interface ImageAnnotationView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageAnnotationView

/*-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = 2;
        [self addSubview:self.imageView];
    }
    
    return self;
}*/

/*-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = 2;
        [self addSubview:self.imageView];
    }
    
    return self;
}*/

#pragma mark - Properties

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = 2;
        [self addSubview:self.imageView];
    }
    
    return _imageView;
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
