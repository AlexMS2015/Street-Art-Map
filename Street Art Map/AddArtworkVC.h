//
//  AddArtworkVC.h
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artwork;

@interface AddArtworkVC : UIViewController

// input
@property (strong, nonatomic) NSManagedObjectContext *context;

// output
@property (strong, nonatomic) Artwork *addedArtwork;

@end
