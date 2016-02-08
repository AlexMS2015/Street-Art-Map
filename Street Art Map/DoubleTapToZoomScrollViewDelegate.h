//
//  DoubleTapToZoomScrollViewDelegate.h
//  Street Art Map
//
//  Created by Alex Smith on 8/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoubleTapToZoomScrollViewDelegate : NSObject <UIScrollViewDelegate>

-(instancetype)initWithViewToZoom:(UIView *)view
                     inScrollView:(UIScrollView *)scrollView
                 withMinZoomScale:(float)minZoomScale
                  andMaxZoomScale:(float)maxZoomScale;

@end
