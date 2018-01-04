//
//  GankMainViewController.m
//  LKGank
//
//  Created by victor on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankMainViewController.h"

#import "GankLeftViewController.h"
#import "GankFindViewController.h"

@interface GankMainViewController ()

@end

@implementation GankMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.leftViewController=[[GankLeftViewController alloc] init];

    //self.rightViewController=[[GankFindViewController alloc] init];;
    
    self.leftViewWidth = 200.0;
    //self.leftViewBackgroundImage = [UIImage imageNamed:@"imageLeft"];
    self.leftViewBackgroundColor = [UIColor orangeColor];
    self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];   
    
    self.rightViewWidth = 1.0;
   // self.rightViewBackgroundImage = [UIImage imageNamed:@"imageRight"];
    self.rightViewBackgroundColor = [UIColor colorWithRed:0.65 green:0.5 blue:0.65 alpha:0.95];
    self.rootViewCoverColorForRightView = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.05];
    

    
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.3];
    
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    self.rootViewCoverColorForRightView =   [UIColor clearColor];
    // Do any additional setup after loading the view.
}






- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
            self.rightView.frame = CGRectMake(0.0, 0, size.width, size.height-20.0);
        }
}

- (BOOL)isLeftViewStatusBarHidden {

    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {

    return super.isRightViewStatusBarHidden;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
