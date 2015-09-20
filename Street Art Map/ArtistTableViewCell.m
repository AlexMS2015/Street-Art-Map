//
//  ArtistTableViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 15/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtistTableViewCell.h"
#import "Artist.h"

@interface ArtistTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *centreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

@end

@implementation ArtistTableViewCell

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(void)simpleLayoutWithTitle:(NSString *)title
{
    self.titleLabel.hidden = YES;
    self.photosCountLabel.hidden = YES;
    self.artworkImagesCV.hidden = YES;
    self.centreTitleLabel.text = title;
}

-(void)CVLayoutWithTitle:(NSString *)title andImageCount:(int)count
{
    self.centreTitleLabel.hidden = YES;
    self.titleLabel.text = title;
    self.photosCountLabel.text = [NSString stringWithFormat:@"%d photos", count];
}

+(CGFloat)cellHeight
{
    return 109; // magic number!?
}

@end
