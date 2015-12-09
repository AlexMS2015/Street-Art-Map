//
//  UIAlertController+TwoButtonAlertWithAction.m
//  Street Art Map
//
//  Created by Alex Smith on 2/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "UIAlertController+TwoButtonAlertWithAction.h"

@implementation UIAlertController (TwoButtonAlertWithAction)

+(UIAlertController *)twoButtonAlertWithTitle:(NSString *)title andMessage:(NSString *)message andAction:(void (^)(UIAlertAction *))actionBlock
{
    UIAlertController *deletePhotoWarning = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [deletePhotoWarning addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionBlock(action);
    }]];
    
    [deletePhotoWarning addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:NULL]];
    
    return deletePhotoWarning;
}

@end
