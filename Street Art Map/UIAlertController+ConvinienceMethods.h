//
//  UIAlertController+ConvinienceMethods.h
//  Street Art Map
//
//  Created by Alex Smith on 6/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionBlock)(UIAlertAction *action, UIAlertController *alertVC);

@interface UIAlertController (ConvinienceMethods)

+(UIAlertController *)OKAlertWithMessage:(NSString *)message;

+(UIAlertController *)YesNoAlertWithMessage:(NSString *)message
                                 andHandler:actionBlock;

+(UIAlertController *)OKCancelAlertWithMessage:(NSString *)message
                                    andHandler:actionBlock;

@end
