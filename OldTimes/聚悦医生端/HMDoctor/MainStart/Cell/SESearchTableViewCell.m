//
//  SESearchTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESearchTableViewCell.h"
#import "RoundsMessionModel.h"

@interface SESearchTableViewCell ()
@property (nonatomic, strong) UILabel *formNameLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *statusLb;
@end

@implementation SESearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.formNameLb];
        [self.contentView addSubview:self.statusLb];
        [self.contentView addSubview:self.timeLb];
        
        [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(10);
            make.width.equalTo(@50);
            make.height.equalTo(@21);
        }];
        
        [self.formNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.statusLb);
            make.right.lessThanOrEqualTo(self.statusLb.mas_left).offset(-5);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.formNameLb);
            make.top.equalTo(self.formNameLb.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}

- (void)fillDataWithModel:(RoundsMessionModel *)model {
    [self.formNameLb setText:model.moudleName];
    if (model.fillTime.length) {
        [self.timeLb setText:[NSString stringWithFormat:@"填写时间：%@",model.fillTime]];
    }
    else {
        [self.timeLb setText:@"填写时间：暂未填写"];
    }
    [self.statusLb setHidden:!(model.statusName && model.statusName.length)];

    if (model.statusName && model.statusName.length) {
        [self.statusLb setText:model.statusName];
        if ([model.statusName isEqualToString:@"有症状"]) {
            [self.statusLb setBackgroundColor:[UIColor colorWithHexString:@"0099ff" alpha:0.3]];
            [self.statusLb setTextColor:[UIColor colorWithHexString:@"0099ff"]];
        }
        else if ([model.statusName isEqualToString:@"无症状"]) {
            [self.statusLb setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
            [self.statusLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        }
        else if ([model.statusName isEqualToString:@"待填写"] ||[model.statusName isEqualToString:@"待反馈"] ) {
            [self.statusLb setBackgroundColor:[UIColor colorWithHexString:@"88bc56" alpha:0.3]];
            [self.statusLb setTextColor:[UIColor colorWithHexString:@"76a648"]];
        }
    }
   
}

- (UILabel *)statusLb {
    if (!_statusLb) {
        _statusLb = [UILabel new];
        [_statusLb setFont:[UIFont systemFontOfSize:13]];
        [_statusLb setTextColor:[UIColor colorWithHexString:@"76a648"]];
        [_statusLb.layer setCornerRadius:2];
        [_statusLb setClipsToBounds:YES];
        [_statusLb setTextAlignment:NSTextAlignmentCenter];
        [_statusLb setBackgroundColor:[UIColor colorWithHexString:@"dbeacc" alpha:1]];
    }
    return _statusLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setText:@"填写时间：2017年9月5日"];
        [_timeLb setFont:[UIFont systemFontOfSize:14]];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _timeLb;
}

- (UILabel *)formNameLb {
    if (!_formNameLb) {
        _formNameLb = [UILabel new];
        [_formNameLb setText:@"高血压"];
        [_formNameLb setFont:[UIFont systemFontOfSize:16]];
        [_formNameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _formNameLb;
}

@end
