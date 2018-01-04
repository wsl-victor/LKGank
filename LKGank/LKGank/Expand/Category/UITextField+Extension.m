//
//  UITextField+Extension.m
//  CollectMoneyTool
//
//  Created by Rainy on 16/11/2.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "UITextField+Extension.h"
#import "UIView+LKExtension.h"
@implementation UITextField (Extension)

-(void)setLeftimageName:(NSString *)imageName size:(CGSize)size
{
    
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.size = size;
    rightView.contentMode = UIViewContentModeCenter;
    self.leftView = rightView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}

@end
