//
//  Artwork+Create.m
//  Street Art Map
//
//  Created by Alex Smith on 11/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork+Create.h"
#import "Artist.h"

@implementation Artwork (Create)

+(Artwork *)artworkWithTitle:(NSString *)title andImageLocation:(NSString *)imageLocation andLocation:(CLLocation *)location andArtist:(Artist *)artist inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    //NSPredicate *artistPredicate = [NSPredicate predicateWithFormat:@"artist.name = %@", artist.name];
    //request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[titlePredicate, artistPredicate]];
    
    request.predicate = titlePredicate;
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    Artwork *artwork;
    if ([results count] > 0) {
        artwork = [results firstObject];
        NSLog(@"found an exsiting artwork");
    } else {
        artwork = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                                inManagedObjectContext:context];
        NSLog(@"creating a new artwork");
    }
    
    artwork.title = title;
    artwork.imageLocation = imageLocation;
    artwork.lattitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    artwork.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    artwork.imageUploadDate = [NSDate date];
    
    // need to implement a changes made variable to know whether to update this
    artwork.lastEditDate = [NSDate date];

    return artwork;
}

@end
