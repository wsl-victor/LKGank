//
//  GankOpenSourceController.m
//  LKGank
//
//  Created by Stephen on 2017/7/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankOpenSourceController.h"

@interface GankOpenSourceController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *openWebView;

@end

@implementation GankOpenSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.openWebView.backgroundColor=[UIColor whiteColor];
    self.openWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    self.openWebView.delegate=self;
    NSURL* url = [NSURL fileURLWithPath:self.linkUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.openWebView loadRequest:request];//加载

    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.title=[self.openWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
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
