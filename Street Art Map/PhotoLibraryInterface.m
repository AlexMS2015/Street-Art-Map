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

-(PHFetchResult *)assetsForIdentifers:(NSArray *)identifiers
{
    PHFetchResult *result;
    if ([[identifiers firstObject] isKindOfClass:[NSString class]]) {
        result = [PHAsset fetchAssetsWithLocalIdentifiers:identifiers options:nil];
    } else if ([[identifiers firstObject] isKindOfClass:[NSURL class]]) {
        result = [PHAsset fetchAssetsWithALAssetURLs:identifiers options:nil];
    }
    
    return result;
}

/*-(PHAsset *)assetForIdentifer:(id)identifier
{
    PHFetchResult *result;
    if ([identifier isKindOfClass:[NSString class]]) {
        result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    } else if ([identifier isKindOfClass:[NSURL class]]) {
        result = [PHAsset fetchAssetsWithALAssetURLs:@[identifier] options:nil];
    }
    return result ? [result firstObject] : nil;
}*/

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
    PHAsset *asset = [[self assetsForIdentifers:@[identifier]] firstObject];
    return asset.location;
}

-(NSString *)localIdentifierForALAssetURL:(NSURL *)url
{
    PHAsset *asset = [[self assetsForIdentifers:@[url]] firstObject];
    return asset.localIdentifier;
}

-(void)cancelRequestWithID:(PHImageRequestID)requestID
{
    [[PHImageManager defaultManager] cancelImageRequest:requestID];
}

-(void)cacheImagesForLocalIdentifiers:(NSArray *)localIdentifiers
{
    PHFetchResult *assets = [self assetsForIdentifers:localIdentifiers];
    NSMutableArray *assetsArray = [NSMutableArray array];

    for (PHAsset *asset in assets) {
        [assetsArray addObject:asset];
    }
    
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    [manager startCachingImagesForAssets:assetsArray
                              targetSize:PHImageManagerMaximumSize
                             contentMode:PHImageContentModeDefault
                                 options:nil];
}

-(PHImageRequestID)imageWithLocalIdentifier:(NSString *)identifier size:(CGSize)size completion:(void (^)(UIImage *))block cached:(BOOL)cached
{
    PHAsset *asset = [[self assetsForIdentifers:@[identifier]] firstObject];
    
    PHImageManager *manager;
    if (cached) {
        manager = [[PHCachingImageManager alloc] init];
    } else {
        manager  = [PHImageManager defaultManager];
    }
    
    PHImageRequestID requestID = [manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
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
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *placeholder = request.placeholderForCreatedAsset;
        localIdentifier = placeholder.localIdentifier;
    } completionHandler:^(BOOL success, NSError *error) {
        block(localIdentifier);
    }];
}

@end
