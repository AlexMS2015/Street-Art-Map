//
//  PhotosForArtistCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ListOfPhotosCDTVC.h"
@class Artist;

@interface PhotosForArtistCDTVC : ListOfPhotosCDTVC

@property (strong, nonatomic) Artist *artistToShowPhotosFor;

@end
