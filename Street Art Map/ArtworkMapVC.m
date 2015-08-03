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
//#import "PhotoLibraryInterface.h"
#import "AddAndViewArtworkVC.h"
#import "ArtworkAnnotationView.h"
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ArtworkMapVC () <MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *artworks;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) PhotoLibraryInterface *photoLibInterface;

@end

@implementation ArtworkMapVC

#pragma mark - MKMapViewDelegate

#define ANNOTATION_VIEW_REUSE @"MKAnnotationView"
-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    ArtworkAnnotationView *annotationView = (ArtworkAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_REUSE];
    
     if (!annotationView) {
         annotationView = [[ArtworkAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_REUSE];
         annotationView.canShowCallout = YES;
     } else {
         annotationView.annotation = annotation;
     }
    
    /*MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_REUSE];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_REUSE];
        annotationView.canShowCallout = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        annotationView.leftCalloutAccessoryView = imageView;
    } else {
        annotationView.annotation = annotation;
    }*/
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[Artwork class]]) {
        Artwork *artworkForAnnotationView = (Artwork *)view.annotation;
        [self performSegueWithIdentifier:@"View Photo" sender:artworkForAnnotationView];
    }
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue { }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Photo"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddAndViewArtworkVC class]]) {
                AddAndViewArtworkVC *addAndViewArtworkVC = (AddAndViewArtworkVC *)[navController.viewControllers firstObject];
                addAndViewArtworkVC.context = self.context;
                
                if ([sender isMemberOfClass:[Artwork class]]) {
                    addAndViewArtworkVC.artworkToView = (Artwork *)sender;
                }
            }
        }
    }
}

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateMapViewAnnotations];
}

#pragma mark - Helpers

-(void)updateMapViewAnnotations
{
    NSFetchRequest *getAllArtworksRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    self.artworks = [self.context executeFetchRequest:getAllArtworksRequest error:nil];
}

#pragma mark - Properties

/*-(PhotoLibraryInterface *)photoLibInterface
{
    if (!_photoLibInterface) {
        _photoLibInterface = [[PhotoLibraryInterface alloc] init];
    }
    
    return _photoLibInterface;
}*/

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}

-(void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
}

-(void)setArtworks:(NSArray *)artworks
{
    _artworks = artworks;
    [self.artworks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Artwork *artwork = (Artwork *)obj;
        if (![self.mapView.annotations containsObject:artwork]) {
            [self.mapView addAnnotation:artwork];
        }
    }];
    
    [self.mapView showAnnotations:@[[self.mapView.annotations lastObject]] animated:YES];
}

@end
