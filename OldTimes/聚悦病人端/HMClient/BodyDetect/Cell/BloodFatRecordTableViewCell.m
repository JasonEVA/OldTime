//
//  BloodFatRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatRecordTableViewCell.h"

@interface BloodFatLable : UILabel
{
    UIView* leftline;
}
@end

@implementation BloodFatLable

- (id) init
{
    self = [super init];
    if (self)
    {
        leftline = [[UIView alloc]init];
        [self addSubview:leftline];
        [leftline setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [leftline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@0.5);
            make.top.and.left.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return self;
}

@end

@interface BloodFatRecordTableViewCell ()
{
    UIView* fatview;
    UIView* fatleftview;
    UIView* fatrightview;
    UIView* bottomview;
    
    UIView* timeview;
    UILabel* lbDate;
    UILabel* lbTime;
    
    BloodFatLable* lbTG;
    BloodFatLable* lbTC;
    BloodFatLable* lbHDLC;
    BloodFatLable* lbLDLC;
}
@end

@implementation BloodFatRecordTableViewCell

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
        fatview = [[UIView alloc]init];
        [self.contentView addSubview:fatview];
        [fatview setBackgroundColor:[UIColor whiteColor]];
        
        timeview = [[UIView alloc]init];
        [fatview addSubview:timeview];
        [timeview setBackgroundColor:[UIColor commonBackgroundColor]];
        
        lbDate = [[UILabel alloc]init];
        [timeview addSubview:lbDate];
        [lbDate setBackgroundColor:[UIColor clearColor]];
        [lbDate setFont:[UIFont font_20]];
        [lbDate setTextColor:[UIColor commonGrayTextColor]];
        [lbDate setTextAlignment:NSTextAlignmentCenter];
        
        lbTime = [[UILabel alloc]init];
        [fatview addSubview:lbTime];
        [lbTime setBackgroundColor:[UIColor clearColor]];
        [lbTime setFont:[UIFont font_20]];
        [lbTime setTextColor:[UIColor commonGrayTextColor]];
        [lbTime setTextAlignment:NSTextAlignmentCenter];
        
        lbTG = [[BloodFatLable alloc]init];
        [fatview addSubview:lbTG];
        [lbTG setBackgroundColor:[UIColor whiteColor]];
        [lbTG setFont:[UIFont font_24]];
        [lbTG setTextColor:[UIColor commonGrayTextColor]];
        [lbTG setTextAlignment:NSTextAlignmentCenter];
        
        lbTC = [[BloodFatLable alloc]init];
        [fatview addSubview:lbTC];
        [lbTC setBackgroundColor:[UIColor whiteColor]];
        [lbTC setFont:[UIFont font_24]];
        [lbTC setTextColor:[UIColor commonGrayTextColor]];
        [lbTC setTextAlignment:NSTextAlignmentCenter];
        
        lbHDLC = [[BloodFatLable alloc]init];
        [fatview addSubview:lbHDLC];
        [lbHDLC setBackgroundColor:[UIColor whiteColor]];
        [lbHDLC setFont:[UIFont font_24]];
        [lbHDLC setTextColor:[UIColor commonGrayTextColor]];
        [lbHDLC setTextAlignment:NSTextAlignmentCenter];
        
        lbLDLC = [[BloodFatLable alloc]init];
        [fatview addSubview:lbLDLC];
        [lbLDLC setBackgroundColor:[UIColor whiteColor]];
        [lbLDLC setFont:[UIFont font_24]];
        [lbLDLC setTextColor:[UIColor commonGrayTextColor]];
        [lbLDLC setTextAlignment:NSTextAlignmentCenter];
        
        fatleftview = [[UIView alloc]init];
        [fatview addSubview:fatleftview];
        [fatleftview setBackgroundColor:[UIColor commonControlBorderColor]];
        
        fatrightview = [[UIView alloc]init];
        [fatview addSubview:fatrightview];
        [fatrightview setBackgroundColor:[UIColor commonControlBorderColor]];
        
        bottomview = [[UIView alloc]init];
        [fatview addSubview:bottomview];
        [bottomview setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [fatview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [fatleftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fatview);
        make.height.equalTo(fatview);
        make.width.mas_equalTo(@0.5);
    }];
    
    [fatrightview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(fatview);
        make.right.equalTo(fatview.mas_right);
        make.width.mas_equalTo(@0.5);
    }];
    
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fatview);
        make.width.equalTo(fatview);
        make.bottom.equalTo(fatview);
        make.height.mas_equalTo(@0.5);
    }];
    
    [timeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fatview);
        make.width.mas_equalTo(@60);
        make.height.equalTo(fatview);
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(timeview);
        make.height.mas_equalTo(@15);
        make.top.equalTo(timeview).with.offset(2.5);
    }];
    
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(timeview);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(timeview).with.offset(-2.5);
    }];
    
    //CGFloat cellWidth = (self.contentView.width - 25 - 60)/4;
    
    [lbTG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeview.mas_right);
        make.height.equalTo(fatview);
        make.width.mas_equalTo(lbTC.mas_width);
    }];
    
    [lbTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTG.mas_right);
        make.height.equalTo(fatview);
        make.width.mas_equalTo(lbHDLC.mas_width);
    }];
    
    [lbHDLC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTC.mas_right);
        make.height.equalTo(fatview);
        make.width.mas_equalTo(lbLDLC.mas_width);
    }];
    
    [lbLDLC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbHDLC.mas_right);
        make.right.equalTo(fatview);
        make.height.equalTo(fatview);
        make.width.mas_equalTo(lbTG.mas_width);
    }];
    
}

- (void) setDetectRecord:(BloodFatRecord*) record
{
    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* detectDate = [NSDate dateWithString:record.testTime formatString:@"yyyy-MM-dd"];
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yy-MM-dd"];
    NSString* timeStr = [detectDate formattedDateWithFormat:@"HH:mm"];
    [lbDate setText:dateStr];
    [lbTime setText:timeStr];
    
    [lbTG setText:[NSString stringWithFormat:@"%.2f", record.dataDets.TG]];
    [lbTC setText:[NSString stringWithFormat:@"%.2f", record.dataDets.TC]];
    [lbHDLC setText:[NSString stringWithFormat:@"%.2f", record.dataDets.HDL_C]];
    [lbLDLC setText:[NSString stringWithFormat:@"%.2f", record.dataDets.LDL_C]];
}
@end
