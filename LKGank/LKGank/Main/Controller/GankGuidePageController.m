//
//  GankGuidePageController.m
//  LKGank
//
//  Created by Stephen on 2017/7/30.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankGuidePageController.h"
#import "UIView+LKExtension.h"
#import "GankNavigationController.h"
#import "GankHomeViewController.h"
#import "GankMainViewController.h"

#define HMNewfeatureImageCount 3

@interface GankGuidePageController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation GankGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
    [self setupPageControl];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<HMNewfeatureImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name =@"";
 
            name = [NSString stringWithFormat:@"a%d.png", i + 1];
     
        
        
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        if (i == HMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    scrollView.contentSize = CGSizeMake(HMNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces=NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor=[UIColor whiteColor];
}
- (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = HMNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 30;
    [self.view addSubview:pageControl];
    
    pageControl.currentPageIndicatorTintColor =[UIColor whiteColor];// [UIColor colorWithHex:0x4d4b4d alpha:1.0];//[UIColor whiteColor];
    pageControl.pageIndicatorTintColor =[self colorWithHex:0xacacac alpha:1.0]; //[UIColor lightGrayColor];
    self.pageControl = pageControl;
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    [self setupStartButton:imageView];
}



/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    
    UIButton *startButton = [[UIButton alloc] init];
    //[startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    //[startButton setBackgroundColor:[UIColor orangeColor]];
    [imageView addSubview:startButton];
    //    startButton.backgroundColor=[UIColor redColor];
    // [startButton setBackgroundImage:[UIImage imageNamed:@"mimacuowu_button_hover"] forState:UIControlStateNormal];
    //[startButton setBackgroundImage:[UIImage imageNamed:@"mimacuowu_button_normal"] forState:UIControlStateHighlighted];
    startButton.size =CGSizeMake(260, 200); //startButton.currentBackgroundImage.size;
    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height * 0.8;
    
    // [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    //[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    // [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    //[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

- (void)start
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    GankHomeViewController *homeVc=[[GankHomeViewController alloc] init];;
    GankNavigationController *navVc=[[GankNavigationController alloc] initWithRootViewController:homeVc];
    GankMainViewController *mainVc=[[GankMainViewController alloc] init];;
    mainVc.rootViewController=navVc;
    window.rootViewController=mainVc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
        if (intPage>1) {
            self.pageControl.hidden=YES;
        }else{
            self.pageControl.hidden=NO;
        }
    self.pageControl.currentPage = intPage;
}

-(void)dealloc
{
    //NSLog(@"==XIAOHUI L====dealloc");
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
