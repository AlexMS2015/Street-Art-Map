//
//  ArtworkCollectionViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 7/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ArtworkCollectionViewCell.h"

@implementation ArtworkCollectionViewCell

-(void)setImageView:(UIImageView *)imageView
{
    _imageView = imageView;
    _imageView.layer.borderWidth = 0.3;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
