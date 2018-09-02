//
//  HMFEPatientListGroupTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第四版集团患者列表cell

#import "HMFEPatientListGroupTableViewCell.h"
#import "HMPatientListGroupModel.h"

@interface HMFEPatientListGroupTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIView *lightLine;

@end

@implementation HMFEPatientListGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.lightLine];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.lightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.width.equalTo(@2);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(HMPatientListGroupModel *)model selected:(BOOL)selected{
    [self.titelLb setText:model.blocName];
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
        [self.lightLine setHidden:NO];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.lightLine setHidden:YES];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setNumberOfLines:2];
    }
    return _titelLb;
}

- (UIView *)lightLine {
    if (!_lightLine) {
        _lightLine = [UIView new];
        [_lightLine setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _lightLine;
}


@end
