//
//  Artwork+Annotation.m
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork+Annotation.h"
#import "Location.h"

@implementation Artwork (Annotation)

#pragma mark - MKAnnotation

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.location.lattitude;
    coordinate.longitude = self.location.longitude;
    
    return coordinate;
}

@end
