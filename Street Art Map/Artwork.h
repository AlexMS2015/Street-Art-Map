//
//  Artwork.h
//  Street Art Map
//
//  Created by Alex Smith on 7/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Location;

@interface Artwork : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * uploadDate;
@property (nonatomic, retain) NSNumber * isGraffiti;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, retain) Location *location;

@end
