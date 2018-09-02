//
//  BodyWeightDetectRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightDetectRecordTableViewCell.h"

@interface BodyWeightDetectRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbWeight;
    UILabel* lbBodyWeight;
    
    UILabel* lbUnit;
    UILabel* lbBMI;
    UILabel* lbBodyBMI;
    
    UILabel* lbDetectTime;
    
}
@end


@implementation BodyWeightDetectRecordTableViewCell

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
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        ivCircle = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"xueya_dian_02"]];
        [self.contentView addSubview:ivCircle];

        lbWeight = [[UILabel alloc]init];
        [self.contentView addSubview:lbWeight];
        [lbWeight setFont:[UIFont font_30]];
        [lbWeight setTextColor:[UIColor commonTextColor]];
        [lbWeight setText:@"体重: "];
        
        lbBodyWeight = [[UILabel alloc]init];
        [self.contentView addSubview:lbBodyWeight];
        [lbBodyWeight setFont:[UIFont font_30]];
        [lbBodyWeight setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont font_26]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        
        lbBMI = [[UILabel alloc]init];
        [self.contentView addSubview:lbBMI];
        [lbBMI setFont:[UIFont font_30]];
        [lbBMI setTextColor:[UIColor commonTextColor]];
        [lbBMI setText:@"BMI: "];
        
        lbBodyBMI = [[UILabel alloc]init];
        [self.contentView addSubview:lbBodyBMI];
        [lbBodyBMI setFont:[UIFont font_30]];
        [lbBodyBMI setTextColor:[UIColor commonTextColor]];
        
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
    
    [lbWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(12);
        make.height.mas_equalTo(@21);
    }];
    
    [lbBodyWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbWeight.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbBodyWeight.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbBMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbUnit.mas_right).with.offset(12);
        make.height.mas_equalTo(@21);
    }];
    
    [lbBodyBMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbBMI.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.height.mas_equalTo(@21);
    }];
    
}

- (void) setDetectRecord:(BodyWeightDetectRecord*) record
{
    [lbBodyWeight setText:[NSString stringWithFormat:@"%.1f", record.dataDets.TZ_SUB]];
    [lbBodyBMI setText:[NSString stringWithFormat:@"%.1f", record.bodyBMI]];
    if ([record isAlertGrade]) {
        [lbBodyWeight setTextColor:[UIColor commonRedColor]];
        [lbBodyBMI setTextColor:[UIColor commonRedColor]];
    }
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd"];
    if (!detectDate) {
        detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日"];
    [lbDetectTime setText:dateStr];
}
@end
