//
//  Location+Create.h
//  Street Art Map
//
//  Created by Alex Smith on 27/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface Location (Create)

+(Location *)locationWithCLLocation:(CLLocation *)cllocation;

@end
