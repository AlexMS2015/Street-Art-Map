//
//  Artwork+Update.m
//  Street Art Map
//
//  Created by Alex Smith on 12/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork+Update.h"
#import "Artist.h"

@implementation Artwork (Update)

-(void)updateWithTitle:(NSString *)title imageLocation:(NSString *)imageLocation location:(CLLocation *)location artist:(Artist *)artist inContext:(NSManagedObjectContext *)context
{
    BOOL changesMade = NO;
    
    if (![self.title isEqualToString:title]) {
        self.title = title;
        changesMade = YES;
    }
    
    if (![self.imageLocation isEqualToString:imageLocation]) {
        self.imageLocation = imageLocation;
        self.imageUploadDate = [NSDate date];
        self.lattitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        changesMade = YES;
    }
    
    if (artist.name && ![self.artist.name isEqualToString:artist.name]) {
        self.artist = artist;
        changesMade = YES;
    }
    
    if (changesMade) self.lastEditDate = [NSDate date];
}

@end
