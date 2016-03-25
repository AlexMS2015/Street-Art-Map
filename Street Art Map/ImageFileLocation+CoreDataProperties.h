//
//  ImageFileLocation+CoreDataProperties.h
//  Street Art Map
//
//  Created by Alex Smith on 25/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageFileLocation.h"
@class Artwork;

NS_ASSUME_NONNULL_BEGIN

@interface ImageFileLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileLocation;
@property (nullable, nonatomic, retain) Artwork *artwork;

@end

NS_ASSUME_NONNULL_END
