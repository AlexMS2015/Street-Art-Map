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
#import "AddAndViewArtworkVC.h"
//#import "ArtworkAnnotationView.h"
#import "PhotoLibraryInterface.h"
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ArtworkMapVC () <MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *artworks;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ArtworkMapVC

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isMemberOfClass:[Artwork class]])
        [self performSegueWithIdentifier:@"View Photo" sender:view];
}

#define ANNOTATION_VIEW_REUSE @"AnnotationView"
#define WIDTH_AND_HEIGHT 85
-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_REUSE];
    
        UIImageView *iv;
    
    if (!annotationView) {
         annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:ANNOTATION_VIEW_REUSE];
         annotationView.canShowCallout = YES;
        
         CGRect frame = CGRectMake(0, 0, WIDTH_AND_HEIGHT, WIDTH_AND_HEIGHT);
         annotationView.frame = frame;
         
         iv = [[UIImageView alloc] initWithFrame:frame];
         iv.layer.borderColor = [UIColor whiteColor].CGColor;
         iv.layer.borderWidth = 2;
         [annotationView addSubview:iv];
    } else {
         annotationView.annotation = annotation;
         iv = (UIImageView *)[annotationView.subviews firstObject];
    }

    Artwork *artwork = (Artwork *)annotation;
    [[PhotoLibraryInterface sharedLibrary] setImageInImageView:iv toImageWithLocalIdentifier:artwork.imageLocation andExecuteBlockOnceImageFetched:^{}];
    
    return annotationView;
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
                
                if ([sender isKindOfClass:[MKAnnotationView class]]) {
                    MKAnnotationView *annotationView = (MKAnnotationView *)sender;
                    if ([annotationView.annotation isMemberOfClass:[Artwork class]]) {
                        Artwork *artworkForAnnotationView = (Artwork *)annotationView.annotation;
                        addAndViewArtworkVC.artworkToView = artworkForAnnotationView;
                    }
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
}

@end
