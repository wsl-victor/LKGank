//
//  GankCollectController.m
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankCollectController.h"
#import "GankCollectionViewCell.h"
#import "GankDataCategoryModel.h"
#import "GankWebViewController.h"

@interface GankCollectController ()
@property (weak, nonatomic) IBOutlet UITableView *collectionTableView;

@property (nonatomic, retain) NSMutableArray *collectionArray;

@property (nonatomic,strong) RLMResults *results;

@end

@implementation GankCollectController

-(NSMutableArray *)collectionArray
{
    if (_collectionArray==nil) {
        _collectionArray=[NSMutableArray array];
    }
    return _collectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionTableView.rowHeight=85;
    
    self.results = [GankDataCategoryModel allObjects];
   
//    
//    for ( int i=0; i<20; i++) {
//        NSString *ab=   [NSString stringWithFormat:@"%d",i];
//        NSDictionary *dict=@{@"name":@"aaaaa",@"desc":@"bbbbb",@"idx":ab};
//        [self.collectionArray addObject:dict];
//    }
}


//分区个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GankCollectionViewCell *cell=[GankCollectionViewCell cellWithTableView:tableView];
    GankDataCategoryModel *model=self.results[indexPath.row];
    cell.categorymodel=model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        GankDataCategoryModel *model=self.results[indexPath.row];
    GankWebViewController *controller = [[GankWebViewController alloc] init];
    
    controller.categoryModel =model;
    [self.navigationController pushViewController:controller animated:YES];
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
}

    
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        // 1. 更新数据
        [self.collectionArray removeObjectAtIndex:indexPath.row]; // 2. 更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    
    }]; // 删除一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶"); // 1. 更新数据
        [self.collectionArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0]; // 2. 更新UI
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    
    }];
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
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
