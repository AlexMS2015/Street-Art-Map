//
//  CoreDataCollectionViewController.m
//  Street Art Map
//
//  Created by Alex Smith on 7/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "CoreDataCollectionViewController.h"
#import "DatabaseAvailability.h"

@interface CoreDataCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *itemChanges;
@property (strong, nonatomic) NSMutableArray *sectionChanges;

@end

@implementation CoreDataCollectionViewController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    NSInteger widthAndHeight = self.collectionView.bounds.size.width / 5;
    layout.itemSize = CGSizeMake(widthAndHeight, widthAndHeight);
}

#pragma mark - Properties

-(NSMutableArray *)sectionChanges
{
    if (!_sectionChanges) {
        _sectionChanges = [NSMutableArray array];
    }
    
    return _sectionChanges;
}

-(NSMutableArray *)itemChanges
{
    if (!_itemChanges) {
        _itemChanges = [NSMutableArray array];
    }
    
    return _itemChanges;
}

-(void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    [self setupFetchedResultsController];
}

-(void)setupFetchedResultsController
{
    
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

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [NSMutableDictionary dictionary];

    switch (type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
        default:
            break;
    }
    
    [self.sectionChanges addObject:change];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [NSMutableDictionary dictionary];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        default:
            break;
    }
    
    [self.itemChanges addObject:change];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView performBatchUpdates:^{
        
        for (NSDictionary *dict in self.sectionChanges) {
            
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                
                switch (type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    default:
                        break;
                }
            }];
        }
     
        for (NSDictionary *dict in self.itemChanges) {
            
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch (type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                    default:
                        break;
                }
            }];
        }
    } completion:NULL];
    
    [self.itemChanges removeAllObjects];
    [self.sectionChanges removeAllObjects];
}

@end
