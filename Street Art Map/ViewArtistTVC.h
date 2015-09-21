//
//  ArtistTableViewCell.h
//  Street Art Map
//
//  Created by Alex Smith on 15/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewArtistTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *artworkImagesCV;

-(void)setTitle:(NSString *)title andImageCount:(int)count;
+(CGFloat)cellHeight;

@end
