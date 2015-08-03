//
//  Artwork.h
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Location;

@interface Artwork : NSManagedObject

@property (nonatomic, retain) NSString * imageLocation;
@property (nonatomic, retain) NSDate * lastEditDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * uploadDate;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, retain) Location *location;

@end
