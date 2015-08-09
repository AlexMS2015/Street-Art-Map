//
//  ArtistsCDTVC.m
//  Street Art Map
//
//  Created by Alex Smith on 12/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ArtistsCDTVC.h"
#import "Artist.h"
#import "PhotosForArtistCDTVC.h"

@interface ArtistsCDTVC ()

@property (strong, nonatomic) NSString *cellIdentifier;

@end

@implementation ArtistsCDTVC

#pragma mark - Properties

-(void)setScreenMode:(ArtistScreenMode)screenMode
{
    _screenMode = screenMode;
    if (self.screenMode == ViewingMode) {
        self.cellIdentifier = @"ArtistViewCell";
        self.navigationItem.title = @"Artists";
    } else if (self.screenMode == SelectionMode) {
        self.cellIdentifier = @"ArtistSelectCell";
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.title = @"Select Artist";
    }
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    self.screenMode = ViewingMode;
}

#pragma mark - Abstract Methods

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[nameSort];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = artist.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of photos: %lu", (unsigned long)[artist.artworks count]];
    
    if (self.selectedArtist && [artist.name isEqualToString:self.selectedArtist.name]) {
    /*if (self.selectedArtist == artist) {
        NSLog(@"found equal artists");
        NSLog(@"Selected artist located at: %p", &_selectedArtist);
        NSLog(@"Current artist: %@ located at: %p", artist.name, &artist);*/
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([sender isMemberOfClass:[UITableViewCell class]]) {
        UITableViewCell *cellSelected = (UITableViewCell *)sender;
        NSIndexPath *pathOfSelectedCell = [self.tableView indexPathForCell:cellSelected];
        self.selectedArtist = [self.fetchedResultsController objectAtIndexPath:pathOfSelectedCell];
        
        if ([segue.identifier isEqualToString:@"Show Artwork For Artist"]) {
            if ([segue.destinationViewController isMemberOfClass:[PhotosForArtistCDTVC class]]) {
                PhotosForArtistCDTVC *photosForSelectedArtist = (PhotosForArtistCDTVC *)segue.destinationViewController;
                photosForSelectedArtist.artistToShowPhotosFor = self.selectedArtist;
                photosForSelectedArtist.context = self.context;
            }
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Select Artist Unwind"]) {
        if (self.screenMode == SelectionMode) {
            return YES;
        }
    } else if ([identifier isEqualToString:@"Show Artwork For Artist"]) {
        if (self.screenMode == ViewingMode) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Actions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addArtist:(UIBarButtonItem *)sender
{
    UIAlertController *newArtistAlert = [UIAlertController alertControllerWithTitle:@"New Artist" message:@"Please type the artist's name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:NULL];
    
    [newArtistAlert addAction:cancelAction];
    
#warning THIS MIGHT CREATE A STRONG REFERECNE CYCLE
    
    UIAlertAction *addArtistAction = [UIAlertAction actionWithTitle:@"Add"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
            
            
            // ONLY ALLOW THE CREATION OF A NEW ARTIST IF NOT A DUPLICATE
                                                                
            NSString *newArtistName = ((UITextField *)[newArtistAlert.textFields firstObject]).text;
            Artist *newArtist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist"
                                                              inManagedObjectContext:self.context];
            newArtist.name = newArtistName;
            self.selectedArtist = newArtist;
            [self performSegueWithIdentifier:@"Select Artist Unwind" sender:newArtistAlert];
        }];
    
    [newArtistAlert addAction:addArtistAction];
    
    [newArtistAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:newArtistAlert animated:YES completion:NULL];
}


@end
