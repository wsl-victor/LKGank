//
//  GankAboutController.m
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankAboutController.h"
#import "GankOpenSourceController.h"
//关于我们
@interface GankAboutController ()
@property (weak, nonatomic) IBOutlet UIButton *aboutMeBt;
@property (weak, nonatomic) IBOutlet UIButton *openSourceBt;

@end

@implementation GankAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于我们"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于我们"];
}

- (IBAction)aboutMeBtOnClick:(UIButton *)sender {
    [MobClick event:Umeng_about_me];
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aboutme" ofType:@"html"];
    GankOpenSourceController *openSVc=[[GankOpenSourceController alloc] init];
    openSVc.linkUrl=filePath;
    [self.navigationController pushViewController:openSVc animated:YES];
    
}
- (IBAction)openSouceBtOnClick:(UIButton *)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kaiyuanzhujian" ofType:@"html"];
    GankOpenSourceController *openSVc=[[GankOpenSourceController alloc] init];
    openSVc.linkUrl=filePath;
    [self.navigationController pushViewController:openSVc animated:YES];
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
