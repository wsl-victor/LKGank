//
//  YGSearchErrorView.m
//  CollectMoneyTool
//
//  Created by Rainy on 16/10/21.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "YGSearchErrorView.h"
//十六进制颜色
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YGSearchErrorView ()




@end

@implementation YGSearchErrorView


+(instancetype)createSearchErrorView
{
    YGSearchErrorView *searchErrorView;
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    searchErrorView = nibView[0];
    
    searchErrorView.frame = [[UIScreen mainScreen] bounds];
    
    searchErrorView.errorMessage_lab.textColor =
    searchErrorView.describe_lab_one.textColor =
    searchErrorView.describe_lab_two.textColor = UIColorFromRGBValue(0XBBBBBB);
    searchErrorView.errorMessage_lab.font = [UIFont systemFontOfSize:18];
    searchErrorView.describe_lab_one.font =
    searchErrorView.describe_lab_two.font = [UIFont systemFontOfSize:18];

    
    
    return searchErrorView;
}

@end
