//
//  SiteMessageTableViewCell.m
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SiteMessageTableViewCell.h"
#import "SiteMessageModel.h"
static const NSInteger radious = 3;
@interface SiteMessageTableViewCell()
/**
 *  文字前的✉️
 */
@property(nonatomic, strong) UIImageView  *redPoint;
/**
 *  标题
 */
@property(nonatomic, strong) UILabel  *titelLabel;
/**
 *  时间
 */
@property(nonatomic, strong) UILabel  *timeLabel;

@end

@implementation SiteMessageTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createFrame];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)setDataWithModel:(SiteMessageModel *)model
{
    self.titelLabel.text = model.msgTitle;
    self.timeLabel.text = model.createTime;
    [self.redPoint setImage:[UIImage imageNamed:@"readedMessage"]];
    if ([model.status  isEqual: @(4)]) {
        [self.redPoint setImage:[UIImage imageNamed:@"newsMessage"]];

    }
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.contentView addSubview:self.redPoint];
    [self.contentView addSubview:self.titelLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@(25));
    }];
    
    [self.titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redPoint);
        make.left.equalTo(self.redPoint.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-50);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLabel);
        make.top.equalTo(self.titelLabel.mas_bottom).offset(3);
    }];
}

#pragma mark - setterAndGetter
- (UIImageView *)redPoint
{
    if (!_redPoint){
        _redPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsMessage"]];
    }
    return _redPoint;
}


- (UILabel *)titelLabel
{
    if (!_titelLabel){
        _titelLabel = [[UILabel alloc] init];
        [_titelLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        _titelLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titelLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timeLabel;
}

@end
