//
//  AddImageCollectionViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 10/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "AddImageCollectionViewCell.h"

@implementation AddImageCollectionViewCell

-(void)setLabel:(UILabel *)label
{
    _label = label;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
