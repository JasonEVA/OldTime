//
//  MissionCCTeamLeaderCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionCCTeamLeaderCell.h"
#import "UIFont+Util.h"

@interface MissionCCTeamLeaderCell ()

@property (nonatomic, strong) UISwitch *mySwitch;

@property (nonatomic, copy) MissionCCTeamLeaderCellBlock selectBlock;

@end
@implementation MissionCCTeamLeaderCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.mySwitch];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.bottom.equalTo(self);
            //make.right.equalTo(self.segment.mas_left);
        }];
        
        [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)switchDidSelect:(MissionCCTeamLeaderCellBlock)selectBlock {
    self.selectBlock = selectBlock;
}

- (void)switchClick
{
    if (self.selectBlock) {
        self.selectBlock(self.mySwitch.on);
    }
}

- (void)configSwitchState:(BOOL)state {
    self.mySwitch.on = state;
}

#pragma mark - Initializer
- (UISwitch *)mySwitch
{
    if (!_mySwitch) {
        _mySwitch = [UISwitch new];
        [_mySwitch addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
        [_mySwitch setOnTintColor:[UIColor mainThemeColor]];
    }
    return _mySwitch;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont systemFontOfSize:15];
    }
    return _lblTitle;
}

@end
