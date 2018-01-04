//
//  GankFindViewController.m
//  LKGank
//
//  Created by victor on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankFindViewController.h"
#import "GankSearchView.h"
#import "GankSearchSuggestionController.h"
#import "GankWebViewController.h"
#import "HttpManager.h"
#import "GankNavigationController.h"
#import "GankDataCategoryModel.h"
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
@interface GankFindViewController ()<UISearchBarDelegate>


@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GankSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) GankSearchSuggestionController *searchSuggestVC;

@end

@implementation GankFindViewController
//福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all
- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        if ([[NSMutableArray alloc] initWithContentsOfFile:PathCategory].count<1) {
           self.hotArray = [NSMutableArray arrayWithObjects:@"福利", @"iOS", @"休息视频", @"拓展资源", nil];
        }else{
            self.hotArray=[NSMutableArray array];
            for (NSDictionary *dict in [[NSMutableArray alloc] initWithContentsOfFile:PathCategory]) {
                [self.hotArray addObject:dict[@"url"]];
            }
        }
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}



- (GankSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[GankSearchView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) hotArray:self.hotArray historyArray:self.historyArray];
        __weak GankFindViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            
            [weakSelf pushToSearchResultWithSearchStr:str];
    
        };
    }
    return _searchView;
}


- (GankSearchSuggestionController *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[GankSearchSuggestionController alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _searchSuggestVC.view.hidden = YES;
        __weak GankFindViewController  *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(GankDataCategoryModel *searchTest) {
            
            GankWebViewController *controller = [[GankWebViewController alloc] init];
            controller.categoryModel =searchTest;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    }
    return _searchSuggestVC;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.searchBar resignFirstResponder];
    _searchSuggestVC.view.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
}


- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    titleView.backgroundColor=[UIColor orangeColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame)-15, 30)];
    searchBar.backgroundColor=[UIColor orangeColor];
    searchBar.placeholder = @"搜索内容";
  //  searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    
    UIView *searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
  //  [searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //修改标题和标题颜色
    [cancleBtn addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setBackgroundColor:[UIColor orangeColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
   // [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
  //  [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = str;
    _searchSuggestVC.view.hidden = NO;
    [self.view bringSubviewToFront:_searchSuggestVC.view];
    [_searchSuggestVC searchTestChangeWithTest:str];
    [self setHistoryArrWithStr:str];
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
}


#pragma mark - UISearchBarDelegate -


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self pushToSearchResultWithSearchStr:searchBar.text];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view bringSubviewToFront:_searchView];
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}

- (void)didReceiveMemoryWarning
{
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
