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

@protocol PhotoLibraryInterfaceDelegate <NSObject>

@optional
//-(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier;
-(void)localIdentifier:(NSString *)identifier forProvidedImage:(UIImage *)image;

@end

@interface PhotoLibraryInterface : NSObject

@property (weak, nonatomic) id <PhotoLibraryInterfaceDelegate> delegate;

+(instancetype)sharedLibrary;

-(NSString *)localIdentifierForALAssetURL:(NSURL *)url;
-(CLLocation *)locationForImageWithLocalIdentifier:(NSString *)identifier;

-(PHImageRequestID)setImageInImageView:(UIImageView *)imageView
            toImageWithLocalIdentifier:(NSString *)identifier
       andExecuteBlockOnceImageFetched:(void (^)(void))block;

-(void)cancelRequestWithID:(PHImageRequestID)requestID;

// will call the delegate method 'image:forProvidedLocalIdentifier' on completion
//-(void)getImageForLocalIdentifier:(NSString *)identifier withSize:(CGSize)size;

// will call the delegate method 'localIdentifier:forProvidedImage:' on completion
-(void)getLocalIdentifierForImage:(UIImage *)image;
-(void)setString:(NSString *)string toLocalIdentifierForImage:(UIImage *)image; // 'string' can't be modified in a block... how to implement this??

@end
