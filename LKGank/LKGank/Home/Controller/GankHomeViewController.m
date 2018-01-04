//
//  GankHomeViewController.m
//  LKGank
//
//  Created by Stephen on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankHomeViewController.h"
#import "GankNavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "UIBarButtonItem+LKExtension.h"
#import "HttpManager.h"
#import "SCToolButton.h"
#import "GankMainContentController.h"
#import "GankSearchViewController.h"
#import "GankHomePictureController.h"

#import "HVChannelLabel.h"
#import "HVChannelCell.h"
#import "HVSecondCell.h"
#import "GankFindViewController.h"
#import "UIView+LKExtension.h"
#define GankScreenWidth [UIScreen mainScreen].bounds.size.width
#define GankScreenHeight [UIScreen mainScreen].bounds.size.height
static NSString * const reuseID  = @"HVChannelCell";
static NSString * const reuseSecondID  = @"HVSecondCell";


@interface GankHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 频道数据模型 */
@property (nonatomic, strong) NSMutableArray *categorylList;
/** 当前要展示频道 */
//@property (nonatomic, strong) NSMutableArray *list_now; // 功能待完善

/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView;
/** 下划线 */
@property (nonatomic, strong) UIImageView *underline;


@property (nonatomic,strong) SCToolButton *toolButton;


@end

@implementation GankHomeViewController


-(NSMutableArray *)categorylList
{
    if (_categorylList==nil) {
        _categorylList=[NSMutableArray array];
    }
    return _categorylList;
}


-(SCToolButton *)toolButton
{
    if (_toolButton==nil) {
        _toolButton= [[SCToolButton alloc]init];
        _toolButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height-80-54, 60, 60);
        //设置适应的边界
        _toolButton.borderRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        //设置两个状态对应的图片
        _toolButton.closeImage = [UIImage imageNamed:@"SC"];
        _toolButton.openImage = [UIImage imageNamed:@"SC"];
        // [self.view addSubview:_toolButton];
        
        [_toolButton recoverBotton];
        
        for (UIView *btn in _toolButton.btns) {
            [btn removeFromSuperview];
        }
        NSMutableArray *marr = [NSMutableArray array];
        for (int i = 0; i< 5; i++) {
            UIButton *btn = [UIButton new];
            NSString *name = [NSString stringWithFormat:@"SC%d",i];
            [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [marr addObject:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(buttonTagget:) forControlEvents:UIControlEventTouchUpInside];
        }
        _toolButton.btns = [marr copy];
        
    }
    
    return _toolButton;
}



-(void)buttonTagget:(UIButton *)bt
{
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"学习圈-Gank.io";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all
    ;

    if ([[NSMutableArray alloc] initWithContentsOfFile:PathCategory].count<1) {
        [self.categorylList addObjectsFromArray: @[
                                                   @{@"name":@"iOS",@"url":@"iOS"},
                                                   @{@"name":@"前端",@"url":@"前端"},
                                                   @{@"name":@"拓展资源",@"url":@"拓展资源"},
                                                   @{@"name":@"休息视频",@"url":@"休息视频"},
                                                   @{@"name":@"福利",@"url":@"福利"}
                                                   ]];
    }else{
        [self.categorylList addObjectsFromArray:[[NSMutableArray alloc] initWithContentsOfFile:PathCategory]];
    }
   
    
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.bigCollectionView];
    

//    all | Android | iOS | 休息视频 | 福利 | 拓展资源 | 前端 | 瞎推荐 | App
    
    // 福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all
   
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem lk_itemWithViewController:self action:@selector(showLeftView) image:@"icon_list_no" highlightImage:nil];
    
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem lk_itemWithViewController:self action:@selector(showRightView) image:@"search" highlightImage:nil];
    
    
   // [self.view addSubview:self.toolButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

}

#pragma mark -

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
   // [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
    GankFindViewController *searchVC = [[GankFindViewController alloc]init];
    GankNavigationController   *searchNVC = [[GankNavigationController alloc]initWithRootViewController:searchVC];
    searchVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //searchVC.backIMG = [self imageFromView:self.view];
    
    [self presentViewController:searchNVC animated:YES completion:nil];

}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.categorylList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"UICollectionViewCellUICollectionViewCell==%d==",indexPath.row);
    if (indexPath.row!=self.categorylList.count-1) {
        HVChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
        NSDictionary *channel = self.categorylList[indexPath.row];
        cell.urlString = channel[@"url"];
        //NSLog(@"HVChannelCell=1=%@=====",channel[@"videoclassID"]);
        // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
        [self addChildViewController:(UIViewController *)cell.collectionVC];
        return cell;
    }else{
        HVSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseSecondID forIndexPath:indexPath];
        NSDictionary *channel = self.categorylList[indexPath.row];
        // NSLog(@"HVSecondCell=2=%@=====",channel[@"videoclassID"]);
        cell.urlString = channel[@"url"];
        // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
        [self addChildViewController:(UIViewController *)cell.collectionVC];
        return cell;
    }
    
    
    return nil;
}


#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= [self getLabelArrayFromSubviews].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = [self getLabelArrayFromSubviews].count - 1;
    }
    
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    HVChannelLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
    HVChannelLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
    
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    //	 NSLog(@"value = %f leftIndex = %zd, rightIndex = %zd", value, leftIndex, rightIndex);
    //	 NSLog(@"左%f 右%f", scaleLeft, scaleRight);
    //	 NSLog(@"左：%@ 右：%@", labelLeft.text, labelRight.text);
    
    // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    
    // 下划线动态跟随滚动：马勒戈壁的可算让我算出来了
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = [UIImage imageNamed:@"selected"].size.width;
}

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView.width;
    // 滚动标题栏到中间位置
    HVChannelLabel *titleLable = [self getLabelArrayFromSubviews][index];
    CGFloat offsetx   =  titleLable.center.x - _smallScrollView.width * 0.5;
    CGFloat offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    [_smallScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    
    // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
    for (HVChannelLabel *label in [self getLabelArrayFromSubviews]) {
        label.textColor = [UIColor blackColor];
    }
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        _underline.width = [UIImage imageNamed:@"selected"].size.width;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = [UIColor redColor];
    }];
}




#pragma mark - getter

- (UIScrollView *)smallScrollView
{
    if (_smallScrollView == nil) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GankScreenWidth, 44)];
        _smallScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        // 设置频道
        // _list_now = self.channelList.mutableCopy;
        
        
        [self setupChannelLabel];
        // 设置下划线
        [_smallScrollView addSubview:({
            HVChannelLabel *firstLabel = [self getLabelArrayFromSubviews][0];
            firstLabel.textColor = [UIColor orangeColor];
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, [UIImage imageNamed:@"selected"].size.width, 6)];
            _underline.image=[UIImage imageNamed:@"selected"];
            [_underline sizeToFit];
            _underline.centerX = firstLabel.centerX;
            //_underline.backgroundColor = AppColor;
            _underline;
        })];
    }
    return _smallScrollView;
}


- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = GankScreenHeight   ;
        CGRect frame = CGRectMake(0, 44, GankScreenWidth, h-44);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor whiteColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[HVChannelCell class] forCellWithReuseIdentifier:reuseID];
        
        [_bigCollectionView registerClass:[HVSecondCell class] forCellWithReuseIdentifier:reuseSecondID];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}



#pragma mark -
/** 设置频道标题 */
- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _smallScrollView.bounds.size.height-6;
    int i = 0;
    for (NSDictionary *channel in self.categorylList) {
        HVChannelLabel *label = [HVChannelLabel channelLabelWithTitle:channel[@"name"]];
        label.frame = CGRectMake(x, 0, label.width + margin, h);
        [_smallScrollView addSubview:label];
        
        x += label.bounds.size.width;
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    _smallScrollView.contentSize = CGSizeMake(x + margin + 10, 0);
}

/** 频道Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    HVChannelLabel *label = (HVChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView setContentOffset:CGPointMake(label.tag * _bigCollectionView.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}

/** 获取smallScrollView中所有的DDChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (HVChannelLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[HVChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}

#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
