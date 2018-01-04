//
//  GankHomePictureController.m
//  LKGank
//
//  Created by Stephen on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankHomePictureController.h"
#import "GankPictureListViewCell.h"
#import "HttpManager.h"
#import "GankDataCommonModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "HUPhotoBrowser.h"
static NSString * const GankPictureList = @"GankPictureListView";

@interface GankHomePictureController ()

@property (nonatomic,strong) NSMutableArray *contentList;

@property (nonatomic,strong) NSMutableArray *pictureUrlArr;

@property (nonatomic,assign) int pageIndex;

@end

@implementation GankHomePictureController

-(NSMutableArray *)contentList
{
    if (_contentList==nil) {
        _contentList=[NSMutableArray array];
    }
    return _contentList;
}

-(NSMutableArray *)pictureUrlArr
{
    if (_pictureUrlArr==nil) {
        _pictureUrlArr=[NSMutableArray array];
    }
    return _pictureUrlArr;
}

- (instancetype)init
{
    // 流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return [self initWithCollectionViewLayout:layout];
}

-(void)setUrlString:(NSString *)urlString
{
    _urlString=urlString;
     [self.collectionView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNav];
    [self registerCell];
}


- (void)configNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
}

-(void)registerCell
{
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GankPictureListViewCell class]) bundle:nil]forCellWithReuseIdentifier:GankPictureList];
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
    self.collectionView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];

}

-(void)pullDownRefresh
{
    self.pageIndex=1;
    NSString *str=[NSString stringWithFormat:@"http://gank.io/api/data/福利/10/%d",self.pageIndex];
    [HttpManager BGETWithCache:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.contentList removeAllObjects];
        [self.pictureUrlArr removeAllObjects];
        GankDataCommonModel *commonModel=[GankDataCommonModel mj_objectWithKeyValues:responseObject];
        [self.contentList addObjectsFromArray:commonModel.results];
        for (GankDataCategoryModel *model in self.contentList) {
            [self.pictureUrlArr addObject:model.url];
        }
        
     //  self.collectionView.contentOffset = CGPointZero;
        [self.collectionView.mj_header endRefreshing];
     
         [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"====%@",error);
        [self.collectionView.mj_header endRefreshing];
    }];

    
}
-(void)pullUpRefresh
{
    
    NSString *str=[NSString stringWithFormat:@"http://gank.io/api/data/福利/10/%d",self.pageIndex];
    [HttpManager BGETWithCache:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GankDataCommonModel *commonModel=[GankDataCommonModel mj_objectWithKeyValues:responseObject];
        if (commonModel.results.count!=0) {
            self.pageIndex=self.pageIndex+1;
            [self.contentList addObjectsFromArray:commonModel.results];
            for (GankDataCategoryModel *model in self.contentList) {
                [self.pictureUrlArr addObject:model.url];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"====%@",error);
         [self.collectionView.mj_footer endRefreshing];
    }];
   
}


#pragma mark - UIcollectionView 布局
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.46,[UIScreen mainScreen].bounds.size.width * 0.45);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
   
}


#pragma mark - UIcollectionView 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.contentList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GankPictureListViewCell *itemTypeCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:GankPictureList forIndexPath:indexPath];
    GankDataCategoryModel *model=self.contentList[indexPath.row];
    itemTypeCollectionCell.model=model;
    return itemTypeCollectionCell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GankPictureListViewCell *cell = (GankPictureListViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
     [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.pictureUrlArr placeholderImage:[UIImage imageNamed:@"SC0"] atIndex:indexPath.row dismiss:nil];
}
//===========

@end
