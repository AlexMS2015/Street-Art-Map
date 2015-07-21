//
//  Artist.h
//  Street Art Map
//
//  Created by Alex Smith on 19/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artwork;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *artworks;
@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addArtworksObject:(Artwork *)value;
- (void)removeArtworksObject:(Artwork *)value;
- (void)addArtworks:(NSSet *)values;
- (void)removeArtworks:(NSSet *)values;

@end
