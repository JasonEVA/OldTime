//
//  HealthPlanDetModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanDetModel.h"
#import "HealthPlanDetCriteriaModel.h"

@implementation HealthPlanDetailModel

+ (NSDictionary *)objectClassInArray
{
    
    return @{@"dets" : [HealthPlanDetailSectionModel class]};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userIdStr" : @"userId"};
}


@end

@implementation HealthPlanDetailSectionModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"criterias" : [HealthPlanDetCriteriaModel class]};
}


- (NSString*) titleWithCode
{
    NSString* title = nil;
    if ([self.code isEqualToString:@"test"])
    {
        title = @"监测";
    }
    if ([self.code isEqualToString:@"survey"])
    {
        title = @"随访";
    }
    if ([self.code isEqualToString:@"assessment"])
    {
        title = @"评估";
    }
    if ([self.code isEqualToString:@"wards"])
    {
        title = @"查房";
    }
    if ([self.code isEqualToString:@"nutrition"])
    {
        title = @"营养";
    }
    if ([self.code isEqualToString:@"live"])
    {
        title = @"生活";
    }
    if ([self.code isEqualToString:@"mentality"])
    {
        title = @"心理";
    }

    if ([self.code isEqualToString:@"sports"])
    {
        title = @"运动";
    }
    if ([self.code isEqualToString:@"review"])
    {
        title = @"复查";
    }

    return title;
}


- (NSString*) healthyPlanDetDesc
{
    NSString* healthyPlanDetDesc = nil;
    
    if ([self.code isEqualToString:@"test"])
    {
        healthyPlanDetDesc = [self healthyPlanDetDetectDesc];
    }
    else if ([self.code isEqualToString:@"medicine"])
    {
        healthyPlanDetDesc = [self healthyPlanMedicineDetDesc];
    }
    else if ([self.code isEqualToString:@"survey"] ||
        [self.code isEqualToString:@"assessment"] ||
        [self.code isEqualToString:@"wards"])
    {
        healthyPlanDetDesc = [self healthyPlanDetFillFormDesc];
    }
    else if ([self.code isEqualToString:@"nutrition"] ||
             [self.code isEqualToString:@"live"])
    {
        healthyPlanDetDesc = [self healthyPlanDetNutritionDesc];
    }
    else if ([self.code isEqualToString:@"mentality"])
    {
        healthyPlanDetDesc = [self healthyPlanDetMantalityDesc];
    }
    else if ([self.code isEqualToString:@"sports"])
    {
        healthyPlanDetDesc = [self healthyPlanDetSportsDesc];
    }
    else if ([self.code isEqualToString:@"review"])
    {
        healthyPlanDetDesc = [self healthyPlanDetReviewDesc];
    }
    
    return healthyPlanDetDesc;
}

//用药
- (NSString*) healthyPlanMedicineDetDesc
{
    __block NSString* healthyPlanMedicineDetDesc = @"";
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (healthyPlanMedicineDetDesc && healthyPlanMedicineDetDesc.length > 0)
        {
            healthyPlanMedicineDetDesc = [healthyPlanMedicineDetDesc stringByAppendingString:@", "];
        }
        healthyPlanMedicineDetDesc = [healthyPlanMedicineDetDesc stringByAppendingFormat:@"%@", criteriaModel.drugName];
    }];
    return healthyPlanMedicineDetDesc;
}
//监测
- (NSString*) healthyPlanDetDetectDesc
{
    __block NSString* healthyPlanDetDetectDesc = @"";
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* detectAlertTimesString = criteriaModel.detectAlertTimesString;
        if (!detectAlertTimesString || detectAlertTimesString.length == 0) {
            return ;
        }
        if (healthyPlanDetDetectDesc && healthyPlanDetDetectDesc.length > 0)
        {
            healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingString:@", "];
        }
        healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingFormat:@"%@:%@", criteriaModel.kpiTitle, criteriaModel.detectAlertTimesString];
    }];
    return healthyPlanDetDetectDesc;
}


//随访、评估、查房
- (NSString*) healthyPlanDetFillFormDesc
{
    __block NSString* healthyPlanDetDetectDesc = @"";
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (healthyPlanDetDetectDesc && healthyPlanDetDetectDesc.length > 0)
        {
            healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingString:@", "];
        }
        healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingFormat:@"%@(%@)", criteriaModel.surveyMoudleName, criteriaModel.periodString];
    }];
    return healthyPlanDetDetectDesc;
}

//营养，生活
- (NSString*) healthyPlanDetNutritionDesc
{
    __block NSString* healthyPlanDetDetectDesc = @"";
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingFormat:@"%@", criteriaModel.suggest];
    }];
    return healthyPlanDetDetectDesc;
}

//心理
- (NSString*) healthyPlanDetMantalityDesc
{
    __block NSString* healthyPlanDetMantalityDesc = @"";
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (criteriaModel.target || criteriaModel.target.length == 0) {
            healthyPlanDetMantalityDesc = [NSString stringWithFormat:@"记录心情：%@", criteriaModel.mentalityPeriodString];
        }
        else
        {
            healthyPlanDetMantalityDesc = [NSString stringWithFormat:@"%@，记录心情：%@", criteriaModel.target, criteriaModel.mentalityPeriodString];
        }
        
    }];
    
    return healthyPlanDetMantalityDesc;
}

//运动
- (NSString*) healthyPlanDetSportsDesc
{
    NSString* healthyPlanDetSportsDesc = @"";
    HealthPlanDetCriteriaModel* criteriaModel = [self.criterias firstObject];
    if (criteriaModel)
    {
        healthyPlanDetSportsDesc = [NSString stringWithFormat:@"每天%@分钟，%@,推荐:", criteriaModel.sportsTimes, criteriaModel.suggest];
        __block NSString* sportTypes = @"";
        if (criteriaModel.sportType) {
            [criteriaModel.sportType enumerateObjectsUsingBlock:^(HealthSportTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.sportsName && model.sportsName.length > 0) {
                    if (sportTypes.length > 0) {
                        sportTypes = [sportTypes stringByAppendingString:@","];
                    }
                    sportTypes = [sportTypes stringByAppendingString:model.sportsName];
                }
            }];
        }
        healthyPlanDetSportsDesc = [healthyPlanDetSportsDesc stringByAppendingString:sportTypes];
    }
    return healthyPlanDetSportsDesc;
}

//复查
- (NSString*) healthyPlanDetReviewDesc
{
    __block NSString* healthyPlanDetDetectDesc = @"";
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        healthyPlanDetDetectDesc = [healthyPlanDetDetectDesc stringByAppendingFormat:@"%@(%@) ", criteriaModel.indicesName, criteriaModel.periodString];
    }];
    
    return healthyPlanDetDetectDesc;
}

- (BOOL) planDetIsValid
{
    BOOL planDetIsValid = NO;

    if ([self.code isEqualToString:@"test"]) {
        planDetIsValid = [self detectEditIsValid];
    }
    else if ([self.code isEqualToString:@"medicine"])
    {
        planDetIsValid =  YES;
    }
    else if ([self.code isEqualToString:@"survey"] ||
             [self.code isEqualToString:@"assessment"] ||
             [self.code isEqualToString:@"wards"])
    {
        planDetIsValid = [self fillFormIsValid];
    }
    
    else if ([self.code isEqualToString:@"nutrition"] ||
             [self.code isEqualToString:@"live"])
    {
        planDetIsValid = [self suggestIsValid];
    }
    else if ([self.code isEqualToString:@"mentality"])
    {
        planDetIsValid = [self mentalityIsValid];
    }
    else if ([self.code isEqualToString:@"sports"])
    {
        planDetIsValid = [self sportsIsValid];
    }
    else if ([self.code isEqualToString:@"review"])
    {
        planDetIsValid = [self reviewIsValid];
    }
    
    return planDetIsValid;
}

- (BOOL) planDetIsValidWithErrorAlert
{
    BOOL planDetIsValid = NO;
    
    if ([self.code isEqualToString:@"test"]) {
        planDetIsValid = [self detectEditIsValidWithErrorMessage];
    }
    else if ([self.code isEqualToString:@"medicine"])
    {
        planDetIsValid =  YES;
    }
    else if ([self.code isEqualToString:@"survey"] ||
             [self.code isEqualToString:@"assessment"] ||
             [self.code isEqualToString:@"wards"])
    {
        planDetIsValid = [self fillFormIsValid];
    }
    
    else if ([self.code isEqualToString:@"nutrition"] ||
             [self.code isEqualToString:@"live"])
    {
        planDetIsValid = [self suggestIsValid];
    }
    else if ([self.code isEqualToString:@"mentality"])
    {
        planDetIsValid = [self mentalityIsValid];
    }
    else if ([self.code isEqualToString:@"sports"])
    {
        planDetIsValid = [self sportsIsValid];
    }
    else if ([self.code isEqualToString:@"review"])
    {
        planDetIsValid = [self reviewIsValid];
    }
    
    return planDetIsValid;
}

- (BOOL) detectEditIsValid
{
    __block BOOL detectEditIsValid = YES;
    if (!self.criterias || self.criterias.count == 0) {
        detectEditIsValid = NO;
        return detectEditIsValid;
    }
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        detectEditIsValid = [model detectTargetsIsValid];
        if (!detectEditIsValid) {
            *stop = YES;
            
        }
        
        detectEditIsValid = [model detectAlertIsValid];
        if (!detectEditIsValid) {
            
            *stop = YES;
        }
        
        detectEditIsValid = [model detectWarningIsValid];
        if (!detectEditIsValid) {
            
            *stop = YES;
        }
        
    }];
    return detectEditIsValid;
}

- (BOOL) detectEditIsValidWithErrorMessage
{
    __block BOOL detectEditIsValid = YES;
    if (!self.criterias || self.criterias.count == 0) {
        detectEditIsValid = NO;
        return detectEditIsValid;
    }
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        detectEditIsValid = [model detectTargetsIsValid];
        if (!detectEditIsValid) {
            *stop = YES;
            NSString* alertMessage = [NSString stringWithFormat:@"%@的目标值输入不正确，请正确输入目标值。", model.kpiTitle];
            [[HMViewControllerManager topMostController] showAlertMessage:alertMessage];
        }
        
        detectEditIsValid = [model detectAlertIsValid];
        if (!detectEditIsValid) {
            NSString* alertMessage = [NSString stringWithFormat:@"%@的提醒时间输入不正确，请正确输入提醒时间。", model.kpiTitle];
            [[HMViewControllerManager topMostController] showAlertMessage:alertMessage];
            *stop = YES;
        }
        
        detectEditIsValid = [model detectWarningIsValid];
        if (!detectEditIsValid) {
            NSString* alertMessage = [NSString stringWithFormat:@"%@的预警值输入不正确，请正确输入预警值。", model.kpiTitle];
            [[HMViewControllerManager topMostController] showAlertMessage:alertMessage];
            *stop = YES;
        }
        
    }];
    return detectEditIsValid;
}


- (BOOL) fillFormIsValid
{
    __block BOOL fillFormEditIsValid = YES;
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model fillFormIsValid]) {
            fillFormEditIsValid = NO;
            *stop = YES;
        }
    }];
    
    return fillFormEditIsValid;
    
}

- (BOOL) suggestIsValid
{
    BOOL suggestIsValid = NO;
    
    if (!self.criterias || self.criterias.count == 0) {
        return suggestIsValid;
    }
    
    HealthPlanDetCriteriaModel* model = self.criterias.firstObject;
    if (model.suggest && model.suggest.length > 0) {
        suggestIsValid = YES;
    }
    
    return suggestIsValid;
}

- (BOOL) mentalityIsValid
{
    BOOL mentalityIsValid = NO;
    if (!self.criterias || self.criterias.count == 0) {
        return mentalityIsValid;
    }
    
    HealthPlanDetCriteriaModel* model = self.criterias.firstObject;
    
    //频率
    if (!model.periodType ||
        model.periodType.length == 0 ||
        ![model.periodType mj_isPureInt])
    {
        return mentalityIsValid;
    }
    
    if (!model.periodValue ||
        model.periodValue.length == 0 ||
        ![model.periodValue mj_isPureInt] ||
        model.periodValue.integerValue == 0)
    {
        return mentalityIsValid;
    }
    mentalityIsValid = YES;
    return mentalityIsValid;
}

- (BOOL) sportsIsValid
{
    BOOL sportsIsValid = NO;
    if (!self.criterias || self.criterias.count == 0) {
        return sportsIsValid;
    }
    
    HealthPlanDetCriteriaModel* model = self.criterias.firstObject;
    
    //运动时间
    if (!model.sportsTimes || model.sportsTimes.length == 0) {
        return sportsIsValid;
    }
    
    //运动强度
    if (!model.exerciseIntensity || model.exerciseIntensity.length == 0 ||
        ![model.exerciseIntensity mj_isPureInt]) {
        return sportsIsValid;
    }
    
    if (!model.sportType || model.sportType.count == 0) {
        return sportsIsValid;
    }
    
    sportsIsValid = YES;
    return sportsIsValid;
}

- (BOOL) reviewIsValid
{
    __block BOOL reviewIsValid = YES;
    if (!self.criterias || self.criterias.count == 0) {
        reviewIsValid = NO;
        return reviewIsValid;
    }
    
    [self.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model reviewIsValid]) {
            reviewIsValid = NO;
            *stop = YES;
        }
    }];

    return reviewIsValid;
}
@end

