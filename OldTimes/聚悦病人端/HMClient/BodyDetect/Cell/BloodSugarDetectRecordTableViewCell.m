//
//  BloodSugarDetectRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectRecordTableViewCell.h"


@interface BloodSugarDetectRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbBloodSugar;
    UILabel* lbUnit;
    
    UILabel* lbDetectTime;
}
@end

@implementation BloodSugarDetectRecordTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_dian_02"]];
        [self.contentView addSubview:ivCircle];
        
        lbBloodSugar = [[UILabel alloc]init];
        [self.contentView addSubview:lbBloodSugar];
        [lbBloodSugar setFont:[UIFont font_30]];
        [lbBloodSugar setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont font_26]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setText:@"mmol/L"];
        
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
    
    [lbBloodSugar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(12);
        make.height.mas_equalTo(@21);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbBloodSugar.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.height.mas_equalTo(@21);
    }];
    
}

- (void) setDetectRecord:(BloodSugarDetectRecord*) record
{
    [lbBloodSugar setText:[NSString stringWithFormat:@"%.2f", record.bloodSugar]];
    if ([record isAlertGrade]) {
        [lbBloodSugar setTextColor:[UIColor commonRedColor]];
    }
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}

@end
