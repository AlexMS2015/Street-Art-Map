//
//  Artwork.h
//  Street Art Map
//
//  Created by Alex Smith on 8/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
@class Artist, Location;

NS_ASSUME_NONNULL_BEGIN

@interface Artwork : NSManagedObject <MKAnnotation>

+(Artwork *)artworkWithTitle:(NSString *)title artist:(Artist *)artist inContext:(NSManagedObjectContext *)context;
-(void)deleteFromDatabase;

-(NSString *)defaultImageLocation;

-(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END

#import "Artwork+CoreDataProperties.h"