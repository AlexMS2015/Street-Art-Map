//
//  Location.h
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artwork;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *artworks;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addArtworksObject:(Artwork *)value;
- (void)removeArtworksObject:(Artwork *)value;
- (void)addArtworks:(NSSet *)values;
- (void)removeArtworks:(NSSet *)values;

@end
