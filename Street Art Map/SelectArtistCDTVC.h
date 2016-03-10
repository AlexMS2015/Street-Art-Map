//
//  SelectArtistCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 18/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "CoreDataTableViewController.h"
@class Artist;

@interface SelectArtistCDTVC : CoreDataTableViewController

// this property will be set to the artist the user selects. if set on loading then the selected artist will be highlighted grey
@property (strong, nonatomic) Artist *selectedArtist;

@end
