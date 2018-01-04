//
//  GankWebViewController.m
//  LKGank
//
//  Created by Stephen on 2017/7/21.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankWebViewController.h"
#import <WebKit/WebKit.h>
#import "GankDataCategoryModel.h"
#import <Realm/Realm.h>
#import <UShareUI/UShareUI.h>

#define GankScreenWidth [UIScreen mainScreen].bounds.size.width
#define GankScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GankWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIActionSheetDelegate,UMSocialShareMenuViewDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) UIButton *soucangBt;
@end

@implementation GankWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title=@"爱分享";
    [self configUI];
    [self configBackItem];
    [self configMenuItem];
    [self setUmengShare];
}

-(void)configUI
{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 0)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;

    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.categoryModel.url]];
    [wkWebView loadRequest:request];
    self.wkWebView = wkWebView;
    //240 200
    self.soucangBt=[[UIButton alloc] initWithFrame:CGRectMake(0, GankScreenHeight-150-64, 48, 40)];
    [self.soucangBt setImage:[UIImage imageNamed:@"soucang"] forState:UIControlStateNormal];
    [self.soucangBt setImage:[UIImage imageNamed:@"soucangh"] forState:UIControlStateHighlighted];
    [self.soucangBt addTarget:self action:@selector(soucangOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.soucangBt];

}
//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"yyyy-MM-dd"]; NSString *dateTime = [formatter stringFromDate:[NSDate date]]; return dateTime;
}

-(void)soucangOnClick
{
    GankDataCategoryModel *model=self.categoryModel;
    model.used=[self getCurrentTime];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:model];
    [realm commitWriteTransaction];
}

- (void)configBackItem {
    
    // 导航栏的返回按钮
    UIImage *backImage = [UIImage imageNamed:@"navigationbar_back_highlighted"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    //[backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    backBtn.contentEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = colseItem;
}


- (void)configMenuItem {
    
    // 导航栏的菜单按钮
    UIImage *menuImage = [UIImage imageNamed:@"fenxiangh"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menuBtn setTintColor:[UIColor whiteColor]];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn setImage:[UIImage imageNamed:@"fenxiangh"] forState:UIControlStateHighlighted];
    [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}


- (void)configColseItem {
    
    // 导航栏的关闭按钮
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}
// 返回按钮点击
- (void)backBtnPressed:(id)sender {

        if (self.wkWebView.canGoBack) {
            [self.wkWebView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }

}


// 菜单按钮点击
- (void)menuBtnPressed:(id)sender {
    [self recommendToYour];
}
// 关闭按钮点击
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark-



#pragma mark - 菜单按钮事件

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *urlStr = self.categoryModel.url;
    if (buttonIndex == 0) {
        
        // safari打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 1) {
        
        // 复制链接
        if (urlStr.length > 0) {
            [[UIPasteboard generalPasteboard] setString:urlStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制链接到黏贴板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }else if (buttonIndex == 2) {
        
        // 分享
        //[self.wkWebView evaluateJavaScript:@"这里写js代码" completionHandler:^(id reponse, NSError * error) {
        //NSLog(@"返回的结果%@",reponse);
        //}];
        NSLog(@"这里自己写，分享url：%@",urlStr);
    }else if (buttonIndex == 3) {
        
        // 刷新
        [self.wkWebView reload];
        
    }
}

#pragma mark - wkWebView代理

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)recommendToYour
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType webUrl:self.categoryModel.url];
    }];
    
}

-(void)setUmengShare
{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina),
                                               ]];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType  webUrl:(NSString *)webUrl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    // NSString* thumbURL =  UMS_THUMB_IMAGE;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"学习圈-干货集中营" descr:@"欢迎下载使用学习圈-干货集中营！" thumImage:[UIImage imageNamed:@"looggg"]];
    //设置网页地址
    shareObject.webpageUrl = webUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            //[self alertWithError:error];
        }];
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
