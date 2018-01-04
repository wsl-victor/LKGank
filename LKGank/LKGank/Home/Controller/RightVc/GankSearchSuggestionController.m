//
//  GankSearchSuggestionController.m
//  LKGank
//
//  Created by Stephen on 2017/7/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankSearchSuggestionController.h"
#import "HttpManager.h"
#import "GankDataCommonModel.h"
#import <MJExtension/MJExtension.h>
#import "GankMainTextViewCell.h"
#import "GankDataCategoryModel.h"

#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface GankSearchSuggestionController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, copy)   NSString *searchTest;

@property (nonatomic,strong) NSMutableArray *contentlistarr;

@end

@implementation GankSearchSuggestionController

-(NSMutableArray *)contentlistarr
{
    if (_contentlistarr==nil) {
        _contentlistarr=[NSMutableArray array];
    }
    return _contentlistarr;
}

- (UITableView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.tableFooterView = [UIView new];
    }
    return _contentView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
}

- (void)searchTestChangeWithTest:(NSString *)test
{
    _searchTest = test;
    [self sousuo:test];
    
}


//http://gank.io/api/search/query/listview/category/Android/count/10/page/1
-(void)sousuo:(NSString *)urlString
{
    [self.view endEditing:YES];
    NSString *strUrl=[NSString stringWithFormat:@"http://gank.io/api/data/%@/30/1",urlString];
    [HttpManager BGET:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.contentlistarr removeAllObjects];
        GankDataCommonModel *commonModel=[GankDataCommonModel mj_objectWithKeyValues:responseObject];
        [self.contentlistarr addObjectsFromArray:commonModel.results];
        [_contentView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"====%@",error);
    }];
}



#pragma mark - UITableViewDataSource -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentlistarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankMainTextViewCell *cell=[GankMainTextViewCell cellWithTableView:tableView];
    cell.categoryModel=self.contentlistarr[indexPath.row];
    return cell;

}


#pragma mark - UITableViewDelegate -


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankDataCategoryModel *model=self.contentlistarr[indexPath.row];
    //计算文字的高度
    CGFloat height=[self HeightForText:model.desc withFontSize:14 withTextWidth:[UIScreen mainScreen].bounds.size.width-75];
    if (height>45) {
        _contentView.rowHeight = UITableViewAutomaticDimension;
        _contentView.estimatedRowHeight = 85;
        return _contentView.rowHeight;
    }else{
        return 88;
    }
    
    
}

-(CGFloat)HeightForText:(NSString *)text withFontSize:(CGFloat)fontSize withTextWidth:(CGFloat)textWidth {
    // 获取文字字典
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}; // 设定最大宽高
    CGSize size = CGSizeMake(textWidth, 2000); // 计算文字Frame
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     GankDataCategoryModel *model=self.contentlistarr[indexPath.row];
    if (self.searchBlock) {
        self.searchBlock(model);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
