//
//  ArtworkMapVC.m
//  Street Art Map
//
//  Created by Alex Smith on 2/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkMapVC.h"
#import "DatabaseAvailability.h"
#import "Artwork+Annotation.h"
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ArtworkMapVC () <MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *artworks;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ArtworkMapVC

/*#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    
}*/

#pragma mark - View Life Cycle

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DATABASE_AVAILABLE_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.context = note.userInfo[DATABASE_CONTEXT];
    }];
}

#pragma mark - Properties

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}

-(void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    NSFetchRequest *getAllArtworksRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    self.artworks = [self.context executeFetchRequest:getAllArtworksRequest error:nil];
}

-(void)setArtworks:(NSArray *)artworks
{
    _artworks = artworks;
    NSLog(@"artworks loaded for map: %@", self.artworks);
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:artworks];
    
}

@end
