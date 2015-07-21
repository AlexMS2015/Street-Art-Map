//
//  AddArtworkVC.h
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artwork;

@interface AddAndViewArtworkVC : UIViewController

// input
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Artwork *artworkToView;

// output
@property (strong, nonatomic) Artwork *addedArtwork;

@end
