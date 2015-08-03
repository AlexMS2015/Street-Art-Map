//
//  PhotoLibraryInterface.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PhotoLibraryInterface.h"
@import Photos;

@implementation PhotoLibraryInterface

-(CLLocation *)locationForImageWithLocalIdentifier:(NSString *)identifier
{
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    PHAsset *asset = [result firstObject];
    
    return asset.location;
}

-(NSString *)localIdentifierForALAssetURL:(NSURL *)url
{
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
    PHAsset *assetForArtworkImage = [result firstObject];
    return assetForArtworkImage.localIdentifier;
}

-(void)getImageForLocalIdentifier:(NSString *)identifier withSize:(CGSize)size
{
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    PHAsset *asset = [result firstObject];
    
    // PHImageRequestOptions *options - consider implementing this if performance is bad? run in instruments to determine this
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (info[PHImageErrorKey]) {
                                                    // error handling
                                                } else {
                                                [self.delegate image:result
                                          forProvidedLocalIdentifier:identifier];
                                                }
                                            }];
}

-(void)getLocalIdentifierForImage:(UIImage *)image
{
    __block NSString *localIdentifier;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest *addArtworkRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *addedArtworkPlaceholder = addArtworkRequest.placeholderForCreatedAsset;
        localIdentifier = addedArtworkPlaceholder.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError *error) {
        [self.delegate localIdentifier:localIdentifier forProvidedImage:image];;
    }];
}

@end
