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

@end
