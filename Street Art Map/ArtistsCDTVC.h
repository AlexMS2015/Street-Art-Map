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
    SelectionMode, ViewingMode
} ArtistScreenMode;

@interface ArtistsCDTVC : CoreDataTableViewController

@property (nonatomic) ArtistScreenMode screenMode; // the default is 'SelectionMode'

// if in selection mode, this property will be set to the artist the user selects
@property (strong, nonatomic) Artist *selectedArtist;

@end
