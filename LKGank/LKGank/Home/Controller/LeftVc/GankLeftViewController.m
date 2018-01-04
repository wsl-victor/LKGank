//
//  GankLeftViewController.m
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankLeftViewController.h"
#import "GankLeftCell.h"
#import "GankMainViewController.h"
#import "GankNavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "GankCollectController.h"
#import "GankRecommendController.h"
#import "GankGoodReputationController.h"
#import "GankFeedbackController.h"
#import "GankAboutController.h"
#import <UShareUI/UShareUI.h>

#define APPID @"1264475056"

#define AppUrl @"https://itunes.apple.com/app/id1264475056"

@interface GankLeftViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialShareMenuViewDelegate>

@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) UITableView *listTableView;


@end

@implementation GankLeftViewController

-(NSMutableArray *)titleArr
{
    if (_titleArr==nil) {
        _titleArr=[NSMutableArray array];
        [_titleArr addObject:@"我的收藏"];
        [_titleArr addObject:@"我要推荐"];
        [_titleArr addObject:@"给个好评"];
        [_titleArr addObject:@"给个反馈"];
        [_titleArr addObject:@"关于我"];
    }
    return _titleArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor clearColor];
    //加载tabbleview,
    UITableView *listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, -20,200,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    listTableView.backgroundColor=[UIColor clearColor];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.bounces=NO;
    //[manySelectProjectTableView setSectionIndexColor:[UIColor redColor]];
    listTableView.dataSource=self;
    listTableView.delegate=self;
    listTableView.rowHeight=75;
    [self.view addSubview:listTableView];
    self.listTableView=listTableView;
    listTableView.tableHeaderView=[self headerView];
    [self setUmengShare];
}

-(UIView *)headerView
{
    UIView *heview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    UIImageView *imagev=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [imagev setImage:[UIImage imageNamed:@"bb.jpg"]];
    [heview addSubview:imagev];
    return heview;
}

#pragma -mark- 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GankLeftCell *cell=[GankLeftCell cellWithTableView:tableView];
    cell.labelStr=self.titleArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GankMainViewController *mainViewController = (GankMainViewController *)self.sideMenuController ;
    UIViewController *viewController;
    if (indexPath.row==0) {
        viewController = [[GankCollectController alloc] init];
    }else if (indexPath.row==1){
        [MobClick event:Umeng_me_recommend];
        //viewController = [[GankRecommendController alloc] init];
        [self recommendToYour];
        return;
    }else if (indexPath.row==2){
        //给个好评
         [MobClick event:Umeng_me_goodevaluate];
        [self gotoAppStorePageRaisal:APPID];
        return;
        //viewController = [[GankGoodReputationController alloc] init];
    }else if (indexPath.row==3){
        viewController = [[GankFeedbackController alloc] init];
    }else{
        viewController = [[GankAboutController alloc] init];
    }
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.title = self.titleArr[indexPath.row];
    GankNavigationController *navigationController = (GankNavigationController *)mainViewController.rootViewController;
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

//去app页面评价
-(void)gotoAppStorePageRaisal:(NSString *) nsAppId
{
    NSString  *nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",nsAppId];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
}

-(void)recommendToYour
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType webUrl:AppUrl];
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
