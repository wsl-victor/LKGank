//
//  HVChannelCell.m
//  HomeViewCollectionView
//
//  Created by victor on 16/8/6.
//  Copyright © 2016年 victor. All rights reserved.
//

#import "HVChannelCell.h"
#import "GankMainContentController.h"
@implementation HVChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    _collectionVC=[[GankMainContentController alloc] init];
    _collectionVC.view.frame = self.bounds;
    _collectionVC.urlString = self.urlString;
    [self addSubview:_collectionVC.view];
}

@end
