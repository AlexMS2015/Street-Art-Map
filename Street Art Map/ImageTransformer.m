//
//  ImageTransformer.m
//  Street Art Map
//
//  Created by Alex Smith on 6/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ImageTransformer.h"

@implementation ImageTransformer

// tells the transformer what type of object it will receive from the 'transformedValue' method
+(Class)transformedValueClass
{
    return [NSData class];
}

// this method will be called when it's time to save the transformable variable to the file system
-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

// this method will be called when the image is loaded from the file system
-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
