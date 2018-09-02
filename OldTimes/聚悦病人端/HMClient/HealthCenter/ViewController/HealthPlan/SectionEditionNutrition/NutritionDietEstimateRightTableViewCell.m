//
//  NutritionDietEstimateRightTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/8/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionDietEstimateRightTableViewCell.h"

@interface NutritionDietEstimateRightTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation NutritionDietEstimateRightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_offset(125 * kScreenScale);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-25);
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.desLabel);
            make.left.equalTo(self.imgView.mas_left);
            make.right.equalTo(self.desLabel.mas_left).offset(-5);
            make.height.mas_equalTo(@1.5);
        }];
        
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.desLabel);
            make.left.equalTo(self.desLabel.mas_right).offset(5);
            make.right.equalTo(self.imgView.mas_right);
            make.height.mas_equalTo(@1.5);
        }];
    }
    return self;
}

- (void)setNutritionDietEstimateDataInfo:(NutritionFoodContentModel *)model{

    [self.imgView setImage:[UIImage imageNamed:model.foodImg]];
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.foodImg] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
    
    [self.desLabel setText:@""];
    if (!kStringIsEmpty(model.foodDesc)) {
        [self.desLabel setText:model.foodDesc];
    }
}

#pragma mark -- init
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        [_desLabel setTextColor:[UIColor commonTextColor]];
        [_desLabel setFont:[UIFont font_28]];
    }
    return _desLabel;
}

- (UIView *)leftView{
    if (!_leftView) {
        _leftView = [UIView new];
        [_leftView setBackgroundColor:[UIColor commonCuttingLineColor]];
    }
    return _leftView;
}

- (UIView *)rightView{
    if (!_rightView) {
        _rightView = [UIView new];
        [_rightView setBackgroundColor:[UIColor commonCuttingLineColor]];
    }
    return _rightView;
}
@end
