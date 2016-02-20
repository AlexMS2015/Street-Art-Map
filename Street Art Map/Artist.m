//
//  Artist.m
//  Street Art Map
//
//  Created by Alex Smith on 8/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artist.h"
#import "Artwork.h"

@implementation Artist

+(Artist *)artistWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    Artist *artist;
    if ([results count] > 0) {
        artist = [results firstObject];
    } else {
        NSLog(@"adding artist in context %@", context);
        artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist"
                                               inManagedObjectContext:context];
        artist.name = name;
    }
    
    return artist;
}

-(void)deleteFromDatabase
{
    [self.managedObjectContext deleteObject:self];
}

-(BOOL)isEqualToArtist:(Artist *)artist
{
    return [self.name isEqualToString:artist.name] && [self.artworks isEqualToSet:artist.artworks];
}

@end
