//
//  HVSecondCell.m
//  HumanVideo
//
//  Created by victor on 16/8/7.
//  Copyright © 2016年 ipmph. All rights reserved.
//

#import "HVSecondCell.h"
#import "GankHomePictureController.h"
@implementation HVSecondCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    _collectionVC=[[GankHomePictureController alloc] init];
    _collectionVC.view.frame = self.bounds;
    _collectionVC.urlString = urlString;
    [self addSubview:_collectionVC.view];
}

@end
