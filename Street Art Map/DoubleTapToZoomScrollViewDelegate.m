//
//  DoubleTapToZoomScrollViewDelegate.m
//  Street Art Map
//
//  Created by Alex Smith on 8/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "DoubleTapToZoomScrollViewDelegate.h"

@interface DoubleTapToZoomScrollViewDelegate ()

@property (strong, nonatomic) UIView *viewToZoom;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) float minZoomScale;
@property (nonatomic) float maxZoomScale;

@end

@implementation DoubleTapToZoomScrollViewDelegate

-(instancetype)initWithViewToZoom:(UIView *)view inScrollView:(UIScrollView *)scrollView withMinZoomScale:(float)minZoomScale andMaxZoomScale:(float)maxZoomScale
{
    if (self = [super init]) {
        self.viewToZoom = view;
        self.minZoomScale = minZoomScale;
        self.maxZoomScale = maxZoomScale;
        self.scrollView = scrollView;
    }
    
    return self;
}

#pragma mark - Properties

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = self.minZoomScale;
    self.scrollView.maximumZoomScale = self.maxZoomScale;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
}

#pragma mark - Actions

-(void)doubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.scrollView.zoomScale > self.minZoomScale) {
        [self.scrollView setZoomScale:self.minZoomScale animated:YES];
    } else if (self.scrollView.zoomScale == self.minZoomScale) {
        [self.scrollView setZoomScale:self.maxZoomScale animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.viewToZoom;
}

@end
