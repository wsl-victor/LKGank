//
//  HVSecondCell.h
//  HumanVideo
//
//  Created by victor on 16/8/7.
//  Copyright © 2016年 ipmph. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankHomePictureController;
@interface HVSecondCell : UICollectionViewCell

@property (nonatomic, strong) GankHomePictureController *collectionVC;
@property (nonatomic, copy  ) NSString  *urlString;



@end
