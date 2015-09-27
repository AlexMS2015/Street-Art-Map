//
//  Artwork+Update.m
//  Street Art Map
//
//  Created by Alex Smith on 12/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork+Create.h"
#import "Artist.h"

@implementation Artwork (Create)

+(Artwork *)artworkWithTitle:(NSString *)title artist:(Artist *)artist inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSPredicate *artistPredicate = [NSPredicate predicateWithFormat:@"artist.name = %@", artist.name];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[titlePredicate, artistPredicate]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    Artwork *artwork;
    if ([results count] > 0) {
        NSLog(@"Found existing artwork with that title and artist");
        artwork = [results firstObject];
    } else {
        NSLog(@"Creating new artwork");
        artwork = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                               inManagedObjectContext:context];
        artwork.title = title;
        artwork.artist = artist;
    }
    
    return artwork;
}

-(void)updateWithTitle:(NSString *)title artist:(Artist *)artist imageLocation:(NSString *)imageLocation location:(CLLocation *)location;
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

-(void)deleteFromDatabase
{
    [self.managedObjectContext deleteObject:self];
}

@end
