//
//  HealthEducationTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationTableViewCell.h"
#import "UILabel+LineOffset.h"



@interface HealthEducationTableViewCell ()
{
    UILabel *lbDate;
    
    UILabel *lbTitle;
    UIImageView *ivImage;
//    UILabel *lbHealthEducationContent;
    
    UIView* flagView;
}

@end

@implementation HealthEducationTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //图片
        ivImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default"]];
        ivImage.layer.cornerRadius = 5;
        ivImage.layer.masksToBounds = YES;
        [self.contentView addSubview:ivImage];
        
        lbTitle = [[UILabel alloc] init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_30]];
        
        lbTitle = [[UILabel alloc] init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_30]];
        [lbTitle setNumberOfLines:2];

//        lbHealthEducationContent = [[UILabel alloc] init];
//        [self.contentView addSubview:lbHealthEducationContent];
//        [lbHealthEducationContent setTextColor:[UIColor commonGrayTextColor]];
//        [lbHealthEducationContent setFont:[UIFont font_26]];
//        [lbHealthEducationContent setNumberOfLines:2];
        
        lbDate = [[UILabel alloc] init];
        [self.contentView addSubview:lbDate];
        [lbDate setTextColor:[UIColor commonGrayTextColor]];
        [lbDate setFont:[UIFont font_26]];
        
        flagView = [[UIView alloc] init];
        [self.contentView addSubview:flagView];

        
        [self subviewsLayout];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)subviewsLayout
{
    [ivImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(@127);
        make.height.mas_equalTo(@72);
    }];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivImage.mas_right).with.offset(15);
        make.top.equalTo(ivImage);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        
    }];
    
//    [lbHealthEducationContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbTitle);
//        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
//        make.top.equalTo(lbTitle.mas_bottom).with.offset(6);
//        
//    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTitle);
        make.bottom.equalTo(ivImage);
    }];
    
    [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDate.mas_right).with.offset(10);
        make.bottom.equalTo(ivImage);
        make.height.mas_equalTo(@18);
    }];
}



- (void) setHealthEducationItem:(HealthEducationItem*) item
{
    [lbTitle setText:item.title];
    
    [lbDate setText:item.publishDate];
    
//    [lbHealthEducationContent setText:item.paper lineSpacing:1.5];
    
    if (item.classPic)
    {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [ivImage sd_setImageWithURL:[NSURL URLWithString:item.classPic] placeholderImage:[UIImage imageNamed:@"img_default"]];
    }
    
    NSArray* subviews = [flagView subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [subview removeFromSuperview];
    }];
    
    [self createFlagImageViews:item];
    
}



- (void) createFlagImageViews:(HealthEducationItem*) item
{
    NSMutableArray* flagImageViews = [NSMutableArray array];
    if (item.isFineClass)
    {
        UIImageView* fineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edcuation_flag_fine"]];
        [flagImageViews addObject:fineImageView];
        
    }
    if (item.isRecommand)
    {
        UIImageView* recommandImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edcuation_flag_recommand"]];
        [flagImageViews addObject:recommandImageView];
        
    }
    
    MASViewAttribute* flagLeft = flagView.mas_left;
    for (NSInteger index = 0; index < flagImageViews.count; ++index)
    {
        UIImageView* flagImageView = flagImageViews[index];
        [flagView addSubview:flagImageView];
        
        [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(flagView);
            make.bottom.equalTo(flagView);
            make.left.equalTo(flagLeft);
            make.width.mas_equalTo(@33);
        }];
        
        UIView* gapView = [[UIView alloc] init];
        [flagView addSubview:gapView];
        [gapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(flagImageView.mas_right);
            make.height.equalTo(flagImageView);
            make.width.mas_offset(@10);
        }];
        flagLeft = gapView.mas_right;
    }
    
}

@end
