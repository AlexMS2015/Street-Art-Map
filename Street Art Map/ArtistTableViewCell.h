//
//  ArtistTableViewCell.h
//  Street Art Map
//
//  Created by Alex Smith on 15/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artist;

@interface ArtistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *artworkImagesCV;

+(CGFloat)cellHeight;

@end
