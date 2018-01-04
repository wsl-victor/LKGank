//
//  AppDelegate.h
//  LKGank
//
//  Created by Stephen on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) NSInteger currentSelectedIndex;

@end

