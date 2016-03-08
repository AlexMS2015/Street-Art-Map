//
//  TestDataLoader.m
//  Street Art Map
//
//  Created by Alex Smith on 20/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "TestDataLoader.h"
#import "Artist.h"
#import "Artwork.h"
#import "ImageFileLocation.h"
#import "PhotoLibraryInterface.h"

@implementation TestDataLoader

+(TestDataLoader *)loadTestDataInContext:(NSManagedObjectContext *)context
{
    static TestDataLoader *shared;
    
    if (!shared) {
        shared = [[self alloc] init];
        
        NSArray *testArtistNames = @[@"Lister", @"Banksy", @"Alex", @"Stacey"];
        NSArray *imageNames = @[@"streetArtImage1", @"streetArtImage2", @"streetArtImage3", @"streetArtImage4"];
        
        for (NSString *artistName in testArtistNames) {
            Artist *newArtist = [Artist artistWithName:artistName inManagedObjectContext:context];
            NSUInteger index = [testArtistNames indexOfObject:artistName];
            NSString *imageNameAndTitle = imageNames[index];
            
            Artwork *newArtwork = [Artwork artworkWithTitle:imageNameAndTitle artist:newArtist inContext:context];
            UIImage *artworkImage = [UIImage imageNamed:imageNameAndTitle];
            
            [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
                NSString *imageFileLocation = identifier;
                ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:context];
                [newArtwork addImageFileLocationsObject:fileLocation];
            }];
        }
    }
    
    return shared;
}

@end
