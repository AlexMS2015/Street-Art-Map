//
//  UIAlertController+TwoButtonAlertWithAction.h
//  Street Art Map
//
//  Created by Alex Smith on 2/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (TwoButtonAlertWithAction)

+(UIAlertController *)twoButtonAlertWithTitle:(NSString *)title andMessage:(NSString *)message andAction:(void (^)(UIAlertAction *))actionBlock;

@end
