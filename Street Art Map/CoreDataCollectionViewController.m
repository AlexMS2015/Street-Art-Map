//
//  CoreDataCollectionViewController.m
//  Street Art Map
//
//  Created by Alex Smith on 7/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "CoreDataCollectionViewController.h"
#import "DatabaseAvailability.h"
#import "Artwork.h"
#import "Artist.h"
#import "ArtworkCollectionViewCell.h"
#import "PhotoLibraryInterface.h"

@implementation CoreDataCollectionViewController

static NSString * const CELL_IDENTIFIER = @"Artwork Cell";

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
    [self.fetchedResultsController performFetch:NULL];
    [self.collectionView reloadData];
}

#pragma mark - Properties

-(void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    
    NSSortDescriptor *artistNameSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"artist.name"
                                                                         ascending:YES];
    request.sortDescriptors = @[artistNameSortDesc];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"artist.name" cacheName:nil];
}

-(void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;

    _fetchedResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success)
        NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (error)
        NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArtworkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    if (cell.tag != 0) // cancel any existing requests on the cell (perhaps the cell is being re-used as the user has scrolled)
        [[PhotoLibraryInterface shared] cancelRequestWithID:(PHImageRequestID)cell.tag];
    
    cell.tag = [[PhotoLibraryInterface shared] imageWithLocalIdentifier:[artwork defaultImageLocation] size:cell.imageView.bounds.size completion:^(UIImage *image) {
        cell.imageView.image = image;
        cell.tag = 0;
    } cached:NO];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header View" forIndexPath:indexPath];
        
        UILabel *label = (UILabel *)[reusableView viewWithTag:1];
        label.text = [self.fetchedResultsController sections][indexPath.section].name;
    }
    
    return reusableView;
}

@end
