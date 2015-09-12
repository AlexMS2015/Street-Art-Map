//
//  PhotosForArtistCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtworksForArtistCDTVC.h"
#import "Artist.h"

@interface ArtworksForArtistCDTVC ()

@end

@implementation ArtworksForArtistCDTVC

#pragma mark - Properties

-(void)setArtistToShowPhotosFor:(Artist *)artistToShowPhotosFor
{
    _artistToShowPhotosFor = artistToShowPhotosFor;
    self.title = _artistToShowPhotosFor.name;
}

#pragma mark - Implemented Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *artworkForArtistRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    
    artworkForArtistRequest.predicate  = [NSPredicate predicateWithFormat:@"artist.name = %@", self.artistToShowPhotosFor.name];
    
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"artist.name"
                                                               ascending:YES];
    artworkForArtistRequest.sortDescriptors = @[nameSort];
    
    self.fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:artworkForArtistRequest
                                        managedObjectContext:self.context
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
}

@end
