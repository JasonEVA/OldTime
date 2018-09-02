//
//  IntegralRecordTableViewCell.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralRecordTableViewCell.h"
#import "IntegralRecordModel.h"

@interface IntegralRecordTableViewCell ()

@property (nonatomic, strong) UILabel* remarkLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UILabel* numLabel;

@end

@implementation IntegralRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIntegralRecordModel:(IntegralRecordModel*) model
{
    [self.remarkLabel setText:model.sourceName];
    [self.dateLabel setText:nil];
    NSDate* createDate = [NSDate dateWithString:model.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    if (!createDate) {
        createDate = [NSDate dateWithString:model.createTime formatString:@"yyyy-MM-dd"];
    }
    if (createDate) {
        [self.dateLabel setText:[createDate formattedDateWithFormat:@"yyyy-MM-dd"]];
    }
    
    
    
    if (model.num > 0)
    {
        [self.numLabel setText:[NSString stringWithFormat:@"+%ld", model.num]];
        [self.numLabel setTextColor:[UIColor colorWithHexString:@"F4511E "]];
    }
    else
    {
        [self.numLabel setText:[NSString stringWithFormat:@"%ld", model.num]];
        [self.numLabel setTextColor:[UIColor colorWithHexString:@"4CAF50"]];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(7);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView).with.offset(-6);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_remarkLabel];
        
        [_remarkLabel setFont:[UIFont systemFontOfSize:15]];
        [_remarkLabel setTextColor:[UIColor commonTextColor]];
    }
    return _remarkLabel;
}

- (UILabel*) dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_dateLabel];
        
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _dateLabel;
}

- (UILabel*) numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_numLabel];
        
        [_numLabel setFont:[UIFont systemFontOfSize:15]];
        [_numLabel setTextColor:[UIColor commonTextColor]];
    }
    return _numLabel;
}

@end
