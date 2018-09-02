//
//  DetectDataRecordContentView.m
//  HMClient
//
//  Created by yinqaun on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectDataRecordContentView.h"

#import "BloodPressureDetectRecord.h"
#import "HeartRateDetectRecord.h"
#import "BodyWeightDetectRecord.h"
#import "BloodSugarDetectRecord.h"
#import "BloodFatRecord.h"
#import "BloodOxygenationRecord.h"
#import "UrineVolumeRecord.h"
#import "BreathingDetctRecord.h"
#import "PEFDetectRecord.h"

@implementation DetectRecord (DataRecord)

- (NSString*) recordname
{
    NSString* kpi = self.kpiCode;
    if (!kpi || 0 == kpi.length)
    {
        return nil;
    }
    
    if ([kpi isEqualToString:@"XY"])
    {
        return @"血压";
    }
    
    if ([kpi isEqualToString:@"XL"])
    {
        return @"心率";
    }
    
    if ([kpi isEqualToString:@"TZ"])
    {
        return @"体重";
    }
    
    if ([kpi isEqualToString:@"XT"])
    {
        return @"血糖";
    }
    
    if ([kpi isEqualToString:@"XZ"])
    {
        return @"血脂";
    }
    
    if ([kpi isEqualToString:@"OXY"])
    {
        return @"血氧";
    }
    
    if ([kpi isEqualToString:@"NL"])
    {
        return @"尿量";
    }
    
    if ([kpi isEqualToString:@"HX"])
    {
        return @"呼吸";
    }
    if ([kpi isEqualToString:@"TEM"])
    {
        return @"体温";
    }
    
    if ([kpi isEqualToString:@"FLSZ"])
    {
        return @"峰流速值";
    }
    
    return nil;
}

- (CGFloat) recordCellHeight
{
    CGFloat cellHeight = 80;
    NSString* kpi = self.kpiCode;
    if (!kpi || 0 == kpi.length)
    {
        return cellHeight;
    }
    
    if ([kpi isEqualToString:@"XZ"])
    {
        cellHeight = 170;
    }

    if ([kpi isEqualToString:@"TZ"])
    {
        cellHeight = 100;
    }
    
    return cellHeight;
}
@end

@interface DetectDataRecordContentView ()
{
    UIImageView* ivBackground;
    
    
}
@end

@implementation DetectDataRecordContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];
        
        [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:14]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.top.equalTo(self).with.offset(14);
        }];
        
        lbUserResult = [[UILabel alloc]init];
        [self addSubview:lbUserResult];
        [lbUserResult setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbUserResult setFont:[UIFont systemFontOfSize:13]];
    
        
        [lbUserResult mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.bottom.equalTo(ivBackground).with.offset(-12);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
        lbValueUnit = [[UILabel alloc]init];
        [self addSubview:lbValueUnit];
        [lbValueUnit setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbValueUnit setFont:[UIFont systemFontOfSize:14]];
        
        [lbValueUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbName);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
        lbValue = [[UILabel alloc]init];
        [self addSubview:lbValue];
        [lbValue setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbValue setFont:[UIFont systemFontOfSize:14]];
        
        [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbName);
            make.right.equalTo(lbValueUnit.mas_left).with.offset(-2);
        }];
    
    }
    return self;
}

- (void) setDetectRecord:(DetectRecord*) record
{
    [lbName setText:[record recordname]];
    if (record.userAlertResult)
    {
        [lbUserResult setText:[NSString stringWithFormat:@"测量结果:%@", record.userAlertResult]];
    }
    [lbUserResult setHidden:NO];
    
    if ([record isAlertGrade] && ![record.kpiCode isEqualToString:@"NL"]) {
        [lbValue setTextColor:[UIColor commonRedColor]];
    }
}

@end

@implementation BloodPressureDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BloodPressureDetectRecord* bpRecord = (BloodPressureDetectRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%ld/%ld", bpRecord.dataDets.SSY, bpRecord.dataDets.SZY]];
    [lbValueUnit setText:@"mmHg"];
}

@end


@implementation HeartRateDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    NSString* name = [record recordname];
    if (record.sourceKpiCode && 0 < record.sourceKpiCode.length && [record.sourceKpiCode isEqualToString:@"XY"]){
         name = [name stringByAppendingString:@"(血压计)"];
    }
    else if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XD"]){
         name = [name stringByAppendingString:@"(心电仪)"];
    }
    else{
        
    }
    [lbName setText:name];
    if (record.userAlertResult)
    {
        [lbUserResult setText:[NSString stringWithFormat:@"测量结果:%@", record.userAlertResult]];
    }
    [lbUserResult setHidden:NO];
    HeartRateDetectRecord* hrRecord = (HeartRateDetectRecord*) record;
    if ([hrRecord.kpiCode isEqualToString:@"XL"]) {
        [lbValue setText:[NSString stringWithFormat:@"%ld", hrRecord.dataDets.XL_SUB]];
    }
    else{
        [lbValue setText:[NSString stringWithFormat:@"%ld", hrRecord.heartRate]];
    }
    [lbValueUnit setText:@"次/分"];
    if ([record isAlertGrade]) {
        [lbValue setTextColor:[UIColor commonRedColor]];
    }
}

@end


@interface BodyWeightDataRecordContentView ()
{
    UIImageView* ivBackground;
    UILabel *lbBMIName;
    UILabel *lbBMIValue;
    
}
@end

@implementation BodyWeightDataRecordContentView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [self addSubview:ivBackground];
        
        [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:14]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.top.equalTo(self).with.offset(14);
        }];
        

        
        lbValueUnit = [[UILabel alloc]init];
        [self addSubview:lbValueUnit];
        [lbValueUnit setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbValueUnit setFont:[UIFont systemFontOfSize:14]];
        
        [lbValueUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbName);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
        lbValue = [[UILabel alloc]init];
        [self addSubview:lbValue];
        [lbValue setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbValue setFont:[UIFont systemFontOfSize:14]];
        
        [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbName);
            make.right.equalTo(lbValueUnit.mas_left).with.offset(-2);
        }];
        
        lbBMIName = [[UILabel alloc]init];
        [self addSubview:lbBMIName];
        [lbBMIName setTextColor:[UIColor commonTextColor]];
        [lbBMIName setFont:[UIFont systemFontOfSize:14]];
        [lbBMIName setText:@"BMI"];
        
        [lbBMIName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.top.equalTo(lbName.mas_bottom).with.offset(8);
        }];
        
        lbBMIValue = [[UILabel alloc]init];
        [self addSubview:lbBMIValue];
        [lbBMIValue setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbBMIValue setFont:[UIFont systemFontOfSize:14]];
        
        [lbBMIValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbValue.mas_bottom).with.offset(8);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
        lbUserResult = [[UILabel alloc]init];
        [self addSubview:lbUserResult];
        [lbUserResult setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbUserResult setFont:[UIFont systemFontOfSize:13]];
        
        
        [lbUserResult mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(22);
            make.bottom.equalTo(ivBackground).with.offset(-12);
            make.right.lessThanOrEqualTo(self).with.offset(-8);
        }];
        
    }
    return self;
}


- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BodyWeightDetectRecord* bwRecord = (BodyWeightDetectRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%.1f", bwRecord.dataDets.TZ_SUB]];
    [lbBMIValue setText:[NSString stringWithFormat:@"%.1f",bwRecord.dataDets.TZ_BMI]];
    if ([record isAlertGrade]) {
        [lbBMIValue setTextColor:[UIColor commonRedColor]];
    }
    [lbValueUnit setText:@"kg"];
}

@end


@implementation BloodSugarDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BloodSugarDetectRecord* bsRecord = (BloodSugarDetectRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%.2f", bsRecord.bloodSugar]];
    [lbValueUnit setText:@"mmol/L"];
}

@end

@interface BloodFatDataRecordContentView ()
{
    UILabel* lbTC;
    UILabel* lbTG;
    UILabel* lbHDLC;
    UILabel* lbLDLC;
    UILabel* lbDivision;
}
@end

@implementation BloodFatDataRecordContentView

- (id) init
{
    self = [super init];
    if (self)
    {
        UILabel* lbTCName = [[UILabel alloc]init];
        [self addSubview:lbTCName];
        [lbTCName setText:@"TC"];
        [lbTCName setFont:[UIFont systemFontOfSize:13]];
        [lbTCName setTextColor:[UIColor commonTextColor]];
        [lbTCName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbName.mas_bottom).with.offset(5);
        }];
        
        lbTC = [[UILabel alloc]init];
        [self addSubview:lbTC];
        [lbTC setFont:[UIFont systemFontOfSize:13]];
        [lbTC setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbTC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbValue);
            make.top.equalTo(lbTCName);
        }];
        
        
        UILabel* lbTGName = [[UILabel alloc]init];
        [self addSubview:lbTGName];
        [lbTGName setText:@"TG"];
        [lbTGName setFont:[UIFont systemFontOfSize:13]];
        [lbTGName setTextColor:[UIColor commonTextColor]];
        [lbTGName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbTCName.mas_bottom).with.offset(5);
        }];
        
        lbTG = [[UILabel alloc]init];
        [self addSubview:lbTG];
        [lbTG setFont:[UIFont systemFontOfSize:13]];
        [lbTG setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbTG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbValue);
            make.top.equalTo(lbTGName);
        }];

        UILabel* lbHDLCName = [[UILabel alloc]init];
        [self addSubview:lbHDLCName];
        [lbHDLCName setText:@"HDL-C"];
        [lbHDLCName setFont:[UIFont systemFontOfSize:13]];
        [lbHDLCName setTextColor:[UIColor commonTextColor]];
        [lbHDLCName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbTGName.mas_bottom).with.offset(5);
        }];
        
        lbHDLC = [[UILabel alloc]init];
        [self addSubview:lbHDLC];
        [lbHDLC setFont:[UIFont systemFontOfSize:13]];
        [lbHDLC setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbHDLC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbValue);
            make.top.equalTo(lbHDLCName);
        }];
        
        UILabel* lbLDLCName = [[UILabel alloc]init];
        [self addSubview:lbLDLCName];
        [lbLDLCName setText:@"LDL-C"];
        [lbLDLCName setFont:[UIFont systemFontOfSize:13]];
        [lbLDLCName setTextColor:[UIColor commonTextColor]];
        [lbLDLCName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbHDLCName.mas_bottom).with.offset(5);
        }];
        
        lbLDLC = [[UILabel alloc]init];
        [self addSubview:lbLDLC];
        [lbLDLC setFont:[UIFont systemFontOfSize:13]];
        [lbLDLC setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbLDLC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbValue);
            make.top.equalTo(lbLDLCName);
        }];
        
        UILabel* lbDivisionName = [[UILabel alloc]init];
        [self addSubview:lbDivisionName];
        [lbDivisionName setText:@"TC/HDL-C"];
        [lbDivisionName setFont:[UIFont systemFontOfSize:13]];
        [lbDivisionName setTextColor:[UIColor commonTextColor]];
        [lbDivisionName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbLDLCName.mas_bottom).with.offset(5);
        }];
        
        lbDivision = [[UILabel alloc]init];
        [self addSubview:lbDivision];
        [lbDivision setFont:[UIFont systemFontOfSize:13]];
        [lbDivision setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbDivision mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbValue);
            make.top.equalTo(lbDivisionName);
        }];
    }
    
    return self;
}
- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    [lbUserResult setHidden:YES];
    BloodFatRecord* bfRecord = (BloodFatRecord*) record;
    [lbTC setText:[NSString stringWithFormat:@"%.2fmmol/L", bfRecord.dataDets.TC]];
    [lbTG setText:[NSString stringWithFormat:@"%.2fmmol/L", bfRecord.dataDets.TG]];
    [lbHDLC setText:[NSString stringWithFormat:@"%.2fmmol/L", bfRecord.dataDets.HDL_C]];
    [lbLDLC setText:[NSString stringWithFormat:@"%.2fmmol/L", bfRecord.dataDets.LDL_C]];
    [lbDivision setText:[NSString stringWithFormat:@"%.2f", bfRecord.dataDets.TC_DIVISION_HDL_C]];
}

@end

@implementation BloodOxygenationDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BloodOxygenationRecord* boRecord = (BloodOxygenationRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%ld%%", boRecord.dataDets.OXY_SUB]];
    [lbValueUnit setText:@""];
}

@end

@implementation UrineVolumeDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];

    UrineVolumeRecord* uvRecord = (UrineVolumeRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%ld", uvRecord.urineVolume]];
    [lbName setText:[NSString stringWithFormat:@"%@", uvRecord.timeType]];
    [lbValueUnit setText:@"ml"];
}

@end



@implementation BreathingDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BreathingDetctRecord* bthRecord = (BreathingDetctRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%ld", bthRecord.breathrate]];
    [lbValueUnit setText:@"次/分"];
}

@end

#import "BodyTemperatureDetectRecord.h"

@implementation BodyTemperatureDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    [super setDetectRecord:record];
    
    BodyTemperatureDetectRecord* temRecord = (BodyTemperatureDetectRecord*) record;
    [lbValue setText:[NSString stringWithFormat:@"%@", temRecord.temperature]];
    [lbValueUnit setText:@"℃"];
}

@end

@implementation PEFDataRecordContentView

- (void) setDetectRecord:(DetectRecord*) record
{
    //[super setDetectRecord:record];
    NSString* name = [record recordname];
    
    PEFDetectRecord *pefRecord = (PEFDetectRecord*) record;
    
    [lbName setText:name];
    //无症状
    if (![pefRecord.testTimeName isEqualToString:@"无"] && !kStringIsEmpty(pefRecord.testTimeName))
    {
        //[lbName setAttributedText:[NSAttributedString getAttributWithUnChangePart:name changePart:[NSString stringWithFormat:@" (%@)",pefRecord.testTimeName] changeColor:[UIColor commonGrayTextColor] changeFont:[UIFont font_26]]];
        
        [lbUserResult setText:pefRecord.testTimeName];
        [lbUserResult setHidden:NO];
    }
    
    [lbValue setText:[NSString stringWithFormat:@"%ld", pefRecord.dataDets.FLSZ_SUB]];
    [lbValueUnit setText:@"L/min"];
}

@end
