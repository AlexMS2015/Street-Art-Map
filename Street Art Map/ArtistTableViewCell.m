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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ArtistTableViewCell

#pragma mark - Properties

-(void)setArtist:(Artist *)artist
{
    _artist = artist;
    self.nameLabel.text = artist.name;
}

@end
