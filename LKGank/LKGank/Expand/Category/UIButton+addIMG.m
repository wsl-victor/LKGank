//
//  UIButton+addIMG.m
//  CollectMoneyTool
//
//  Created by Rainy on 16/10/24.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "UIButton+addIMG.h"

@implementation UIButton (addIMG)


-(UIImageView *)addImg:(UIImage *)img withIMGframe:(CGRect )IMGframe
{
    UIImageView *img_VC = [[UIImageView alloc]initWithFrame:IMGframe];
    img_VC.image = img;
    if (!img) {
        
        img_VC.backgroundColor = [UIColor grayColor];
    }
    img_VC.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img_VC];
    
    return img_VC;
}
-(void)setFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font fontColor:(UIColor *)fontColor State:(UIControlState)state
{
    self.frame = frame;
    [self setTitle:title forState:state];
    [self setTitleColor:fontColor forState:state];
    [self.titleLabel setFont:font];
}

@end
