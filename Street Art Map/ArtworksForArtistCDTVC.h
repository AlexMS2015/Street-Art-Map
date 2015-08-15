//
//  PhotosForArtistCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ListOfArtworksCDTVC.h"
@class Artist;

@interface ArtworksForArtistCDTVC : ListOfArtworksCDTVC

@property (strong, nonatomic) Artist *artistToShowPhotosFor;

@end