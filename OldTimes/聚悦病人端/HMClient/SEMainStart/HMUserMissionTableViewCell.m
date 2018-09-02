//
//  HMUserMissionTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMUserMissionTableViewCell.h"
#import "PlanMessionListItem.h"

@interface HMUserMissionTableViewCell ()

@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *outDateLb;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *targetLb;
@property (nonatomic, strong) UILabel *statusLb;

@end

@implementation HMUserMissionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.targetLb];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.outDateLb];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.statusLb];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);
        }];
        
        [self.outDateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLb);
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
        }];
        
        [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@60);
            make.height.equalTo(@22);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.timeLb.mas_right).offset(30);
            make.right.lessThanOrEqualTo(self.statusLb.mas_left).offset(-15);
        }];
        
        [self.targetLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
            make.right.lessThanOrEqualTo(self.statusLb.mas_left).offset(-15);
        }];

    }
    return self;
}

- (void)fillDataWithModel:(PlanMessionListItem *)model {
//    if ([model.kpiCode isEqualToString:@"XL"]) {
//        [self.titelLb setText:@"测心电"];
//        [self.targetLb setText:@"心电"];
//        
//    }
//    else {
        [self.titelLb setText:model.title];
        [self.targetLb setText:model.taskCon];
//    }

    [self cinfigTimeString:model];
    [self configStatusLbWithModel:model];
}

- (void)cinfigTimeString:(PlanMessionListItem *)model {
    if ([model.status isEqualToString:@"3"]) {
        // 已过期
        [self.timeLb setTextColor:[UIColor colorWithHexString:@"f25555"]];
        [self.outDateLb setHidden:NO];
        
        [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);

        }];

    }
    else {
        [self.timeLb setTextColor:[UIColor mainThemeColor]];
        [self.outDateLb setHidden:YES];
        
        [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);

        }];
    }
    NSString *timeString = @"";

    if ([model.title isEqualToString:@"记饮食"]||
        [model.title isEqualToString:@"记心情"]||
        [model.title isEqualToString:@"做运动"]||
        [model.title isEqualToString:@"记录服药"]||
        [model.title isEqualToString:@"复查"]) {
        
        timeString = @"全天";
    }
    else {
        timeString = [model excTimeString];
    }
    
    [self.timeLb setText:timeString];
}

- (void)configStatusLbWithModel:(PlanMessionListItem *)model {
    if ([model.status isEqualToString:@"C"]) {
        // 复查不显示
        [self.statusLb setHidden:YES];
        return;
    }
    else {
        [self.statusLb setHidden:NO];
    }
    
    NSString *tempString = @"";
    UIColor *tempColor = [UIColor mainThemeColor];
    if ([self dateIsAfterToday:model.excTime]) {
        tempString = @"未开始";
        tempColor = [UIColor colorWithHexString:@"31c9ba" alpha:0.5];
    }
    else if ([model.status isEqualToString:@"0"]) {
        // 未开始
        tempString = model.statusName;
        tempColor = [UIColor colorWithHexString:@"31c9ba" alpha:0.5];
    }
    else if ([model.status isEqualToString:@"1"]) {
        // 待记录
        tempString = model.statusName;
        tempColor = [UIColor colorWithHexString:@"31c9ba"];
    }
    else if ([model.status isEqualToString:@"2"]) {
        // 已记录（显示已完成）
        tempString = @"已完成";
        tempColor = [UIColor colorWithHexString:@"999999"];
    }
    else if ([model.status isEqualToString:@"3"]) {
        // 已过期
        tempString = @"待记录";
        tempColor = [UIColor colorWithHexString:@"31c9ba"];
    }
   
    [self.statusLb setText:tempString];
    [self.statusLb setTextColor:tempColor];
    [self.statusLb.layer setBorderColor:tempColor.CGColor];

}

- (BOOL) dateIsAfterToday:(NSString *)dateString
{
    NSDate* planDate = [NSDate dateWithString:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
    if ([planDate isTomorrow]) {
        return YES;
    }
    if ([planDate daysFrom:[NSDate date]] > 0)
    {
        return YES;
    }
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setFont:[UIFont systemFontOfSize:20]];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"f25555"]];
        [_timeLb setText:@"1111"];
    }
    return _timeLb;
}

- (UILabel *)outDateLb {
    if (!_outDateLb) {
        _outDateLb = [UILabel new];
        [_outDateLb setFont:[UIFont systemFontOfSize:14]];
        [_outDateLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_outDateLb setText:@"未完成"];
    }
    return _outDateLb;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@"测血压"];
    }
    return _titelLb;
}

- (UILabel *)targetLb {
    if (!_targetLb) {
        _targetLb = [UILabel new];
        [_targetLb setFont:[UIFont systemFontOfSize:14]];
        [_targetLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_targetLb setText:@"1111"];
    }
    return _targetLb;
}

- (UILabel *)statusLb {
    if (!_statusLb) {
        _statusLb = [UILabel new];
        [_statusLb setFont:[UIFont systemFontOfSize:13]];
        [_statusLb setTextColor:[UIColor colorWithHexString:@"31c9ba"]];
        [_statusLb setText:@"待机了"];
        [_statusLb.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [_statusLb.layer setCornerRadius:11];
        [_statusLb.layer setBorderWidth:0.5];
        [_statusLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _statusLb;
}



@end
