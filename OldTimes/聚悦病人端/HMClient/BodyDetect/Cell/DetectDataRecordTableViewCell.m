//
//  DetectDataRecordTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectDataRecordTableViewCell.h"
#import "DetectDataRecordContentView.h"

@interface DetectDataRecordTableViewCell ()
{
    UIView* topLine;
    UIView* bottomline;
    UIView* circleView;
    UILabel* lbDate;
    UILabel* lbTime;
    
    DetectDataRecordContentView* recordview;
}
@end

@implementation DetectDataRecordTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topLine = [[UIView alloc]init];
        [topLine setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:topLine];
        
        bottomline = [[UIView alloc]init];
        [bottomline setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:bottomline];
        
        circleView = [[UIView alloc]init];
        [circleView setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:circleView];
        circleView.layer.cornerRadius = 6;
        circleView.layer.masksToBounds = YES;
        
        lbDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbDate];
        [lbDate setBackgroundColor:[UIColor clearColor]];
        [lbDate setTextColor:[UIColor commonTextColor]];
        [lbDate setFont:[UIFont font_22]];
        
        lbTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbTime];
        [lbTime setBackgroundColor:[UIColor clearColor]];
        [lbTime setTextColor:[UIColor commonTextColor]];
        [lbTime setFont:[UIFont font_22]];
        
        [self subviewLayout];
        
    }
    return self;
}

- (NSString*) recordviewclassname:(NSString*)kpiCode
{
    NSString* classname = @"DetectDataRecordContentView";
    if (!kpiCode || 0 == kpiCode.length) {
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"XY"])
    {
        classname = @"BloodPressureDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"XL"])
    {
        classname = @"HeartRateDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"TZ"])
    {
        classname = @"BodyWeightDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"XT"])
    {
        classname = @"BloodSugarDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"XZ"])
    {
        classname = @"BloodFatDataRecordContentView";
        return classname;
    }

    if ([kpiCode isEqualToString:@"OXY"])
    {
        classname = @"BloodOxygenationDataRecordContentView";
        return classname;
    }

    if ([kpiCode isEqualToString:@"NL"])
    {
        classname = @"UrineVolumeDataRecordContentView";
        return classname;
    }
   
    if ([kpiCode isEqualToString:@"HX"])
    {
        classname = @"BreathingDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"TEM"])
    {
        classname = @"BodyTemperatureDataRecordContentView";
        return classname;
    }
    
    if ([kpiCode isEqualToString:@"FLSZ"])
    {
        classname = @"PEFDataRecordContentView";
        return classname;
    }
    
    return classname;
}

- (void) subviewLayout
{
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@8.5);
        make.width.mas_equalTo(@1);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self).with.offset(51);
    }];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@12);
        make.top.equalTo(topLine.mas_bottom).with.offset(1.5);
        make.centerX.equalTo(topLine);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(circleView.mas_bottom).with.offset(1.5);
        make.left.equalTo(self.contentView).with.offset(51);
        make.bottom.equalTo(self.contentView);
    }];
    
    [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.centerY.equalTo(circleView);
        make.right.equalTo(circleView.mas_left).with.offset(-4);
    }];
    
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@13);
        make.centerX.equalTo(lbDate);
        make.top.equalTo(lbDate.mas_bottom).with.offset(2);
    }];
}

- (void) setDetectRecord:(DetectRecord*) record
{
    [lbDate setText:[record dateStr]];
    [lbTime setText:[record timeStr]];

    NSString* recordviewclass = [self recordviewclassname:record.kpiCode];
    if (recordview)
    {
        [recordview removeFromSuperview];
    }
    
    recordview = [[NSClassFromString(recordviewclass) alloc]init];
    [self.contentView addSubview:recordview];
    
    [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(2);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    
    [recordview setDetectRecord:record];
}
@end
