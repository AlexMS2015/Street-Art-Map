//
//  PhotoLibraryInterface.h
//  Street Art Map
//
//  Created by Alex Smith on 26/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol PhotoLibraryInterfaceDelegate <NSObject>

@optional
-(void)image:(UIImage *)image forProvidedLocalIdentifier:(NSString *)identifier;
-(void)localIdentifier:(NSString *)identifier forProvidedImage:(UIImage *)image;

@end

@interface PhotoLibraryInterface : NSObject

@property (strong, nonatomic) id <PhotoLibraryInterfaceDelegate> delegate;

-(NSString *)localIdentifierForALAssetURL:(NSURL *)url;

// will call the delegate method 'image:forProvidedLocalIdentifier' on completion
-(void)getImageForLocalIdentifier:(NSString *)identifier withSize:(CGSize)size;

// will call the delegate method 'localIdentifier:forProvidedImage:' on completion
-(void)getLocalIdentifierForImage:(UIImage *)image;

@end
