//
//  Artwork+CoreDataProperties.m
//  Street Art Map
//
//  Created by Alex Smith on 18/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artwork+CoreDataProperties.h"

@implementation Artwork (CoreDataProperties)

@dynamic title;
@dynamic uploadDate;
@dynamic lastEditDate;
@dynamic defaultImageIdx;
@dynamic artist;
@dynamic location;
@dynamic imageFileLocations;

@end
