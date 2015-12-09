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

-(void)deleteFromDatabase
{
    [self.managedObjectContext deleteObject:self];
}

/*-(void)setTitle:(NSString *)title
{
    [self setPrimitiveValue:title forKey:@"Title"];
    self.lastEditDate = [NSDate date];
}

-(void)setArtist:(Artist *)artist
{
    [self setPrimitiveValue:artist forKey:@"Artist"];
    self.lastEditDate = [NSDate date];
}

-(void)setImageLocation:(NSString *)imageLocation
{
    [self setPrimitiveValue:imageLocation forKey:@"ImageLocation"];
    self.lastEditDate = [NSDate date];
}

-(void)setLattitude:(NSNumber *)lattitude
{
    [self setPrimitiveValue:lattitude forKey:@"Lattitude"];
    self.lastEditDate = [NSDate date];
}

-(void)setLongitude:(NSNumber *)longitude
{
    [self setPrimitiveValue:longitude forKey:@"Longitude"];
    self.lastEditDate = [NSDate date];
}*/

@end
