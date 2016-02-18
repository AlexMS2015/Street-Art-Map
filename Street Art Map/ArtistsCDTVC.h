//
//  ArtistsCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "CoreDataTableViewController.h"
@class Artist;

#pragma mark - Constants
static NSString * const CELL_IDENTIFIER = @"ArtistTableViewCell";

@interface ArtistsCDTVC : CoreDataTableViewController

-(void)addedArtist:(Artist *)artist; // will be called when the user adds an artwork to give subclasses a chance to perform any actions with that new Artist object

@end
