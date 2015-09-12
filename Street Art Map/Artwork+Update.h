//
//  Artwork+Update.h
//  Street Art Map
//
//  Created by Alex Smith on 12/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork.h"
#import <CoreLocation/CoreLocation.h>

@interface Artwork (Update)

-(void)updateWithTitle:(NSString *)title
         imageLocation:(NSString *)imageLocation
              location:(CLLocation *)location
                artist:(Artist *)artist
             inContext:(NSManagedObjectContext *)context;

@end
