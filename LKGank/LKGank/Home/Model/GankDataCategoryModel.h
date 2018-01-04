//
//  GankDataCategoryModel.h
//  LKGank
//
//  Created by Stephen on 2017/5/12.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@interface GankDataCategoryModel : RLMObject

@property (nonatomic,copy) NSString *_id;

@property (nonatomic,copy) NSString *createdAt;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *publishedAt;

@property (nonatomic,copy) NSString *source;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *used;

@property (nonatomic,copy) NSString *who;

@property (nonatomic,strong) NSMutableArray *images;
@end
