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
        
        NSMutableArray *testImageNames = [NSMutableArray array];
        NSArray *testArtistNames = @[@"Lister", @"Banksy", @"Alex", @"Stacey"];
        NSMutableDictionary *testData = [NSMutableDictionary dictionary];
        
        for (int imageNum = 1; imageNum <= 16; imageNum++) {
            [testImageNames addObject:[NSString stringWithFormat:@"streetArtImage%d",imageNum]];
        }
        
        int numArtworksPerArtist = (int)[testImageNames count] / [testArtistNames count];
        for (int i = 0; i < [testArtistNames count]; i++) {
            NSString *artistName = testArtistNames[i];
            NSRange range = NSMakeRange(i * numArtworksPerArtist, numArtworksPerArtist);
            testData[artistName] = [testImageNames subarrayWithRange:range];
        }
        
        for (NSString *artistName in testData.allKeys) {
            Artist *newArtist = [Artist artistWithName:artistName inManagedObjectContext:context];
            
            for (NSString *imageName in testData[artistName]) {
                Artwork *newArtwork = [Artwork artworkWithTitle:imageName artist:newArtist inContext:context];
                UIImage *artworkImage = [UIImage imageNamed:imageName];
                
                [[PhotoLibraryInterface shared] localIdentifierForImage:artworkImage completion:^(NSString *identifier) {
                    NSString *imageFileLocation = identifier;
                    ImageFileLocation *fileLocation = [ImageFileLocation newImageLocationWithLocation:imageFileLocation inContext:context];
                    [newArtwork addImageFileLocationsObject:fileLocation];
                }];
            }
        }
    }
    
    return shared;
}

@end
