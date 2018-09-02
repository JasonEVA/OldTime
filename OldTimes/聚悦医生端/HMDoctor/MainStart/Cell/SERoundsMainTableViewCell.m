//
//  SERoundsMainTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SERoundsMainTableViewCell.h"
#import "UIImage+JWNameImage.h"
#import "RoundsMessionModel.h"

@interface SERoundsMainTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *sexLb;
@property (nonatomic, strong) UILabel *illnessLb;
@property (nonatomic, strong) UILabel *itemLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *statusLb;
@end

@implementation SERoundsMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];

        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.iconView];
        [self.backView addSubview:self.nameLb];
        [self.backView addSubview:self.sexLb];
        [self.backView addSubview:self.illnessLb];
        [self.backView addSubview:self.itemLb];
        [self.backView addSubview:self.timeLb];
        [self.backView addSubview:self.statusLb];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(12.5);
            make.left.equalTo(self.backView).offset(15);
            make.width.height.equalTo(@40);
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(12);
            make.left.equalTo(self.iconView.mas_right).offset(15);
        }];
        
        [self.sexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(8);
        }];
        
        [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView).offset(-15);
            make.centerY.equalTo(self.nameLb);
            make.width.equalTo(@50);
            make.height.equalTo(@21);
        }];
        
        [self.illnessLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.sexLb.mas_right).offset(8);
            make.right.lessThanOrEqualTo(self.statusLb.mas_left).offset(-10);
        }];
        
        [self.itemLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb);
            make.top.equalTo(self.nameLb.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.backView).offset(-10);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb);
            make.top.equalTo(self.itemLb.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.backView).offset(-10);
        }];
        
        [self.nameLb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.sexLb setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.illnessLb setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        
    }
    return self;
}

- (void)fillDateWithModel:(RoundsMessionModel *)model isShowStatusLb:(BOOL)isShowStatusLb{
    [self.nameLb setText:model.userName];
    [self.sexLb setText:model.sex];
    [self.illnessLb setText:model.mainIll];
    [self.itemLb setText:model.moudleName];
    if (model.fillTime.length) {
        [self.timeLb setText:[NSString stringWithFormat:@"填写时间：%@",model.fillTime]];
    }
    else {
        [self.timeLb setText:@""];
    }
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%ld",model.userId]);
    [self.iconView sd_setImageWithURL:urlHead placeholderImage:[UIImage JW_acquireNameImageWithNameString:model.userName imageSize:CGSizeMake(40, 40)]];
    
    if (isShowStatusLb && model.statusName && model.statusName.length) {
        [self.statusLb setText:model.statusName];
    }
    [self.statusLb setHidden:!(isShowStatusLb && model.statusName && model.statusName.length)];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [_backView.layer setCornerRadius:4];
        [_backView.layer setBorderColor:[[UIColor colorWithHexString:@"dfdfdf"] CGColor]];
        [_backView.layer setBorderWidth:0.5];
        [_backView setClipsToBounds:YES];
    }
    return _backView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage JW_acquireNameImageWithNameString:@"Jason" imageSize:CGSizeMake(40, 40)]];
        [_iconView.layer setCornerRadius:20];
        [_iconView setClipsToBounds:YES];
    }
    return _iconView;
}

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UILabel new];
        [_nameLb setText:@"Jason"];
        [_nameLb setFont:[UIFont systemFontOfSize:16]];
        [_nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _nameLb;
}

- (UILabel *)sexLb {
    if (!_sexLb) {
        _sexLb = [UILabel new];
        [_sexLb setText:@"男"];
        [_sexLb setFont:[UIFont systemFontOfSize:14]];
        [_sexLb setTextColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _sexLb;
}

- (UILabel *)illnessLb {
    if (!_illnessLb) {
        _illnessLb = [UILabel new];
        [_illnessLb setText:@"没病"];
        [_illnessLb setFont:[UIFont systemFontOfSize:14]];
        [_illnessLb setTextColor:[UIColor colorWithHexString:@"666666"]];
    }
    return _illnessLb;
}

- (UILabel *)itemLb {
    if (!_itemLb) {
        _itemLb = [UILabel new];
        [_itemLb setText:@"健康表格"];
        [_itemLb setFont:[UIFont systemFontOfSize:14]];
        [_itemLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _itemLb;
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
@end
