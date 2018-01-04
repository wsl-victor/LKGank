//
//  GankMainTextViewCell.m
//  LKGank
//
//  Created by Stephen on 2017/7/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankMainTextViewCell.h"
#import "GankDataCategoryModel.h"
#import <UIImageView+WebCache.h>

//#import <PYPhotosView.h>
@interface GankMainTextViewCell()

@property (weak, nonatomic) IBOutlet UILabel *textviewTV;

@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *nameP;



@end
@implementation GankMainTextViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GankMainTextView";
    GankMainTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GankMainTextViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setCategoryModel:(GankDataCategoryModel *)categoryModel
{
    _categoryModel=categoryModel;
    
    self.textviewTV.text=categoryModel.desc;
    self.nameP.text=categoryModel.who;
    self.dateTime.text=categoryModel.publishedAt;
    
//    if (categoryModel.images.count!=0) {
//        NSURL *url3 = [NSURL URLWithString:categoryModel.images[0]];
//        [self loadAnimatedImageWithURL:url3 completion:^(FLAnimatedImage *animatedImage) {
//            self.fanimationView.animatedImage = animatedImage;
//        }];
//    }
}

/// Even though NSURLCache *may* cache the results for remote images, it doesn't guarantee it.
/// Cache control headers or internal parts of NSURLCache's implementation may cause these images to become uncache.
/// Here we enfore strict disk caching so we're sure the images stay around.

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
