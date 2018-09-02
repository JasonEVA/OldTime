//
//  MissionAddMissionPatientTableView.m
//  HMDoctor
//
//  Created by jasonwang on 16/7/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionAddMissionPatientTableView.h"
#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 130)

@implementation MissionAddMissionPatientTableView
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.contentLb];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);
        }];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLb).priorityMedium();
            make.left.equalTo(self.titelLb.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-3).priorityLow();
        }];
    }
    return self;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setTextColor:[UIColor commonDarkGrayColor_666666]];
    }
    return _titelLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UILabel new];
        [_contentLb setFont:[UIFont systemFontOfSize:15]];
        [_contentLb setTextColor:[UIColor commonBlackTextColor_333333]];
        [_contentLb setNumberOfLines:0];
        [_contentLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _contentLb.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLb.preferredMaxLayoutWidth = W_MAX;
    }
    return _contentLb;
}

@end
