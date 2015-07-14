//
//  ArtistsCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "CoreDataTableViewController.h"
@class Artist;

@interface ArtistsCDTVC : CoreDataTableViewController

// out
@property (strong, nonatomic) Artist *selectedArtist;

@end
