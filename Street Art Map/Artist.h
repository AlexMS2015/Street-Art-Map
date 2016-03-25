//
//  Artist.h
//  Street Art Map
//
//  Created by Alex Smith on 8/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Artwork;

NS_ASSUME_NONNULL_BEGIN

@interface Artist : NSManagedObject

+(Artist *)artistWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
-(void)deleteFromDatabase;

@end

NS_ASSUME_NONNULL_END

#import "Artist+CoreDataProperties.h"