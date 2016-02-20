//
//  ArtistsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtistsCDTVC.h"
#import "Artist.h"
#import "Artwork.h"
#import "UIAlertController+ConvinienceMethods.h"

@interface ArtistsCDTVC ()

@end

@implementation ArtistsCDTVC

#pragma mark - Abstract Methods

-(void)setupFetchedResultsController
{    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[nameSort];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - Actions

- (IBAction)addArtist:(UIBarButtonItem *)sender
{
    UIAlertController *newArtistAlert = [UIAlertController OKCancelAlertWithMessage:@"Please type the artist's name" andHandler:^(UIAlertAction *action, UIAlertController *alertVC) {
        NSString *newArtistName = ((UITextField *)[alertVC.textFields firstObject]).text;
        if (newArtistName.length > 0) {
            Artist *newArtist = [Artist artistWithName:newArtistName inManagedObjectContext:self.context];
            [self addedArtist:newArtist];
        }
    }];
    
    [newArtistAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:newArtistAlert animated:YES completion:NULL];
}

// abstract method
-(void)addedArtist:(Artist *)artist { };

@end
