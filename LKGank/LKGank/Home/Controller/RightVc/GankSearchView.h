//
//  GankSearchView.h
//  LKGank
//
//  Created by Stephen on 2017/7/29.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapActionBlock)(NSString *str);
@interface GankSearchView : UIView
@property (nonatomic, copy) TapActionBlock tapAction;

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;
@end
