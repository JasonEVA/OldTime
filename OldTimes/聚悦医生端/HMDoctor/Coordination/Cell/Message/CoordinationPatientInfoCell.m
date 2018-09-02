//
//  CoordinationPatientInfoCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationPatientInfoCell.h"
#import "PatientModel.h"
#import "PatientTestDataModel.h"
#import "NSDate+MsgManager.h"
@interface CoordinationPatientInfoCell ()
@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>
@property (nonatomic, strong)  UILabel  *baseInfo; // <##>
@property (nonatomic, strong)  UILabel  *diseaseName; // <##>
@property (nonatomic, strong)  UILabel  *monitorData; // <##>
@property (nonatomic, strong)  UILabel  *monitorTime; // <##>

@end

@implementation CoordinationPatientInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)setDataWithModel:(PatientModel *)model
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = model.userName;
    self.diseaseName.text = model.illName;
    self.monitorData.text = model.userTestDatas.testValue;
    self.baseInfo.text = [NSString stringWithFormat:@"(%@ %@)",model.sex,model.age];
    self.monitorTime.text = [NSString stringWithFormat:@"%@",model.userTestDatas.testTime];
}


// 设置元素控件
- (void)configElements {
    [self.contentView addSubview:self.avatar]; // <##>
    [self.contentView addSubview:self.name]; // <##>
    [self.contentView addSubview:self.baseInfo]; // <##>
    [self.contentView addSubview:self.diseaseName]; // <##>
    [self.contentView addSubview:self.monitorData]; // <##>
    [self.contentView addSubview:self.monitorTime]; // <##>

    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(7.5);
        make.top.equalTo(self.avatar);
    }];
    [self.baseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(5);
        make.centerY.equalTo(self.name);
    }];

    [self.diseaseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12.5);
        make.centerY.equalTo(self.name);
    }];
    [self.monitorData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.bottom.equalTo(self.avatar);
    }];
    [self.monitorTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monitorData.mas_right).offset(20);
        make.bottom.equalTo(self.avatar);
    }];
}

#pragma mark - Init
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 20.0;
        _avatar.clipsToBounds = YES;
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        [_name setText:@"谢天笑"];
        [_name setFont:[UIFont font_30]];
        [_name setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _name;
}

- (UILabel *)baseInfo {
    if (!_baseInfo) {
        _baseInfo = [UILabel new];
        [_baseInfo setText:@"(男 32)"];
        [_baseInfo setFont:[UIFont font_22]];
        [_baseInfo setTextColor:[UIColor commonDarkGrayColor_666666]];
    }
    return _baseInfo;
}

- (UILabel *)diseaseName {
    if (!_diseaseName) {
        _diseaseName = [UILabel new];
        [_diseaseName setText:@"心脏病"];
        [_diseaseName setFont:[UIFont font_22]];
        [_diseaseName setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _diseaseName;
}

- (UILabel *)monitorData {
    if (!_monitorData) {
        _monitorData = [UILabel new];
        [_monitorData setText:@"心率 75次/分"];
        [_monitorData setFont:[UIFont font_24]];
        [_monitorData setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _monitorData;
}

- (UILabel *)monitorTime {
    if (!_monitorTime) {
        _monitorTime = [UILabel new];
        [_monitorTime setText:@"今天 18:00"];
        [_monitorTime setFont:[UIFont font_24]];
        [_monitorTime setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _monitorTime;
}
@end
