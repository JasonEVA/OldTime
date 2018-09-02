//
//  BloodOxygenationRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenationRecordTableViewCell.h"

@interface BloodOxygenationRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbBloodOxygen;
    UILabel* lbUnit;
    
    UILabel* lbDetectTime;
}
@end

@implementation BloodOxygenationRecordTableViewCell

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
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_ys_dian"]];
        [self.contentView addSubview:ivCircle];
        
        lbBloodOxygen = [[UILabel alloc]init];
        [self.contentView addSubview:lbBloodOxygen];
        [lbBloodOxygen setFont:[UIFont systemFontOfSize:15]];
        [lbBloodOxygen setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont systemFontOfSize:13]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setText:@"%"];
        
        lbDetectTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont systemFontOfSize:13]];
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
    
    [lbBloodOxygen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(12);
        make.height.mas_equalTo(@21);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbBloodOxygen.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.height.mas_equalTo(@21);
    }];
    
}

- (void) setDetectRecord:(BloodOxygenationRecord*) record
{
    [lbBloodOxygen setText:[NSString stringWithFormat:@"%ld", record.dataDets.OXY_SUB]];
    if ([record isAlertGrade]) {
        [lbBloodOxygen setTextColor:[UIColor commonRedColor]];
    }
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}
@end
