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

#warning - Not really 'in'?? Never used?
// in (for viewing) and out (for selection)
@property (strong, nonatomic) Artist *selectedArtist;

@end
