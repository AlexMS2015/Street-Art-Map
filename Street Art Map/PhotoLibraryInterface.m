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

+(instancetype)shared
{
    static PhotoLibraryInterface *shared;
    
    if (!shared) {
        shared = [[self alloc] init];
    }
    
    return shared;
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

-(PHImageRequestID)imageWithLocalIdentifier:(NSString *)identifier size:(CGSize)size completion:(void (^)(UIImage *))block
{
    //PHImageRequestOptions *options - consider implementing this if performance is bad? run in instruments to determine this
    
#warning - Consider using a PHCachingImageManager here
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:[self assetForIdentifer:identifier] targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        if (info[PHImageErrorKey]) {
            NSLog(@"Error fetching image from local identifier");
        } else {
            block(result);
        }
    }];
    
    return requestID;
}

-(void)localIdentifierForImage:(UIImage *)image completion:(void (^)(NSString *))block
{
    __block NSString *localIdentifier;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *addArtworkRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *addedArtworkPlaceholder = addArtworkRequest.placeholderForCreatedAsset;
        localIdentifier = addedArtworkPlaceholder.localIdentifier;
    } completionHandler:^(BOOL success, NSError *error) {
        block(localIdentifier);
    }];
}

@end
