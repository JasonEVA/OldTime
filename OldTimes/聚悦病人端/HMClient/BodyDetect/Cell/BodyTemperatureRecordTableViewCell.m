//
//  BodyTemperatureRecordTableViewCell.m
//  HMClient
//
//  Created by yinquan on 17/4/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureRecordTableViewCell.h"

@interface BodyTemperatureDetectRecord (DetectTime)

- (NSString*) detectDateString;

@end

@implementation BodyTemperatureDetectRecord (DetectTime)

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
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end

@interface BodyTemperatureRecordTableViewCell ()
{
    UIImageView* ivCircle;
}
@property (nonatomic, readonly) UILabel* temperatureLabel;
@property (nonatomic, readonly) UILabel* tempUnitLable;
@property (nonatomic, readonly) UILabel* detectTimeLable;

@end

@implementation BodyTemperatureRecordTableViewCell

@synthesize temperatureLabel = _temperatureLabel;
@synthesize tempUnitLable = _tempUnitLable;
@synthesize detectTimeLable = _detectTimeLable;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_dian_02"]];
        [self.contentView addSubview:ivCircle];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [ivCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(24);
    }];
    
    [self.tempUnitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.temperatureLabel.mas_right).with.offset(2);
    }];
    
    [self.detectTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

- (void) setDetectRecord:(BodyTemperatureDetectRecord*) record
{
    [self.temperatureLabel setText:record.temperature];
    [self.detectTimeLable setText:[record detectDateString]];
    
    if ([record isAlertGrade]) {
        [self.temperatureLabel setTextColor:[UIColor commonRedColor]];
    }
}

#pragma mark - settingAndGetting
- (UILabel*) temperatureLabel
{
    if (!_temperatureLabel)
    {
        _temperatureLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_temperatureLabel];
        [_temperatureLabel setTextColor:[UIColor commonTextColor]];
        [_temperatureLabel setFont:[UIFont font_30]];
        
    }
    return _temperatureLabel;
}

- (UILabel*) tempUnitLable
{
    if (!_tempUnitLable)
    {
        _tempUnitLable = [[UILabel alloc] init];
        [self.contentView addSubview:_tempUnitLable];
        [_tempUnitLable setTextColor:[UIColor commonGrayTextColor]];
        [_tempUnitLable setText:@"℃"];
        [_tempUnitLable setFont:[UIFont font_30]];
        
    }
    return _tempUnitLable;
}

- (UILabel*) detectTimeLable
{
    if (!_detectTimeLable)
    {
        _detectTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:_detectTimeLable];
        [_detectTimeLable setTextColor:[UIColor commonGrayTextColor]];
        [_detectTimeLable setFont:[UIFont font_30]];
    }
    return _detectTimeLable;
}
@end
