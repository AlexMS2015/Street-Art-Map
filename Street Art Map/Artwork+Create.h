//
//  Artwork+Update.h
//  Street Art Map
//
//  Created by Alex Smith on 12/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork.h"
#import <CoreLocation/CoreLocation.h>

@interface Artwork (Create)

+(Artwork *)artworkWithTitle:(NSString *)title artist:(Artist *)artist inContext:(NSManagedObjectContext *)context;
-(void)deleteFromDatabase;

@end
