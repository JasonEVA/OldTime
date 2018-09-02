//
//  HeartRateDetectRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HeartRateDetectRecordTableViewCell.h"

@interface HeartRateDetectRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbHeartRate;
    UILabel* lbUnit;
    UILabel* lbDevice;
    
    UILabel* lbDetectTime;
}
@end

@implementation HeartRateDetectRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_dian_02"]];
        [self.contentView addSubview:ivCircle];
        
        lbHeartRate = [[UILabel alloc]init];
        [self.contentView addSubview:lbHeartRate];
        [lbHeartRate setText:@"0"];
        [lbHeartRate setFont:[UIFont font_30]];
        [lbHeartRate setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont font_26]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setText:@"次/分"];
        
        lbDevice = [[UILabel alloc]init];
        [self.contentView addSubview:lbDevice];
        [lbDevice setFont:[UIFont font_26]];
        [lbDevice setTextColor:[UIColor commonTextColor]];
        
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
    
    [lbHeartRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(6);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbHeartRate.mas_right);
    }];
    
    [lbDevice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(98);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
    }];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDetectRecord:(HeartRateDetectRecord*) record
{
    [lbHeartRate setText:[NSString stringWithFormat:@"%ld", record.heartRate]];
    if ([record isAlertGrade]) {
        [lbHeartRate setTextColor:[UIColor commonRedColor]];
    }
    
    if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XY"]){
        [lbDevice setText:@"血压计"];
    }
    else if(!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XD"]){
        [lbDevice setText:@"单导心电仪"];
    }
    else{
        [lbDevice setText:@""];
    }
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}

//心率列表
- (void) setBraceletHeartRateModel:(BraceletHeartRateModel *)model{
    [lbHeartRate setText:[NSString stringWithFormat:@"%@", model.testValue]];
    
    NSDate* detectDate = [NSDate dateWithString:model.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}
@end
