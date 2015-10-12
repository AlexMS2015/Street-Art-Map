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

// view an existing artwork
-(void)loadExistingArtwork:(Artwork *)artworkToview;

// create new artwork with pre-filled title and/or artist (set both to nil for totally new artwork
-(void)newArtworkWithTitle:(NSString *)title
                 andArtist:(Artist *)artist
                 inContext:(NSManagedObjectContext *)context;
@end
