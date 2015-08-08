//
//  ArtworkAnnotationView.h
//  Street Art Map
//
//  Created by Alex Smith on 3/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ArtworkAnnotationView : MKPinAnnotationView

-(void)setupCallout; // sets up the callout. can be called when the annotation view is selected (i.e. to allow lazy loading) 

@end
