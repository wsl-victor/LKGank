//
//  UIButton+addIMG.h
//  CollectMoneyTool
//
//  Created by Rainy on 16/10/24.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (addIMG)


-(UIImageView *)addImg:(UIImage *)img withIMGframe:(CGRect )IMGframe;

-(void)setFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font fontColor:(UIColor *)fontColor State:(UIControlState)state;


@end
