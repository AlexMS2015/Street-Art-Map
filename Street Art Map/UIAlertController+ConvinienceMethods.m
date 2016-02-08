//
//  UIAlertController+ConvinienceMethods.m
//  Street Art Map
//
//  Created by Alex Smith on 6/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "UIAlertController+ConvinienceMethods.h"

@implementation UIAlertController (ConvinienceMethods)

+(UIAlertController *)OKAlertWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL]];
    return alertVC;
}

+(UIAlertController *)YesNoAlertWithMessage:(NSString *)message andHandler:(void (^)(UIAlertAction *, UIAlertController *))actionBlock
{
    UIAlertController *alertVC = [UIAlertController twoButtonAlertWithMessage:message andButtonTitles:@[@"Yes", @"No"] andHandler:actionBlock];
    
    return alertVC;
}

+(UIAlertController *)OKCancelAlertWithMessage:(NSString *)message andHandler:(void (^)(UIAlertAction *, UIAlertController *))actionBlock
{
    UIAlertController *alertVC = [UIAlertController twoButtonAlertWithMessage:message andButtonTitles:@[@"OK", @"Cancel"] andHandler:actionBlock];
    
    return alertVC;
}

+(UIAlertController *)twoButtonAlertWithMessage:(NSString *)message andButtonTitles:(NSArray *)buttonTitles andHandler:(void (^)(UIAlertAction *, UIAlertController *))actionBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:[buttonTitles firstObject] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionBlock(action, alertVC);
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:[buttonTitles lastObject] style:UIAlertActionStyleDefault handler:NULL]];
    
    return alertVC;
}

@end
