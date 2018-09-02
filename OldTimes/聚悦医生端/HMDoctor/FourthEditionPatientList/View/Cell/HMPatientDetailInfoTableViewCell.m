//
//  HMPatientDetailInfoTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMPatientDetailInfoTableViewCell.h"
#define POINTHEIGHT  7
@interface HMPatientDetailInfoTableViewCell()

@end

@implementation HMPatientDetailInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.titelLb];
        
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.width.equalTo(@POINTHEIGHT);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pointView.mas_right).offset(15);
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView).offset(-13);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [UIView new];
        [_pointView.layer setCornerRadius:POINTHEIGHT / 2];
        [_pointView setClipsToBounds:YES];
        [_pointView setBackgroundColor:[UIColor colorWithHexString:@"f2725e"]];
    }
    return _pointView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setText:@"占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符占位字符"];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setNumberOfLines:2];
    }
    return _titelLb;
}

@end
