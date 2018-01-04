//
//  GankNavigationController.m
//  LKGank
//
//  Created by victor on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankNavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "UIBarButtonItem+LKExtension.h"
@interface GankNavigationController ()

@end

@implementation GankNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor orangeColor];
    //self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
+ (void)initialize
{
    [self setupNavigationBarTheme];

}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    // 设置导航栏背景
   
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //UITextAttributeTextColor
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:18];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs];
    
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_highlighted" highImageName:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        
    }
    [super pushViewController:viewController animated:animated];
}

#pragma -mark-  导航栏左右方法
- (void)back
{
    [self popViewControllerAnimated:YES];

}





- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.sideMenuController.isRightViewVisible ? UIStatusBarAnimationSlide : UIStatusBarAnimationFade;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
