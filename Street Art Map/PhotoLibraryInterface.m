//
//  PhotoLibraryInterface.m
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PhotoLibraryInterface.h"

@implementation PhotoLibraryInterface

#pragma mark - Helper

-(PHAsset *)assetForIdentifer:(id)identifier
{
    PHFetchResult *result;
    if ([identifier isKindOfClass:[NSString class]]) {
        result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    } else if ([identifier isKindOfClass:[NSURL class]]) {
        result = [PHAsset fetchAssetsWithALAssetURLs:@[identifier] options:nil];
    }
    return result ? [result firstObject] : nil;
}

#pragma mark - Public Interface

+(instancetype)sharedLibrary
{
    static PhotoLibraryInterface *sharedLibrary;
    
    if (!sharedLibrary) {
        sharedLibrary = [[self alloc] init];
    }
    
    return sharedLibrary;
}

-(CLLocation *)locationForImageWithLocalIdentifier:(NSString *)identifier
{
    return [self assetForIdentifer:identifier].location;
}

-(NSString *)localIdentifierForALAssetURL:(NSURL *)url
{
    return [self assetForIdentifer:url].localIdentifier;
}

-(void)cancelRequestWithID:(PHImageRequestID)requestID
{
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

-(PHImageRequestID)setImageInImageView:(UIImageView *)imageView toImageWithLocalIdentifier:(NSString *)identifier andExecuteBlockOnceImageFetched:(void (^)(void))block
{
    //PHImageRequestOptions *options - consider implementing this if performance is bad? run in instruments to determine this
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:[self assetForIdentifer:identifier] targetSize:imageView.bounds.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            if (info[PHImageErrorKey]) {
                // error handling
            } else {
                imageView.image = result;
                block();
            }
        }];
    
    return requestID;
}

/*-(void)getImageForLocalIdentifier:(NSString *)identifier withSize:(CGSize)size
{
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    PHAsset *asset = [result firstObject];
    
    // PHImageRequestOptions *options - consider implementing this if performance is bad? run in instruments to determine this
    
    [[PHImageManager defaultManager] requestImageForAsset:[self assetForIdentifer:identifier]
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (info[PHImageErrorKey]) {
                                                    // error handling
                                                } else {
                [self.delegate image:result forProvidedLocalIdentifier:identifier];
                                                }
                                            }];
}*/

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
