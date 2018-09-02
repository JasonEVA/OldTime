//
//  PEFDetectRecordTableViewCell.m
//  HMClient
//
//  Created by lkl on 2017/6/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFDetectRecordTableViewCell.h"

@interface PEFDetectRecord (DetectTime)

- (NSString*) detectDateString;

@end

@implementation PEFDetectRecord (DetectTime)

- (NSString*) detectDateString
{
    if (!self.testTime || self.testTime.length == 0) {
        return nil;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:self.testTime];
    if (!date)
    {
        return nil;
    }
    
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end

@interface PEFDetectRecordTableViewCell ()

@property (nonatomic, strong) UIImageView *ivCircle;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UILabel *detectTimeLabel;

@end

@implementation PEFDetectRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:self.ivCircle];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.detectTimeLabel];
        
        [self configConstraints];
    }
    return self;
}

- (void)setDetectRecord:(PEFDetectRecord *) record{
    
    [_valueLabel setAttributedText:[NSAttributedString getAttributWithChangePart:@"L/min" UnChangePart:[NSString stringWithFormat:@"%ld",record.dataDets.FLSZ_SUB] UnChangeColor:[UIColor commonTextColor] UnChangeFont:[UIFont font_26]]];

    [_periodLabel setText:@""];
    if (![record.testTimeName isEqualToString:@"无"]) {
        [_periodLabel setText:record.testTimeName];
    }
    [_detectTimeLabel setText:[record detectDateString]];
}

#pragma mark - Private Method
// 设置约束
- (void)configConstraints {
    [_ivCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_ivCircle.mas_right).with.offset(12);
    }];
    
    [_periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(100 * kScreenScale);
    }];
    
    [_detectTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
    }];
    
}


#pragma mark -- init
- (UIImageView *)ivCircle{
    if (!_ivCircle) {
        _ivCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xueya_dian_02"]];
    }
    return _ivCircle;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        [_valueLabel setFont:[UIFont font_26]];
        [_valueLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _valueLabel;
}

- (UILabel *)periodLabel{
    if (!_periodLabel) {
        _periodLabel = [UILabel new];
        [_periodLabel setFont:[UIFont font_24]];
        [_periodLabel setTextColor:[UIColor mainThemeColor]];
    }
    return _periodLabel;
}

- (UILabel *)detectTimeLabel{
    if (!_detectTimeLabel) {
        _detectTimeLabel = [UILabel new];
        [_detectTimeLabel setFont:[UIFont font_26]];
        [_detectTimeLabel setTextColor:[UIColor commonTextColor]];
    }
    return _detectTimeLabel;
}

@end
