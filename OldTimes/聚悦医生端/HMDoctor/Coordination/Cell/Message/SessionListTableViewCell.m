//
//  SessionListTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SessionListTableViewCell.h"
#import "SessionListModel.h"
#import "NSDate+String.h"
#import "ChatIMConfigure.h"

@interface SessionListTableViewCell()
@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *title; // <##>
@property (nonatomic, strong)  UILabel  *timeStamp; // <##>
@property (nonatomic, strong)  UILabel  *prompt; // <##>
@end

@implementation SessionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
    }
    return self;
}

// 设置数据
- (void)configCellData:(ContactDetailModel *)model {
    if (model._isApp) {
        //为任务消息
        [self.title setText:@"我的任务"];
        [self.prompt setText:model._info];
        [self.avatar setImage:[UIImage imageNamed:@"my_mession"]];
    } else if([model._target isEqualToString:ADDNEWFRIEND_TARGET]) {
        //新朋友
        [self.title setText:@"新朋友"];
        [self.prompt setText:model._content];
        [self.avatar setImage:[UIImage imageNamed:@"system_message"]];
    } else {
        [self.avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
        [self.title setText:model._nickName];
        [self.prompt setText:model._content];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model._timeStamp/1000];
    [self.timeStamp setText:[date dateFormate]];
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.contentView addSubview:self.avatar]; // <##>
    [self.contentView addSubview:self.title]; // <##>
    [self.contentView addSubview:self.timeStamp]; // <##>
    [self.contentView addSubview:self.prompt]; // <##>
    
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
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(7.5);
        make.top.equalTo(self.avatar);
    }];
    
    [self.timeStamp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12.5);
        make.centerY.equalTo(self.title);
    }];
    
    [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.avatar);
    }];
}

#pragma mark - Init
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 2.5;
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        [_title setFont:[UIFont font_30]];
        [_title setText:@"糖尿病专家协作组"];
        [_title setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _title;
}

- (UILabel *)timeStamp {
    if (!_timeStamp) {
        _timeStamp = [UILabel new];
        [_timeStamp setText:@"10:00"];
        [_timeStamp setFont:[UIFont font_22]];
        [_timeStamp setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _timeStamp;
}

- (UILabel *)prompt {
    if (!_prompt) {
        _prompt = [UILabel new];
        [_prompt setText:@"您有一条新消息"];
        [_prompt setFont:[UIFont font_26]];
        [_prompt setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _prompt;
}
@end
