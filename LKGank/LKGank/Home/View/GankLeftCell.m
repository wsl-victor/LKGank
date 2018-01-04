//
//  GankLeftCell.m
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankLeftCell.h"
@interface GankLeftCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelText;


@end

@implementation GankLeftCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GankLeftCell";
    GankLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GankLeftCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
}

-(void)setLabelStr:(NSString *)labelStr
{
    _labelStr=labelStr;
    self.labelText.text=labelStr;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView.backgroundColor=[UIColor clearColor];
    self.labelText.backgroundColor=[UIColor clearColor];
    self.labelText.textColor=[UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
