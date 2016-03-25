//
//  ImageFileLocation.m
//  Street Art Map
//
//  Created by Alex Smith on 14/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ImageFileLocation.h"

@implementation ImageFileLocation

static NSString * const ENTITY_NAME = @"ImageFileLocation";

+(ImageFileLocation *)newImageLocationWithLocation:(NSString *)location inContext:(NSManagedObjectContext *)context
{
    ImageFileLocation *imageFileLocation = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    imageFileLocation.fileLocation = location;
    
    return imageFileLocation;
}

-(void)deleteFromDatabase
{
    [self.managedObjectContext deleteObject:self];
}

@end
