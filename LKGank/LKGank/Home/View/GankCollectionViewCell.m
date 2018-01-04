//
//  GankCollectionViewCell.m
//  LKGank
//
//  Created by Stephen on 2017/7/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankCollectionViewCell.h"
#import "GankDataCategoryModel.h"
@interface GankCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *descRec;

@property (weak, nonatomic) IBOutlet UILabel *createtime;
@property (weak, nonatomic) IBOutlet UILabel *savetime;
@property (weak, nonatomic) IBOutlet UILabel *zuozhe;

@end
@implementation GankCollectionViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GankCollectionView";
    GankCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GankCollectionViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setCategorymodel:(GankDataCategoryModel *)categorymodel
{
    _categorymodel=categorymodel;
    
    self.descRec.text=categorymodel.desc;
    self.createtime.text=categorymodel.createdAt;
    self.zuozhe.text=categorymodel.who;
    self.savetime.text=categorymodel.used;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
