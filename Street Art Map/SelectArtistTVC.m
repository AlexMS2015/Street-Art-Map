//
//  SelectArtistTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 20/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SelectArtistTVC.h"

@implementation SelectArtistTVC

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

+(CGFloat)cellHeight
{
    return 44; // magic number!?
}

@end
