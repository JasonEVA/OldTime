//
//  ServiceCategoryTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceCategoryTableViewCell.h"

@interface ServiceCategoryTableViewCell ()
{
    UIImageView* ivService;
    UILabel* lbCatename;
    UILabel* lbCateComment;
}
@end

@implementation ServiceCategoryTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivService = [[UIImageView alloc]init];
        [self.contentView addSubview:ivService];
        [ivService setImage:[UIImage imageNamed:@"icon_service_cate"]];
        
        lbCatename = [[UILabel alloc]init];
        [lbCatename setBackgroundColor:[UIColor clearColor]];
        [lbCatename setFont:[UIFont font_30]];
        [lbCatename setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbCatename];
        
        lbCateComment = [[UILabel alloc]init];
        [lbCateComment setBackgroundColor:[UIColor clearColor]];
        [lbCateComment setFont:[UIFont font_24]];
        [lbCateComment setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbCateComment];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.height.and.width.equalTo(@45);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbCatename mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(9);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-12);
        make.top.equalTo(ivService);
        make.height.mas_equalTo(@19);
    }];
    
    [lbCateComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivService.mas_right).with.offset(9);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-12);
        make.bottom.equalTo(ivService);
        make.height.mas_equalTo(@16);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setServiceCategory:(ServiceCategory*) cate
{
    [lbCatename setText:cate.name];
    
    NSString* cateComment = [NSString stringWithFormat:@"%ld个专家团队，%ld种服务套餐", cate.teamCount, cate.packCount];
    [lbCateComment setText:cateComment];
    
    if (!cate.imgUrl || 0 == cate.imgUrl.length)
    {
        [ivService setImage:[UIImage imageNamed:@"icon_service_cate"]];
    }
    else
    {
        [ivService sd_setImageWithURL:[NSURL URLWithString:cate.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_cate"]];
    }
}

@end
