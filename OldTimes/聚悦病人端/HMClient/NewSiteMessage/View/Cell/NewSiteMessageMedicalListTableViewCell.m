//
//  NewSiteMessageMedicalListTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMedicalListTableViewCell.h"

@interface NewSiteMessageMedicalListTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *useLb;
@property (nonatomic, strong) UILabel *remarkLb;

@end


@implementation NewSiteMessageMedicalListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.useLb];
        [self.contentView addSubview:self.remarkLb];

        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
        
        [self.useLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.titelLb.mas_bottom).offset(6);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(NewSiteMessageDrugModel *)model {
    [self.titelLb setText:model.drugName];
    [self.useLb setText:model.drugUsageName];
}


- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_titelLb setText:@"阿莫西林胶囊"];

    }
    return _titelLb;
}

- (UILabel *)useLb {
    if (!_useLb) {
        _useLb = [UILabel new];
        [_useLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_useLb setFont:[UIFont systemFontOfSize:14]];
        [_useLb setText:@"用法：口服 一日三次 每次一百片"];
    }
    return _useLb;
}

- (UILabel *)remarkLb {
    if (!_remarkLb) {
        _remarkLb = [UILabel new];
        [_remarkLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_remarkLb setFont:[UIFont font_28]];
    }
    return _remarkLb;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
