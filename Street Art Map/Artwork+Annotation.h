//
//  Artwork+Annotation.h
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Artwork.h"
#import <MapKit/MapKit.h>

@interface Artwork (Annotation) <MKAnnotation>

// override the getter of the 'coordinate' property in the MKAnnotation protocol to allow Artwork objects to be displayed in a map view
-(CLLocationCoordinate2D)coordinate;

@end