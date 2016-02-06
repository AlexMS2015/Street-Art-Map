//
//  ArtworkTableViewCell.h
//  Street Art Map
//
//  Created by Alex Smith on 27/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtworkTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastEditDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

+(CGFloat)cellHeight;

@end