//
//  HMSecondEditionPatientInfoDrugTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPatientInfoDrugTableViewCell.h"
#import "HMSecondEditionFreePatientInfoDrugModel.h"
#define scale  (ScreenWidth / (750.0 / 2))

@interface HMSecondEditionPatientInfoDrugTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *specificationsLb;  //规格
@property (nonatomic, strong) UILabel *usageLb;           //用法
@property (nonatomic, strong) UILabel *adviceLb;          //医嘱


@end

@implementation HMSecondEditionPatientInfoDrugTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.adviceLb];
        [self.contentView addSubview:self.usageLb];
        [self.contentView addSubview:self.specificationsLb];
        
        [self configElements];
    }
    return self;
}
- (void)configElements {
    [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15 * scale);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.specificationsLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.titelLb.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    [self.usageLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.specificationsLb.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    [self.adviceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.top.equalTo(self.usageLb.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataWithModel:(HMSecondEditionFreePatientInfoDrugModel *)model {
    [self.titelLb setText:model.drugName];
    [self.specificationsLb setText:[NSString stringWithFormat:@"规格：%@",model.drugSpecifications]];
    [self.usageLb setText:[NSString stringWithFormat:@"用法：%@",model.drugsUsageContent]];
    [self.adviceLb setText:[NSString stringWithFormat:@"医嘱：%@",model.advice]];
    [self configElements];
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_30]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@"谷维素片"];
    }
    return _titelLb;
}

- (UILabel *)specificationsLb {
    if (!_specificationsLb) {
        _specificationsLb = [UILabel new];
        [_specificationsLb setFont:[UIFont font_28]];
        [_specificationsLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_specificationsLb setText:@"规格：10*100"];
    }
    return _specificationsLb;
}
- (UILabel *)usageLb {
    if (!_usageLb) {
        _usageLb = [UILabel new];
        [_usageLb setFont:[UIFont font_28]];
        [_usageLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_usageLb setText:@"用法：吐下去"];
    }
    return _usageLb;
}
- (UILabel *)adviceLb {
    if (!_adviceLb) {
        _adviceLb = [UILabel new];
        [_adviceLb setFont:[UIFont font_28]];
        [_adviceLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_adviceLb setText:@"医嘱：吃吃吃"];
        [_adviceLb setNumberOfLines:0];
        [_adviceLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_adviceLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _adviceLb.lineBreakMode = NSLineBreakByTruncatingTail;
        _adviceLb.preferredMaxLayoutWidth = ScreenWidth - 15 - 15 * scale;

    }
    return _adviceLb;
}
@end
