//
//  GankSearchSuggestionController.h
//  LKGank
//
//  Created by Stephen on 2017/7/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankDataCategoryModel;
typedef void(^SuggestSelectBlock)(GankDataCategoryModel *searchTest);
@interface GankSearchSuggestionController : UIViewController
@property (nonatomic, copy) SuggestSelectBlock searchBlock;

- (void)searchTestChangeWithTest:(NSString *)test;
@end
