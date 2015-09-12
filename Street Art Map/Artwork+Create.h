//
//  Artwork+Create.h
//  Street Art Map
//
//  Created by Alex Smith on 11/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork.h"
#import <CoreLocation/CoreLocation.h>

@interface Artwork (Create)

+(Artwork *)artworkWithTitle:(NSString *)title
            andImageLocation:(NSString *)imageLocation
                 andLocation:(CLLocation *)location
                   andArtist:(Artist *)artist
                   inContext:(NSManagedObjectContext *)context;

@end
