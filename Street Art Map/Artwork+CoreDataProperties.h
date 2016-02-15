//
//  Artwork+CoreDataProperties.h
//  Street Art Map
//
//  Created by Alex Smith on 14/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artwork.h"
#import "ImageFileLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artwork (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) NSDate *uploadDate;
@property (nonatomic) NSDate *lastEditDate;
@property (nonatomic) int16_t defaultImageIdx;
@property (nullable, nonatomic, retain) Artist *artist;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSOrderedSet<ImageFileLocation *> *imageFileLocations;

@end

@interface Artwork (CoreDataGeneratedAccessors)

- (void)insertObject:(ImageFileLocation *)value inImageFileLocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImageFileLocationsAtIndex:(NSUInteger)idx;
- (void)insertImageFileLocations:(NSArray<ImageFileLocation *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImageFileLocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImageFileLocationsAtIndex:(NSUInteger)idx withObject:(ImageFileLocation *)value;
- (void)replaceImageFileLocationsAtIndexes:(NSIndexSet *)indexes withImageFileLocations:(NSArray<ImageFileLocation *> *)values;
- (void)addImageFileLocationsObject:(ImageFileLocation *)value;
- (void)removeImageFileLocationsObject:(ImageFileLocation *)value;
- (void)addImageFileLocations:(NSOrderedSet<ImageFileLocation *> *)values;
- (void)removeImageFileLocations:(NSOrderedSet<ImageFileLocation *> *)values;

@end

NS_ASSUME_NONNULL_END
