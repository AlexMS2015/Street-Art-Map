//
//  UIAlertController+SingleButtonAlert.m
//  Street Art Map
//
//  Created by Alex Smith on 11/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIAlertController+SingleButtonAlert.h"

@implementation UIAlertController (SingleButtonAlert)

+(UIAlertController *)singleButtonAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL]];
    return alert;
}

@end
