//
//  YGSearchErrorView.h
//  CollectMoneyTool
//
//  Created by Rainy on 16/10/21.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGSearchErrorView : UIView

+(instancetype)createSearchErrorView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage_lab;
@property (weak, nonatomic) IBOutlet UILabel *describe_lab_one;
@property (weak, nonatomic) IBOutlet UIImageView *searchImg;
@property (weak, nonatomic) IBOutlet UILabel *describe_lab_two;
@end
