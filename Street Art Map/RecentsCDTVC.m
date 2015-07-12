//
//  RecentsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "RecentsCDTVC.h"
#import "Artwork.h"
#import "Artist.h"
#import "AddArtworkVC.h"

@interface RecentsCDTVC ()

@end

@implementation RecentsCDTVC

#pragma mark - Implemented Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *recentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artwork"];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"uploadDate" ascending:NO];
    NSSortDescriptor *title = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                            ascending:YES
                                                             selector:@selector(localizedCompare:)];
    
    recentsRequest.sortDescriptors = @[dateSort, title];
    
    self.fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:recentsRequest
                                            managedObjectContext:self.context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
}

#pragma mark - Segues

-(IBAction)done:(UIStoryboardSegue *)segue
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Photo"]) {
        if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue
            .destinationViewController;
            if ([[navController.viewControllers firstObject] isMemberOfClass:[AddArtworkVC class]]) {
                AddArtworkVC *addArtworkVC = (AddArtworkVC *)[navController.viewControllers firstObject];
                addArtworkVC.context = self.context;
            }

        }
    }
}

#pragma mark - UITableViewDataSource

#define CELL_IDENTIFIER @"ArtworkCell"

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    Artwork *artwork = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = artwork.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:artwork.uploadDate];
    
    return cell;
}

@end
