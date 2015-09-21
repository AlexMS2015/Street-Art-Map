//
//  ArtistTableViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 15/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ViewArtistTVC.h"

@interface ViewArtistTVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

@end

@implementation ViewArtistTVC

-(void)setTitle:(NSString *)title andImageCount:(int)count
{
    self.titleLabel.text = title;
    self.photosCountLabel.text = [NSString stringWithFormat:@"%d photos", count];
}

+(CGFloat)cellHeight
{
    return 210; // magic number!?
}

@end
