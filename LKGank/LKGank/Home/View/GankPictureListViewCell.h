//
//  GankPictureListViewCell.h
//  LKGank
//
//  Created by Stephen on 2017/7/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GankDataCategoryModel.h"

@interface GankPictureListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property(nonatomic,strong)GankDataCategoryModel *model;

@end
