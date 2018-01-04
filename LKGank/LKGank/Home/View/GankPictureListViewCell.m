//
//  GankPictureListViewCell.m
//  LKGank
//
//  Created by Stephen on 2017/7/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankPictureListViewCell.h"

#import "UIImageView+WebCache.h"

@interface GankPictureListViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation GankPictureListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(GankDataCategoryModel *)model
{
    _model=model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.url]];
    self.labelText.text = _model.who;
}

@end
