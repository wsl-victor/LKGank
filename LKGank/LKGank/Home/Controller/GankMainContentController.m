//
//  GankMainContentController.m
//  LKGank
//
//  Created by Stephen on 2017/7/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankMainContentController.h"
#import "GankMainTextViewCell.h"
#import "HttpManager.h"
#import "GankDataCommonModel.h"
#import "GankDataCategoryModel.h"
#import <MJExtension.h>
#import "GankWebViewController.h"

#import <MJRefresh.h>
#import "AppDelegate.h"

@interface GankMainContentController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *mainContentTableView;

@property (nonatomic,strong) NSMutableArray *contentArr;

@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation GankMainContentController

-(NSMutableArray *)contentArr
{
    if (_contentArr==nil) {
        _contentArr=[NSMutableArray array];
    }
    return _contentArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor=[UIColor whiteColor];
    //加载tabbleview,
    UITableView *mainContentTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height-44) style:UITableViewStylePlain];
    mainContentTableView.backgroundColor=[UIColor clearColor];
    mainContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainContentTableView.bounces=YES;
    //[manySelectProjectTableView setSectionIndexColor:[UIColor redColor]];
    mainContentTableView.dataSource=self;
    mainContentTableView.delegate=self;
   // mainContentTableView.rowHeight=85;
    [self.view addSubview:mainContentTableView];
    self.mainContentTableView=mainContentTableView;
   
    self.mainContentTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
    self.mainContentTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];
   
    
}

-(void)setUrlString:(NSString *)urlString
{
    _urlString=urlString;
    [self.mainContentTableView.mj_header beginRefreshing];
}



// 福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all


-(void)pullDownRefresh
{
    
    self.currentPage=1;
    NSString *strUrl=[NSString stringWithFormat:@"http://gank.io/api/data/%@/10/%ld",self.urlString,self.currentPage];
    [HttpManager BGET:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.contentArr removeAllObjects];
        [self.mainContentTableView.mj_header endRefreshing];
        self.currentPage=self.currentPage+1;
        GankDataCommonModel *commonModel=[GankDataCommonModel mj_objectWithKeyValues:responseObject];
        [self.contentArr addObjectsFromArray:commonModel.results];
        [self.mainContentTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"====%@",error);
        [self.mainContentTableView.mj_header endRefreshing];
    }];

}
-(void)pullUpRefresh
{
    NSLog(@"==pullUpRefresh=类别===%@==",self.urlString);
    NSString *strUrl=[NSString stringWithFormat:@"http://gank.io/api/data/%@/10/%ld",self.urlString,self.currentPage];
    [HttpManager BGET:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
         [self.mainContentTableView.mj_footer endRefreshing];
        GankDataCommonModel *commonModel=[GankDataCommonModel mj_objectWithKeyValues:responseObject];
        self.currentPage=self.currentPage+1;
        [self.contentArr addObjectsFromArray:commonModel.results];
    
        [self.mainContentTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"====%@",error);
         [self.mainContentTableView.mj_footer endRefreshing];
    }];

}


#pragma -mark-

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankMainTextViewCell *cell=[GankMainTextViewCell cellWithTableView:tableView];
    cell.categoryModel=self.contentArr[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankDataCategoryModel *model=self.contentArr[indexPath.row];
    //计算文字的高度
    CGFloat height=[self HeightForText:model.desc withFontSize:14 withTextWidth:[UIScreen mainScreen].bounds.size.width-75];
    if (height>45) {
        self.mainContentTableView.rowHeight = UITableViewAutomaticDimension;
        self.mainContentTableView.estimatedRowHeight = 85;
        return self.mainContentTableView.rowHeight;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankDataCategoryModel *categoryModel=self.contentArr[indexPath.row];
    GankWebViewController *controller = [[GankWebViewController alloc] init];
   
    controller.categoryModel =categoryModel;
    [self.navigationController pushViewController:controller animated:YES];

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
