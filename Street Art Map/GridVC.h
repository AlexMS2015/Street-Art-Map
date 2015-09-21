//
//  GridVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"

@interface GridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) Grid *grid;

// the 'Orientation' of the grid will be determined by the passed in collectionView's scrolling direction.
-(instancetype)initWithgridSize:(GridSize)size
                 collectionView:(UICollectionView *)collectionView
          andCellConfigureBlock:(void (^)(UICollectionViewCell *cell, Position position, int index))cellConfigureBlock
              andCellTapHandler:(void (^)(UICollectionViewCell *cell, Position position, int index))cellTapHandler;

@end
