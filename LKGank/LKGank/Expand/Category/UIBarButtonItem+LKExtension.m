//
//  UIBarButtonItem+LKExtension.m
//  LKGank
//
//  Created by Stephen on 2017/4/13.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "UIBarButtonItem+LKExtension.h"
#import "UIView+LKExtension.h"
#import "UIImage+CYButtonIcon.h"
@implementation UIBarButtonItem (LKExtension)

+ (instancetype)lk_itemWithViewController:(UIViewController *)viewController action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage
{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    [item setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (highlightImage.length > 0) {
        [item setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    }
    // 设置监听事件
    [item addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置尺寸
    item.size = item.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:item];
}

+ (instancetype)lk_itemWithViewController:(UIViewController *)viewController action:(SEL)action title:(NSString *)title
{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置文字
    [item setTitle:title forState:UIControlStateNormal];
    
    // 默认字体大小
    item.titleLabel.font = [UIFont systemFontOfSize:16];
    
    // 默认按钮小
    item.size = CGSizeMake(44, 44);
    
    // 设置监听事件
    [item addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:item];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    UIImage *image= [UIImage cy_backButtonIcon:[UIColor whiteColor]];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
    button.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 10);
    button.size = image.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}



@end
