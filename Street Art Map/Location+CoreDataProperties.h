//
//  Location+CoreDataProperties.h
//  Street Art Map
//
//  Created by Alex Smith on 14/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"
#import "Artwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *country;
@property (nonatomic) double lattitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, retain) NSSet<Artwork *> *artworks;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addArtworksObject:(Artwork *)value;
- (void)removeArtworksObject:(Artwork *)value;
- (void)addArtworks:(NSSet<Artwork *> *)values;
- (void)removeArtworks:(NSSet<Artwork *> *)values;

@end

NS_ASSUME_NONNULL_END
