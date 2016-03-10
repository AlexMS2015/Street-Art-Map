//
//  ImageZoomCollectionViewCell.h
//  Street Art Map
//
//  Created by Alex Smith on 10/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageZoomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
