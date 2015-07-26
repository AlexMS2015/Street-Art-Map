//
//  ArtistsCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "CoreDataTableViewController.h"
@class Artist;

typedef enum {
    SelectionMode,
    ViewingMode
} ArtistScreenMode;

@interface ArtistsCDTVC : CoreDataTableViewController

@property (nonatomic) ArtistScreenMode screenMode; // viewing mode is default

// out
@property (strong, nonatomic) Artist *selectedArtist;

@end
