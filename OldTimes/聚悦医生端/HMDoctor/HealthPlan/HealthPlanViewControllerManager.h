//
//  HealthPlanViewControllerManager.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HealthPlanDetCriteriaModel;
@class HealthDetectPlanWarningModel;
@class HealthPlanDetCriteriaModel;

typedef void(^HealthPlanTemplateSelectedBlock)(HealthPlanTemplateModel* model);
typedef void(^HealthDetectPlanEditTarget)(NSArray* targets);
typedef void(^HealthDetectPlanEditAlertTimes)();
typedef void(^HealthDetectPlanEditWarningHandle)(HealthDetectPlanWarningModel* model);
typedef void(^HeathPlanFillFormEditHandle)(HealthPlanDetCriteriaModel* model);
typedef void(^HeathPlanNutritionEditHandle)(NSArray* criterias);
typedef void(^HeathPlanSuggestEditedHandle)(HealthPlanDetCriteriaModel* model);
typedef void(^HeathPlanReviewEditHandle)(HealthPlanDetCriteriaModel* model);
typedef void(^HealthPlanSingleDetectSelectBlock)(HealthPlanDetCriteriaModel* model);

typedef void(^HealthPlanSubTemplateSelectHandle)(HealthPlanDetCriteriaModel* criteriaModel);

@interface HealthPlanViewControllerManager : NSObject

+ (void) createHealthPlanTemplateViewController:(HealthPlanTemplateSelectedBlock) selectedBlock;
+ (void) createHealthPlanTemplateViewController:(NSString*) typeCode
                                  selectedBlock:(HealthPlanTemplateSelectedBlock) selectedBlock;


+ (void) createHealthPlanDetailViewController:(HealthPlanDetailModel*) detailModel
                                 defaultIndex:(NSInteger) defaultIndex;

+ (void) createHealthPlanDetectDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status;


//健康计划目标编辑界面
+ (void) createHealthPlanDetectTargetsViewController:(NSString*) kpiName
                                             kpiCode:(NSString*) kpiCode
                                             targets:(NSArray*) targets
                                         targetBlock:(HealthDetectPlanEditTarget)targetBlock;

//健康计划-单个监测模版列表
+ (void) createHealthPlanSingleDetectTemplateViewController:(NSString*) kpiCode
                                                selectBlock:(HealthPlanSingleDetectSelectBlock)selectBlock;
//健康计划-单个监测模版详情
+ (void) createHealthPlanSingleTemplateDetailViewController:(HealthPlanSingleDetectTemplateModel*) templateModel
                                                selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock;

//健康计划监测频率，提醒时间界面
+ (void) createHelathPlanDetectPeriodViewController:(HealthPlanDetCriteriaModel*) model alertTimeBlock:(HealthDetectPlanEditAlertTimes)alertTimeBlock;

//健康计划监测预警
+ (void) createHealthPlanDetectWarningEditViewController:(HealthDetectPlanWarningModel*) model kpiTitle:(NSString*) kpiTitle kpiCode:(NSString*) kpiCode editHandle:(HealthDetectPlanEditWarningHandle) editHandle;

//健康计划-随访、查房、评估界面
+ (void) createHealthPlanFillFormDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status;

//健康计划-随访、查房、评估编辑界面
+ (void) createHealthPlanFillFormEditViewController:(HealthPlanDetCriteriaModel*) model
                                               code:(NSString*) code
                                             handel:(HeathPlanFillFormEditHandle) handle;
//健康计划-营养详情界面
+ (void) createHealthPlanNutritionDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status;

+ (void) createHealthPlanNutritionEditViewController:(NSString*) typeCode editHandle:(HeathPlanNutritionEditHandle) handle;

//健康计划-营养、生活建议编辑
+ (void) createHealthPlanEditSuggestWith:(HealthPlanDetCriteriaModel*) criteriaModel editHanle:(HeathPlanSuggestEditedHandle) handle;


//健康计划-心理
+ (void) createHealthPlanMentalityDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status;

//健康计划-运动
+ (void) createHealthPlanSportsDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status ;

+ (void) createHealthPlanSportsTemplateDetailViewController:(HealthPlanTemplateModel*) templateModel selectHandle:(HealthPlanSubTemplateSelectHandle) selectHandle;

//健康计划-复查
+ (void) createHealthPlanReviewDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status;

+ (void) createHealthPlanReviewEditView:(HealthPlanDetCriteriaModel*) model
                                 handel:(HeathPlanReviewEditHandle) handle;
@end
