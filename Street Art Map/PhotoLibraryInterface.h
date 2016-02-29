//
//  PhotoLibraryInterface.h
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoLibraryInterface : NSObject

+(instancetype)shared;

-(CLLocation *)locationForImageWithLocalIdentifier:(NSString *)identifier;

-(PHImageRequestID)imageWithLocalIdentifier:(NSString *)identifier size:(CGSize)size completion:(void (^)(UIImage *))block cached:(BOOL)cached;
-(void)cancelRequestWithID:(PHImageRequestID)requestID;

-(void)localIdentifierForImage:(UIImage *)image completion:(void (^)(NSString *identifier))block;
-(NSString *)localIdentifierForALAssetURL:(NSURL *)url;

-(void)cacheImagesForLocalIdentifiers:(NSArray *)localIdentifiers withSize:(CGSize)size;

@end
