//
//  HVChannelLabel.h
//  HomeViewCollectionView
//
//  Created by victor on 16/8/6.
//  Copyright © 2016年 victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVChannelLabel : UILabel
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat textWidth;

+ (instancetype)channelLabelWithTitle:(NSString *)title;

@end
