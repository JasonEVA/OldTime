//
//  BreathingRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingRecordTableViewCell.h"


@interface BreathingRecordTableViewCell ()
{
    UIImageView* ivCircle;
    UILabel* lbBreathRate;
    UILabel* lbUnit;
    
    UILabel* lbDetectTime;
}
@end

@implementation BreathingRecordTableViewCell

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
        
        lbBreathRate = [[UILabel alloc]init];
        [self.contentView addSubview:lbBreathRate];
        [lbBreathRate setFont:[UIFont systemFontOfSize:15]];
        [lbBreathRate setTextColor:[UIColor commonTextColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self.contentView addSubview:lbUnit];
        [lbUnit setFont:[UIFont systemFontOfSize:13]];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setText:@"次/分"];
        
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
    
    [lbBreathRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(ivCircle.mas_right).with.offset(12);
        make.height.mas_equalTo(@21);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbBreathRate.mas_right);
        make.height.mas_equalTo(@21);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.height.mas_equalTo(@21);
    }];
    
}

- (void) setDetectRecord:(BreathingDetctRecord*) record
{
    [lbBreathRate setText:[NSString stringWithFormat:@"%ld", record.breathrate]];
    if ([record isAlertGrade]) {
        [lbBreathRate setTextColor:[UIColor commonRedColor]];
    }
    
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
    [lbDetectTime setText:dateStr];
}

@end
