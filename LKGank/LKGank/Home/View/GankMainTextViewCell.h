//
//  GankMainTextViewCell.h
//  LKGank
//
//  Created by Stephen on 2017/7/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GankDataCategoryModel;

@interface GankMainTextViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) GankDataCategoryModel *categoryModel;
@end
