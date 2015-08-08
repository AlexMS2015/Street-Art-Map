//
//  RecentsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "RecentsCDTVC.h"

@interface RecentsCDTVC ()

@end

@implementation RecentsCDTVC

#pragma mark - Implemented Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *recentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"imageUploadDate" ascending:NO];
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                            ascending:YES
                                                             selector:@selector(localizedCompare:)];
    
    recentsRequest.sortDescriptors = @[dateSort, titleSort];
    
    self.fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:recentsRequest
                                            managedObjectContext:self.context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
}

@end
