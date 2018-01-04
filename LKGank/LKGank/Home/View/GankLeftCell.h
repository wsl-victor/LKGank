//
//  GankLeftCell.h
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GankLeftCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy)  NSString  *labelStr;

@end
