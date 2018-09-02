//
//  HMOnlineArchivesTask.m
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesTask.h"
#import "HMOnlineArchivesModel.h"
#import "AdmissionAssessSummaryModel.h"
#import "HMThirdEditionPatitentDiagnoseModel.h"

@implementation HMOnlineArchivesTask

@end

@implementation getAdmissionAssessDateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getAdmissionAssessDateList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [HMAdmissionAssessDateListModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}


@end

@implementation getJbHistoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getJbHistoryList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]]){
        HMJbHistoryListModel *medicalHistoryModel = [HMJbHistoryListModel mj_objectWithKeyValues:stepResult];
        
        NSMutableArray *nowList = [NSMutableArray array];
        NSMutableArray *beforeList = [NSMutableArray array];
        NSMutableArray *familyList = [NSMutableArray array];
        
        for (NSDictionary *dic in medicalHistoryModel.nowList) {
    
            HMNowListModel *model = [HMNowListModel mj_objectWithKeyValues:dic];
            [nowList addObject:model];
        }
    
        for (NSDictionary *dic in medicalHistoryModel.beforList) {
    
            HMBeforListModel *model = [HMBeforListModel mj_objectWithKeyValues:dic];
            [beforeList addObject:model];
        }
    
        for (NSDictionary *dic in medicalHistoryModel.familyList) {
    
            HMFamilyListModel *model = [HMFamilyListModel mj_objectWithKeyValues:dic];
            [familyList addObject:model];
        }
        NSLog(@"%ld %ld %ld",nowList.count,beforeList.count,familyList.count);
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setObject:nowList forKey:@"nowList"];
        [resultDic setObject:beforeList forKey:@"beforeList"];
        [resultDic setObject:familyList forKey:@"familyList"];
        _taskResult = resultDic;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;

}

@end

//疾病风险评估概览
@implementation getAdmissionAssessSummaryTask : SingleHttpRequestTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getAdmissionAssessSummary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSArray* bfzResult = [dicResp valueForKey:@"bfzResultList"];
        NSArray* jbResult = [dicResp valueForKey:@"jbResultList"];
        
        NSMutableArray* bfzResultList = [NSMutableArray array];
        NSMutableArray* jbResultList = [NSMutableArray array];
        
        if (bfzResult && [bfzResult isKindOfClass:[NSArray class]])
        {
            [bfzResult enumerateObjectsUsingBlock:^(NSDictionary *dicbfz, NSUInteger idx, BOOL * _Nonnull stop) {
                BfzResultListModel *model = [BfzResultListModel mj_objectWithKeyValues:dicbfz];
                [bfzResultList addObject:model];
            }];
        }
        
        if (jbResult && [jbResult isKindOfClass:[NSArray class]])
        {
            [jbResult enumerateObjectsUsingBlock:^(NSDictionary *dicjb, NSUInteger idx, BOOL * _Nonnull stop) {
                HMThirdEditionPatitentDiagnoseModel *diaModel = [HMThirdEditionPatitentDiagnoseModel mj_objectWithKeyValues:dicjb];
                [jbResultList addObject:diaModel];
            }];
        }
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setObject:bfzResultList forKey:@"bfzResultList"];
        [resultDic setObject:jbResultList forKey:@"jbResultList"];
        _taskResult = resultDic;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
