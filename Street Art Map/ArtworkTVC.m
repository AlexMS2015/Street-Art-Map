//
//  ArtworkTableViewCell.m
//  Street Art Map
//
//  Created by Alex Smith on 27/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkTVC.h"

@interface ArtworkTVC ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ArtworkTVC

+(CGFloat)cellHeight
{
    return [[UIScreen mainScreen] bounds].size.width - 20; // 20 is a magic number!?
}

-(void)setDateForDateLabel:(NSDate *)dateForDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:dateForDateLabel];
}

@end
