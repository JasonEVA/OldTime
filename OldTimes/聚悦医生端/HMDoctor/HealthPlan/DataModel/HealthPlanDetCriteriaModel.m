//
//  HealthPlanDetCriteriaModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanDetCriteriaModel.h"

@implementation HealthPlanDetCriteriaModel

- (NSString*) periodTypeString
{

    NSString* unitString = @"";
    
    switch (self.periodType.integerValue) {
        case 1:
        {
            unitString = @"周";
            break;
        }
        case 2:
        {
            unitString = @"日";
            break;
        }
        case 3:
        {
            unitString = @"月";
            break;
        }
        default:
            break;
    }

    return unitString;
}

//心理的PeriodTypeString
- (NSString*) mentalityPeriodTypeString
{
    
    NSString* unitString = @"";
    
    switch (self.periodType.integerValue) {
        case 2:
        {
            unitString = @"周";
            break;
        }
        case 3:
        {
            unitString = @"日";
            break;
        }
        case 1:
        {
            unitString = @"月";
            break;
        }
        default:
            break;
    }
    
    return unitString;
}

- (NSString*) periodString
{
    NSString* periodString = nil;
    if (!self.periodType || self.periodType.length == 0) {
        return @"";
    }
    
    NSString* unitString = self.periodTypeString;
    
    if (self.alertTimes && self.alertTimes.count > 0) {
        if (self.periodValue.integerValue == 1)
        {
            periodString = [NSString stringWithFormat:@"每%@%ld次", unitString, self.alertTimes.count];
        }
        else
        {
            periodString = [NSString stringWithFormat:@"每%@%@%ld次", self.periodValue, unitString, self.alertTimes.count];
        }

    }
    else
    {
        if (self.periodValue.integerValue == 1)
        {
            periodString = [NSString stringWithFormat:@"每%@1次", unitString];
        }
        else
        {
            periodString = [NSString stringWithFormat:@"每%@%@1次", self.periodValue, unitString];
        }

    }
    
    return periodString;
}

- (NSString*) mentalityPeriodString
{
    NSString* periodString = nil;
    if (!self.periodType || self.periodType.length == 0) {
        return @"";
    }
    
    NSString* unitString = self.mentalityPeriodTypeString;
    
    if (self.alertTimes && self.alertTimes.count > 0) {
        if (self.periodValue.integerValue == 1)
        {
            periodString = [NSString stringWithFormat:@"每%@%ld次", unitString, self.alertTimes.count];
        }
        else
        {
            periodString = [NSString stringWithFormat:@"每%@%@%ld次", self.periodValue, unitString, self.alertTimes.count];
        }
        
    }
    else
    {
        if (self.periodValue.integerValue == 1)
        {
            periodString = [NSString stringWithFormat:@"每%@1次", unitString];
        }
        else
        {
            periodString = [NSString stringWithFormat:@"每%@%@1次", self.periodValue, unitString];
        }
        
    }
    
    return periodString;
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"alertTimes" : [HealthDetectPlanAlertModel class],
             @"testTargets" : [HealthDetectPlanTargetModel class],
             @"warnings" : [HealthDetectPlanWarningModel class],
             @"sportType" : [HealthSportTypeModel class]};
}

- (NSString*) detectTargetString
{
    __block NSString* detectTargetString = @"";
    [self.testTargets enumerateObjectsUsingBlock:^(HealthDetectPlanTargetModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* targetValueString = [model targetValueString];
        if (!targetValueString || targetValueString.length == 0) {
            return ;
        }
        
        if (detectTargetString.length > 0)
        {
            detectTargetString = [detectTargetString stringByAppendingString:@", "];
        }
        detectTargetString = [detectTargetString stringByAppendingString:[model targetValueString]];
    }];
    return detectTargetString;
}

//检测提醒时间
- (NSString*) detectAlertTimesString
{
    __block NSString* detectAlertTimesString = @"";
    if (!self.alertTimes || self.alertTimes.count == 0) {
        return detectAlertTimesString;
    }
    [self.alertTimes enumerateObjectsUsingBlock:^(HealthDetectPlanAlertModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (detectAlertTimesString.length > 0)
        {
            detectAlertTimesString = [detectAlertTimesString stringByAppendingString:@", "];
        }
        detectAlertTimesString = [detectAlertTimesString stringByAppendingString:model.alertTime];
    }];
    
    detectAlertTimesString = [NSString stringWithFormat:@"%@(%@)", [self periodString], detectAlertTimesString];
    return detectAlertTimesString;
}

//监测单位
- (NSString*) detectUnitText
{
    NSString* unitText = @"";
    if (!self.kpiCode || self.kpiCode.length == 0) {
        return unitText;
    }
    
    if ([self.kpiCode isEqualToString:@"XY"])
    {
        //血压
        unitText = @"mmHg";
    }
    if ([self.kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        unitText = @"次/分钟";
    }
    if ([self.kpiCode isEqualToString:@"XL"])
    {
        //心率
        unitText = @"次/分";
    }
    if ([self.kpiCode isEqualToString:@"TZ"])
    {
        //体重
        unitText = @"kg";
    }
    if ([self.kpiCode isEqualToString:@"XT"])
    {
        //血糖
        unitText = @"mmol/l";
    }
    if ([self.kpiCode isEqualToString:@"NL"])
    {
        //尿量
        unitText = @"ml";
    }
    if ([self.kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        unitText = @"%";
    }
    return unitText;
}

- (NSString*) sportStrength
{
    NSString* sportStrength = @"";
    NSArray* strengthSuggests = @[@"轻柔", @"低强", @"稍强"];
    if (self.exerciseIntensity && [self.exerciseIntensity mj_isPureInt] &&
        self.exerciseIntensity.integerValue > 0 && self.exerciseIntensity.integerValue <= strengthSuggests.count)
    {
        sportStrength = strengthSuggests[self.exerciseIntensity.integerValue - 1];
    }
    
    return sportStrength;
}

- (BOOL) detectTargetsIsValid
{
    __block BOOL targetsIsValid = YES;
    if (self.testTargets)
    {
        [self.testTargets enumerateObjectsUsingBlock:^(HealthDetectPlanTargetModel* targetModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((targetModel.targetValue && targetModel.targetValue.length > 0) ||
                (targetModel.targetMaxValue && targetModel.targetMaxValue.length > 0))
            {
                if (!targetModel.targetValue || targetModel.targetValue.length == 0) {
                    *stop = YES;
                    targetsIsValid = NO;
                    return ;
                }
                
                if (!targetModel.targetMaxValue || targetModel.targetMaxValue.length == 0) {
                    *stop = YES;
                    targetsIsValid = NO;
                    return ;
                }
                
                if (targetModel.targetMaxValue.floatValue <= targetModel.targetValue.floatValue)
                {
                    *stop = YES;
                    targetsIsValid = NO;
                    return ;
                }
                
                return ;
            }
        }];
    }
    
    return targetsIsValid;
}

- (BOOL) detectAlertIsValid
{
    BOOL alertIsValid = NO;
    //频率
    if (!self.periodType ||
        self.periodType.length == 0 ||
        ![self.periodType mj_isPureInt])
    {
        return alertIsValid;
    }
    
    if (!self.periodValue ||
        self.periodValue.length == 0 ||
        ![self.periodValue mj_isPureInt] ||
        self.periodValue.integerValue == 0)
    {
        return alertIsValid;
    }
    
    //提醒时间
//    if (!self.alertTimes || self.alertTimes.count == 0) {
//        return alertIsValid;
//    }
    
    alertIsValid = YES;
    return alertIsValid;
}

- (BOOL) detectWarningIsValid
{
    __block BOOL warningIsValid = YES;
    
    if (!self.warnings || self.warnings.count == 0) {
        return warningIsValid;
    }

    [self.warnings enumerateObjectsUsingBlock:^(HealthDetectPlanWarningModel* warningModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!warningModel.oneKpiCode || warningModel.oneKpiCode.length == 0)
        {
            warningIsValid = NO;
            *stop = YES;
            return ;
        }
        
        if (!warningModel.oneEndSymbol || warningModel.oneEndSymbol.length == 0) {
            warningIsValid = NO;
            *stop = YES;
            return ;
        }
        
        if (!warningModel.oneEndValue || warningModel.oneEndValue.length == 0) {
            warningIsValid = NO;
            *stop = YES;
            return ;
        }
        
        if (warningModel.oneBeginSymbol && warningModel.oneBeginSymbol.length > 0) {
            if (!warningModel.oneBeginValue || warningModel.oneBeginValue.length == 0) {
                warningIsValid = NO;
                *stop = YES;
                return ;
            }
        }
        
        if (warningModel.twoKpiCode && warningModel.twoKpiCode.length > 0) {
            if (!warningModel.twoEndSymbol || warningModel.twoEndSymbol.length == 0) {
                warningIsValid = NO;
                *stop = YES;
                return ;
            }
            
            if (!warningModel.twoEndValue || warningModel.twoEndValue.length == 0) {
                warningIsValid = NO;
                *stop = YES;
                return ;
            }
            
            if (warningModel.twoBeginSymbol && warningModel.twoBeginSymbol.length > 0) {
                if (!warningModel.twoBeginValue || warningModel.twoBeginValue.length == 0) {
                    warningIsValid = NO;
                    *stop = YES;
                    return ;
                }
            }
        }
    }];
    
    return warningIsValid;
}

- (BOOL) fillFormIsValid
{
    BOOL fillFormIsValid = NO;
    
    if (!self.surveyMoudleName || self.surveyMoudleName.length == 0) {
        return fillFormIsValid;
    }
    
    //频率
    if (!self.periodType ||
        self.periodType.length == 0 ||
        ![self.periodType mj_isPureInt])
    {
        return fillFormIsValid;
    }
    
    if (!self.periodValue ||
        self.periodValue.length == 0 ||
        ![self.periodValue mj_isPureInt] ||
        self.periodValue.integerValue == 0)
    {
        return fillFormIsValid;
    }
    
    fillFormIsValid = YES;
    return fillFormIsValid;
}

- (BOOL) reviewIsValid
{
    BOOL reviewIsValid = NO;
    
    if (!self.indicesName || self.indicesName.length == 0) {
        return reviewIsValid;
    }
    
    if (!self.indicesCode || self.indicesCode.length == 0) {
        return reviewIsValid;
    }
    
    //频率
    if (!self.periodType ||
        self.periodType.length == 0 ||
        ![self.periodType mj_isPureInt])
    {
        return reviewIsValid;
    }
    
    if (!self.periodValue ||
        self.periodValue.length == 0 ||
        ![self.periodValue mj_isPureInt] ||
        self.periodValue.integerValue == 0)
    {
        return reviewIsValid;
    }
    
    reviewIsValid = YES;
    return reviewIsValid;
}
@end

@implementation HealthDetectPlanAlertModel



@end

@implementation HealthDetectPlanTargetModel

- (NSString*) targetValueString
{
    NSString* targetValueString = @"";
    
    if (!self.kpiName || self.kpiName.length == 0) {
        return targetValueString;
    }
    
    if (!self.targetValue || self.targetValue.length == 0) {
        return targetValueString;
    }
    if (!self.targetMaxValue || self.targetMaxValue.length == 0) {
        return targetValueString;
    }
    
    targetValueString = [NSString stringWithFormat:@"%@%@-%@", self.kpiName, self.targetValue, self.targetMaxValue];
    
    return targetValueString;
}
@end

@implementation HealthDetectPlanWarningModel

- (NSString*) warningString
{
    NSString* warningString;
    
    NSString* oneWarningString = [self oneWarningString];
    NSString* twoWarningString = [self twoWarningString];
    NSString* relationString = [self relationString];
    
    if (relationString && relationString.length > 0)
    {
        if (!oneWarningString || oneWarningString.length == 0) {
            return warningString;
        }
        if (!twoWarningString || twoWarningString.length == 0) {
            return warningString;
        }
        warningString = [NSString stringWithFormat:@"%@%@%@", oneWarningString, relationString, twoWarningString];
    }
    else
    {
        warningString = oneWarningString;
    }
    
    return warningString;
}

- (NSString*) oneWarningString
{
    NSString* oneWarningString = nil;
    switch (self.signsId.integerValue)
    {
        case 1:
            //高值预警
        {
            if (!self.oneKpiName || self.oneKpiName.length == 0) {
                return oneWarningString;
            }
            if (!self.oneEndValue || self.oneEndValue.length == 0) {
                return oneWarningString;
            }
            oneWarningString = [NSString stringWithFormat:@"%@>%@", self.oneKpiName, self.oneEndValue];
            break;
        }
        case 2:
            //低值预警
            if (!self.oneKpiName || self.oneKpiName.length == 0) {
                return oneWarningString;
            }
            if (!self.oneEndValue || self.oneEndValue.length == 0) {
                return oneWarningString;
            }
            oneWarningString = [NSString stringWithFormat:@"%@<%@", self.oneKpiName, self.oneEndValue];
            break;
        case 3:
            //自定义
            if (!self.oneKpiName || self.oneKpiName.length == 0) {
                return oneWarningString;
            }
            if (!self.oneEndValue || self.oneEndValue.length == 0) {
                return oneWarningString;
            }
            if (!self.oneBeginValue || self.oneBeginValue.length == 0) {
                return oneWarningString;
            }
            oneWarningString = [NSString stringWithFormat:@"%@<%@<%@", self.oneBeginValue, self.oneKpiName, self.oneEndValue];
            break;
        default:
            break;
    }
    /*
    if ((self.oneBeginSymbol && self.oneBeginSymbol.length > 0) &&
        (self.oneBeginValue && self.oneBeginValue.length > 0))
    {
        oneWarningString = [NSString stringWithFormat:@"%@%@%@%@%@", self.oneBeginValue, self.oneBeginSymbol, self.oneKpiName, self.oneEndSymbol, self.oneEndValue];
    }
    else if((self.oneEndSymbol && self.oneEndSymbol.length > 0) &&
            (self.oneEndValue && self.oneEndValue.length > 0))
    {
        oneWarningString = [NSString stringWithFormat:@"%@%@%@", self.oneKpiName, self.oneEndSymbol, self.oneEndValue];
    }
     */
    return oneWarningString;
}

- (NSString*) twoWarningString
{
    NSString* twoWarningString = nil;
    
    switch (self.signsId.integerValue) {
        case 1:
            //高值预警
        {
            if (!self.twoKpiName || self.twoKpiName.length == 0) {
                return twoWarningString;
            }
            if (!self.twoEndValue || self.twoEndValue.length == 0) {
                return twoWarningString;
            }
            twoWarningString = [NSString stringWithFormat:@"%@>%@", self.twoKpiName, self.twoEndValue];
            break;
        }
        case 2:
            //低值预警
            if (!self.twoKpiName || self.twoKpiName.length == 0) {
                return twoWarningString;
            }
            if (!self.twoEndValue || self.twoEndValue.length == 0) {
                return twoWarningString;
            }
            twoWarningString = [NSString stringWithFormat:@"%@<%@", self.twoKpiName, self.twoEndValue];
            break;
        case 3:
            //自定义
            if (!self.twoKpiName || self.twoKpiName.length == 0) {
                return twoWarningString;
            }
            if (!self.twoEndValue || self.twoEndValue.length == 0) {
                return twoWarningString;
            }
            if (!self.twoBeginValue || self.twoBeginValue.length == 0) {
                return twoWarningString;
            }
            twoWarningString = [NSString stringWithFormat:@"%@<%@<%@", self.twoBeginValue, self.twoKpiName, self.twoEndValue];
            break;
        default:
            break;
    }
    return twoWarningString;
}

- (NSString*) relationString
{
    NSString* relationString = nil;
    if (self.oneTwoRelation && self.oneTwoRelation.length > 0)
    {
        if ([self.oneTwoRelation isEqualToString:@"||"]) {
            relationString = @"或";
        }
        if ([self.oneTwoRelation isEqualToString:@"&&"]) {
            relationString = @"且";
        }
    }
    else
    {
        if (self.twoKpiCode && self.twoKpiCode.length > 0) {
            relationString = @"且";
        }
        
    }
    return relationString;
}

- (NSString*) signsId
{
    if (!_signsId || ![_signsId mj_isPureInt]) {
        HealthDetectWarningType warningIdentificationType = [self warningIdentificationType];
        switch (warningIdentificationType) {
            case WarningType_Custom:
            {
                _signsId = @"3";
                break;
            }
            case WarningType_High:
            {
                _signsId = @"1";
                break;
            }
            case WarningType_Low:
            {
                _signsId = @"2";
                break;
            }
            default:
                break;
        }
    }
    return _signsId;
}

- (HealthDetectWarningType) warningIdentificationType
{
    
    if (self.oneBeginValue && self.oneBeginValue.length > 0)
    {
        return WarningType_Custom;
    }
    
    if ([self.oneEndSymbol isEqualToString:@"<"] ||
        [self.oneEndSymbol isEqualToString:@"<="] )
    {
        return WarningType_High;
    }
    else
    {
        return WarningType_Low;
    }
}

- (NSString*) warningIdentificationTypeString
{
    HealthDetectWarningType warningIdentificationType = self.signsId.integerValue;
    switch (warningIdentificationType) {
        case WarningType_Unknown:
        {
            return @"请选择";
            break;
        }
        case WarningType_Custom:
        {
            return @"自定义";
            break;
        }
        case WarningType_High:
        {
            return @"高值预警";
            break;
        }
        case WarningType_Low:
        {
            return @"低值预警";
            break;
        }
    }
    return nil;
}

@end

@implementation HealthSportTypeModel

@end
