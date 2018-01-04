//
//  GankSearchViewController.m
//  LKGank
//
//  Created by Stephen on 2017/4/25.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankSearchViewController.h"
#import "YGSearchErrorView.h"
#import "UITextField+Extension.h"
#import "UIButton+addIMG.h"
#import "UIView+LKExtension.h"
//十六进制颜色
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface GankSearchViewController ()
@property (nonatomic,strong) UIImageView *backImageView;

@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UITextField *searchView_TF;
@property(nonatomic,strong)YGSearchErrorView *searchErrorView;
@property(nonatomic,strong)UIButton *cancel_bt;
@property(nonatomic,strong)UIBlurEffect *effect;

@property(nonatomic,strong)NSMutableArray *searchResults_array;
@end

@implementation GankSearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.searchView_TF.text.length) {
        
        [self.searchView_TF becomeFirstResponder];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchView_TF resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.backImageView];
    
    [self layoutSubViewsAndItems];
    
}
-(void)layoutSubViewsAndItems
{
    self.backImageView.image = self.backIMG;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancel_bt];
    
    [self.backImageView setBlurStyle:UIBlurEffectStyleExtraLight];
    self.navigationItem.titleView = self.searchView_TF;
}
- (void)cancelAction:(UIButton *)cancel_bt {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}
#pragma mark - searchTextChange
-(void)searchTextChange:(id)sender{
    
    
    
    
}


#pragma mark - lazy
-(UITableView *)myTableView
{
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        //[_myTableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        _myTableView.tableFooterView = [[UIView alloc]init];
        
    }
    return _myTableView;
}
-(UITextField *)searchView_TF
{
    if (!_searchView_TF) {
        
        _searchView_TF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34)];
        _searchView_TF.layer.cornerRadius=3.0;
        _searchView_TF.layer.masksToBounds=YES;
        _searchView_TF.backgroundColor = UIColorFromRGBValue(0xEDEDED);
        _searchView_TF.placeholder = @"输入搜索文字";
        _searchView_TF.tintColor = UIColorFromRGBValue(0XFF9F17);
        _searchView_TF.font = [UIFont systemFontOfSize:16];
        _searchView_TF.textColor = UIColorFromRGBValue(0XFF9F17);;
        _searchView_TF.returnKeyType = UIReturnKeySearch;
        _searchView_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchView_TF.delegate = self;
        [_searchView_TF addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
        
        [_searchView_TF setLeftimageName:@"search_gray" size:CGSizeMake(40, 20)];
    }
    return _searchView_TF;
}
-(YGSearchErrorView *)searchErrorView
{
    if (!_searchErrorView) {
        
        _searchErrorView = [YGSearchErrorView createSearchErrorView];
    }
    return _searchErrorView;
}
-(UIButton *)cancel_bt
{
    if (!_cancel_bt) {
        CGSize size = [@"取消" sizeWithFont: [UIFont systemFontOfSize:17]];
        _cancel_bt = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancel_bt setFrame:CGRectMake(0, 0, size.width, 34) Title:@"取消" font:[UIFont systemFontOfSize:17] fontColor:UIColorFromRGBValue(0XFF9F17) State:UIControlStateNormal];
        [_cancel_bt addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancel_bt;
}
-(NSMutableArray *)searchResults_array
{
    if (!_searchResults_array) {
        
        _searchResults_array = [NSMutableArray array];
    }
    return _searchResults_array;
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
