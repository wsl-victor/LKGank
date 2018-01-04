//
//  UIBarButtonItem+LKExtension.h
//  LKGank
//
//  Created by Stephen on 2017/4/13.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LKExtension)

+ (instancetype)lk_itemWithViewController:(UIViewController *)viewController action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;

+ (instancetype)lk_itemWithViewController:(UIViewController *)viewController action:(SEL)action title:(NSString *)title;


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
@end
