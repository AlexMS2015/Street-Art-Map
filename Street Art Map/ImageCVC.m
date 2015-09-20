//
//  ArtworkCVC.m
//  Street Art Map
//
//  Created by Alex Smith on 20/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ImageCVC.h"

@implementation ImageCVC

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundView.layer.borderWidth = 0.5;
        
        UIImageView *imageView;
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.clipsToBounds = YES;
        [self.backgroundView addSubview:imageView];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    UIImageView *imageView = (UIImageView *)[self.backgroundView.subviews firstObject];
    imageView.image = image;
}

@end
