//
//  ArtworkMapVC.m
//  Street Art Map
//
//  Created by Alex Smith on 2/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworkMapVC.h"
#import "DatabaseAvailability.h"
#import "Artwork.h"
#import "AddAndViewArtworkVC.h"
#import "PhotoLibraryInterface.h"
#import "ImageAnnotationView.h"
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ArtworkMapVC () <MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *artworks;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ArtworkMapVC

#pragma mark - Constants

static NSString * const ANNOTATION_VIEW_IDENTIFIER = @"Annotation View";
static NSString * const VIEW_ARTWORK_SEGUE = @"View Artwork";
static int WIDTH_AND_HEIGHT = 85;

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"altitude changed %f", self.mapView.camera.altitude);
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isMemberOfClass:[Artwork class]]) {
        [self performSegueWithIdentifier:VIEW_ARTWORK_SEGUE sender:view];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    ImageAnnotationView *annotationView = (ImageAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_IDENTIFIER];
    
    if (!annotationView) {
        annotationView = [[ImageAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:ANNOTATION_VIEW_IDENTIFIER];
        annotationView.frame = CGRectMake(0, 0, WIDTH_AND_HEIGHT, WIDTH_AND_HEIGHT);
    } else {
         annotationView.annotation = annotation;
    }

    Artwork *artwork = (Artwork *)annotation;
    [[PhotoLibraryInterface shared] imageWithLocalIdentifier:[artwork defaultImageLocation] size:annotationView.bounds.size completion:^(UIImage *image) {
        annotationView.image = image;
    } cached:NO];
    
    return annotationView;
}

#pragma mark - Segues

// called on rewind from adding a photo or editing an existing photo
-(IBAction)done:(UIStoryboardSegue *)segue {}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:VIEW_ARTWORK_SEGUE]) {
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        AddAndViewArtworkVC *addAndViewArtworkVC = (AddAndViewArtworkVC *)nc.viewControllers[0];
        
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        [addAndViewArtworkVC loadExistingArtwork:(Artwork *)annotationView.annotation];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.context && !self.artworks) {
        NSFetchRequest *getAllArtworksRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
        self.artworks = [self.context executeFetchRequest:getAllArtworksRequest error:nil];
    }
}

#pragma mark - Properties

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}

-(void)setArtworks:(NSArray *)artworks
{
    _artworks = artworks;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.artworks];
    [self.mapView layoutSubviews];
}

@end
