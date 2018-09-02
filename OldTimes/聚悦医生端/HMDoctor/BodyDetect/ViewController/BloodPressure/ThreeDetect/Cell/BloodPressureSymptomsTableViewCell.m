//
//  BloodPressureSymptomsTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureSymptomsTableViewCell.h"

@interface BloodPressureSymptomsTableViewCell ()

@property (nonatomic, strong) UILabel *symptomLabel;
@property (nonatomic, strong) UIImageView *addImgView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation BloodPressureSymptomsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.symptomLabel];
        [self.contentView addSubview:self.addImgView];
        [self.contentView addSubview:self.promptLabel];
        
        [self configConstraints];
    }
    return self;
}


// 设置约束
- (void)configConstraints {
    
    [_symptomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12.5);
    }];
    
    [_addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_promptLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 18));
    }];
}

- (void)setSymptomTitle:(NSString *)title image:(NSString *)image prompt:(NSString *)prompt color:(UIColor *)color
{
    [_symptomLabel setText:title];
    [_addImgView setImage:[UIImage imageNamed:image]];
    [_promptLabel setText:prompt];
    [_promptLabel setTextColor:color];
}

#pragma mark - Init

- (UILabel *)symptomLabel{
    if (!_symptomLabel) {
        _symptomLabel = [UILabel new];
        [_symptomLabel setText:@"头晕"];
        [_symptomLabel setTextColor:[UIColor commonTextColor]];
        [_symptomLabel setFont:[UIFont font_28]];
    }
    return _symptomLabel;
}

- (UIImageView *)addImgView{
    if (!_addImgView) {
        _addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tj_01"]];
    }
    return _addImgView;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        [_promptLabel setText:@"添加"];
        [_promptLabel setTextColor:[UIColor mainThemeColor]];
        [_promptLabel setFont:[UIFont font_26]];
    }
    return _promptLabel;
}
@end
