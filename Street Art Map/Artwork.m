//
//  Artwork.m
//  Street Art Map
//
//  Created by Alex Smith on 8/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork.h"
#import "Artist.h"
#import "ImageFileLocation.h"

@implementation Artwork

+(Artwork *)artworkWithTitle:(NSString *)title artist:(Artist *)artist inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSPredicate *artistPredicate = [NSPredicate predicateWithFormat:@"artist.name = %@", artist.name];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[titlePredicate, artistPredicate]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    Artwork *artwork;
    if ([results count] > 0) {
        //NSLog(@"Found existing artwork with that title and artist");
        artwork = [results firstObject];
    } else {
        //NSLog(@"Creating new artwork");
        artwork = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                                inManagedObjectContext:context];
        artwork.title = title;
        artwork.artist = artist;
        artwork.uploadDate = [NSDate dateWithTimeIntervalSinceNow:0];
        artwork.defaultImageIdx = 0;
        artwork.imageFileLocations = [[NSOrderedSet alloc] init];
    }
    
    return artwork;
}

-(void)deleteFromDatabase
{
    [self.managedObjectContext deleteObject:self];
}

-(NSString *)defaultImageLocation
{
    if ([self.imageFileLocations count] > 0) {
        ImageFileLocation *defIFLocation = self.imageFileLocations[self.defaultImageIdx];
        return defIFLocation.fileLocation;
    } else {
        return @"";
    }
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.lattitude;
    coordinate.longitude = self.longitude;
    
    return coordinate;
}

@end
