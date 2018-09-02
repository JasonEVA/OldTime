//
//  BloodPressureDetectRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDetectRecordTableViewCell.h"

@interface BloodPressureDetectRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbPressure;
    UILabel* lbUnit;
    UILabel* lbDetectNum;
    UILabel* lbDetectTime;
}
@end

@implementation BloodPressureDetectRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_dian_02"]];
        [self.contentView addSubview:ivCircle];
        
        lbPressure = [[UILabel alloc]init];
        [self.contentView addSubview:lbPressure];
        [lbDetectTime setFont:[UIFont font_30]];
        [lbDetectTime setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont font_26]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setText:@"mmHg"];
        
        lbDetectNum = [[UILabel alloc]init];
        [self.contentView addSubview:lbDetectNum];
        [lbDetectNum setFont:[UIFont font_26]];
        [lbDetectNum setTextColor:[UIColor mainThemeColor]];
        [lbDetectNum setText:@"1次"];
        
        lbDetectTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont font_26]];
        [lbDetectTime setTextColor:[UIColor commonGrayTextColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbPressure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(12);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbPressure.mas_right);
    }];
    
    [lbDetectNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(140 * kScreenScale);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
    }];

}

- (void) setDetectRecord:(BloodPressureDetectRecord*) record
{
    [lbPressure setText:[NSString stringWithFormat:@"%ld/%ld", record.dataDets.SSY, record.dataDets.SZY]];
    if ([record isAlertGrade]) {
        [lbPressure setTextColor:[UIColor commonRedColor]];
    }
    
    [lbDetectNum setText:[NSString stringWithFormat:@"%@次",record.testCount]];
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}
@end
