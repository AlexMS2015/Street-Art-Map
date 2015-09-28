//
//  AddArtworkVC.h
//  Street Art Map
//
//  Created by Alex Smith on 11/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artwork;
@class Artist;

@interface AddAndViewArtworkVC : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

-(void)loadExistingArtwork:(Artwork *)artworkToview; // view an existing artwork
-(void)newArtworkWithTitle:(NSString *)title andArtist:(Artist *)artist; // create a new artwork with a pre-filled title and/or artist

@end
