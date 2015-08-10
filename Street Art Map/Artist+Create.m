//
//  Artist+Create.m
//  Street Art Map
//
//  Created by Alex Smith on 9/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artist+Create.h"

@implementation Artist (Create)

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

@end
