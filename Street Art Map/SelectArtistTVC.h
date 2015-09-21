//
//  SelectArtistTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 20/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectArtistTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(CGFloat)cellHeight;

@end
