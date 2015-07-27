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

@property (strong, nonatomic) NSManagedObjectContext *context;

// set this property if you want to view some artwork rather than add new artwork (the default)
@property (strong, nonatomic) Artwork *artworkToView;

@end
