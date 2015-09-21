//
//  ArtworkImageView.m
//  Street Art Map
//
//  Created by Alex Smith on 20/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkImageView.h"

@implementation ArtworkImageView

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.clipsToBounds = YES;
        if (!image) {
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.font = [UIFont systemFontOfSize:55];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"+";
            [self addSubview:label];
        } else {
            self.image = image;
        }
    }
    
    return self;
}

@end
