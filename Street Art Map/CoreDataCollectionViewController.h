//
//  CoreDataCollectionViewController.h
//  Street Art Map
//
//  Created by Alex Smith on 7/03/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataCollectionViewController : UICollectionViewController
                                                    <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// abstract method. this is called when the context is set. you may need to set the context manually
-(void)setupFetchedResultsController;

// subclasses will need to implement this method themselves
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
