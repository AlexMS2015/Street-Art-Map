//
//  PhotosForArtistCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PhotosForArtistCDTVC.h"
#import "Artist.h"

@interface PhotosForArtistCDTVC ()

@end

@implementation PhotosForArtistCDTVC

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
    
    NSPredicate *specificArtistPredicate = [NSPredicate predicateWithFormat:@"artist.name = %@", self.artistToShowPhotosFor.name];
    artworkForArtistRequest.predicate = specificArtistPredicate;
    
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
