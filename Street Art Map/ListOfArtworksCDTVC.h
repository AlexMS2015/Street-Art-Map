//
//  ListOfPhotosCDTVC.h
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ListOfArtworksCDTVC : CoreDataTableViewController

// this class is still abstract. subclasses  need to implement the following method to actually query some data to display
-(void)setupFetchedResultsController;

@end
