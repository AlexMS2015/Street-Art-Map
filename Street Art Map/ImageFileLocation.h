//
//  ImageFileLocation.h
//  Street Art Map
//
//  Created by Alex Smith on 14/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageFileLocation : NSManagedObject

+(ImageFileLocation *)newImageLocationWithLocation:(NSString *)location inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "ImageFileLocation+CoreDataProperties.h"
