//
//  BloodPressureDetectSetUpTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureDetectSetUpTableViewCell.h"

@interface BloodPressureDetectSetUpTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *cuttinglineView;

@end

@implementation BloodPressureDetectSetUpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.promptLabel];
        
        [self configConstraints];
    }
    return self;
}

#pragma mark - Interface Method

#pragma mark - Private Method

- (void)setTitleContent:(NSString *)title
{
    [_titleLabel setText:title];
}

- (void)setPromptContent:(NSString *)content color:(UIColor *)color
{
    [_promptLabel setText:content];
    [_promptLabel setTextColor:color];
}

// 设置约束
- (void)configConstraints {

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(_titleLabel.mas_right);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    _cuttinglineView = [[UIView alloc] init];
    [self.contentView addSubview:self.cuttinglineView];
    [_cuttinglineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [_cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.mas_bottom).with.offset(-0.5);
    }];
    
}


#pragma mark - Init

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"选择时段"];
        [_titleLabel setTextColor:[UIColor commonGrayTextColor]];
        [_titleLabel setFont:[UIFont font_32]];
    }
    return _titleLabel;
}


- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        [_promptLabel setText:@"请选择测量……"];
        [_promptLabel setTextColor:[UIColor commonGrayTextColor]];
        [_promptLabel setFont:[UIFont font_32]];
    }
    return _promptLabel;
}

@end
