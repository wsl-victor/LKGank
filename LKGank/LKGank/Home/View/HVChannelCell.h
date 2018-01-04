//
//  HVChannelCell.h
//  HomeViewCollectionView
//
//  Created by victor on 16/8/6.
//  Copyright © 2016年 victor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankMainContentController;

@interface HVChannelCell : UICollectionViewCell

@property (nonatomic, strong) GankMainContentController *collectionVC;
@property (nonatomic, copy  ) NSString  *urlString;


@end
