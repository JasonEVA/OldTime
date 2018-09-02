//
//  HealthPlanViewControllerManager.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanViewControllerManager.h"

#import "HealthPlanDetailPagedViewController.h"

#import "HealthPlanTemplateSelectViewController.h"
#import "HealthPlanDetectDetailViewController.h"
#import "HealthDetectTargetEditViewController.h"
#import "HealthDetectPeriodEditViewController.h"
#import "HealthDetectWarningEditViewController.h"
#import "HealthPlanSingleDetectTemplateTableViewController.h"

#import "HealthFillFormDetailViewController.h"
#import "HeathPlanFillFormEditViewController.h"

#import "HealthPlanNutritionDetailViewController.h"
#import "HealthPlanNutritionEditViewController.h"
#import "HealthPlanEditSuggestViewController.h"



#import "HealthPlanMentailitDetailViewController.h"

#import "HealthPlanSportsDetailViewController.h"
#import "HealthPlanSportTemplateDetailViewController.h"

#import "HealthPlanReviewDetailViewController.h"
#import "HealthPlanReviewEditViewController.h"
#import "HealthPlanSingleDetectTemplateDetailViewController.h"

@implementation HealthPlanViewControllerManager

+ (void) createHealthPlanTemplateViewController:(HealthPlanTemplateSelectedBlock) selectedBlock
{
    HealthPlanTemplateSelectViewController* viewController = [[HealthPlanTemplateSelectViewController alloc] initWithTypeCode:@"healthy" selectedBlock:selectedBlock];
    HMBaseNavigationViewController* navigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:viewController];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController presentViewController:navigationController animated:YES completion:nil];
    
}

+ (void) createHealthPlanTemplateViewController:(NSString*) typeCode
                                  selectedBlock:(HealthPlanTemplateSelectedBlock) selectedBlock
{
    HealthPlanTemplateSelectViewController* viewController = [[HealthPlanTemplateSelectViewController alloc] initWithTypeCode:typeCode selectedBlock:selectedBlock];
    HMBaseNavigationViewController* navigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:viewController];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController presentViewController:navigationController animated:YES completion:nil];
    
}

+ (void) createHealthPlanDetailViewController:(HealthPlanDetailModel*) detailModel
                                 defaultIndex:(NSInteger) defaultIndex
{
    HealthPlanDetailPagedViewController* detailViewController =  [[HealthPlanDetailPagedViewController alloc] initWithDetailModel:detailModel defaultIndex:defaultIndex];
    [HMViewControllerManager entryPageViewController:detailViewController];
}

+ (void) createHealthPlanDetectDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status
{
    HealthPlanDetectDetailViewController* planDetailViewController = [[HealthPlanDetectDetailViewController alloc] initWithDetailModel:sectionModel status:status];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanDetectTargetsViewController:(NSString*) kpiName
                                             kpiCode:(NSString*) kpiCode
                                             targets:(NSArray*) targets
                                         targetBlock:(HealthDetectPlanEditTarget)targetBlock
{
    HealthDetectTargetEditViewController* editviewController = [[HealthDetectTargetEditViewController alloc] initWithKpiName:kpiName kpiCode:kpiCode targets:targets editTargetBlock:targetBlock];
    [HMViewControllerManager entryPageViewController:editviewController];
}

+ (void) createHelathPlanDetectPeriodViewController:(HealthPlanDetCriteriaModel*) model
                                     alertTimeBlock:(HealthDetectPlanEditAlertTimes)alertTimeBlock
{
    HealthDetectPeriodEditViewController* editViewController = [[HealthDetectPeriodEditViewController alloc] initWithCriteriaModel:model];
    [editViewController setAlertTimesBlock:alertTimeBlock];
    [HMViewControllerManager entryPageViewController:editViewController];
}

+ (void) createHealthPlanDetectWarningEditViewController:(HealthDetectPlanWarningModel*) model kpiTitle:(NSString*) kpiTitle kpiCode:(NSString*) kpiCode editHandle:(HealthDetectPlanEditWarningHandle) editHandle
{
    HealthDetectWarningEditViewController* editViewController = [[HealthDetectWarningEditViewController alloc] initWithHealthDetectPlanWarningModel:model kpiTitle:kpiTitle kpiCode:kpiCode ];
    [editViewController setEditHandle:editHandle];
    
    [HMViewControllerManager entryPageViewController:editViewController];
}

+ (void) createHealthPlanSingleDetectTemplateViewController:(NSString*) kpiCode
                                                selectBlock:(HealthPlanSingleDetectSelectBlock)selectBlock
{
    //HealthPlanSingleDetectTemplateTableViewController
    HealthPlanSingleDetectTemplateTableViewController* tableViewController = [[HealthPlanSingleDetectTemplateTableViewController alloc] initWithKpiCode:kpiCode selectBlock:selectBlock];
    HMBaseNavigationViewController* navigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:tableViewController];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController presentViewController:navigationController animated:YES completion:nil];
}


+ (void) createHealthPlanSingleTemplateDetailViewController:(HealthPlanSingleDetectTemplateModel*) templateModel
                                                selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock
{
    HealthPlanSingleDetectTemplateDetailViewController* detailViewController =  [[HealthPlanSingleDetectTemplateDetailViewController alloc] initWithTemplateModel:templateModel selectBlock:selectBlock];
    [HMViewControllerManager entryPageViewController:detailViewController];
}

+ (void) createHealthPlanFillFormDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status
{
    HealthFillFormDetailViewController* planDetailViewController = [[HealthFillFormDetailViewController alloc] initWithDetailModel:sectionModel status:status];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanFillFormEditViewController:(HealthPlanDetCriteriaModel*) model
                                               code:(NSString*) code
                                             handel:(HeathPlanFillFormEditHandle) handle
{
    HeathPlanFillFormEditViewController* editViewController = [[HeathPlanFillFormEditViewController alloc] initWithHealthPlanDetCriteriaModel:model code:code handle:handle];
    
    [HMViewControllerManager entryPageViewController:editViewController];
}

+ (void) createHealthPlanNutritionDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status
{
    HealthPlanNutritionDetailViewController* planDetailViewController = [[HealthPlanNutritionDetailViewController alloc] initWithDetailModel:sectionModel status:status];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanNutritionEditViewController:(NSString*) typeCode editHandle:(HeathPlanNutritionEditHandle) handle
{
    HealthPlanNutritionEditViewController* editViewController = [[HealthPlanNutritionEditViewController alloc] initWithTypeCode:typeCode editHandle:handle];
    [HMViewControllerManager entryPageViewController:editViewController];
}

+ (void) createHealthPlanEditSuggestWith:(HealthPlanDetCriteriaModel*) criteriaModel editHanle:(HeathPlanSuggestEditedHandle) handle
{
    HealthPlanEditSuggestViewController* editViewController = [[HealthPlanEditSuggestViewController alloc] initWithHealthPlanDetCriteriaModel:criteriaModel editHandle:handle];
    [HMViewControllerManager entryPageViewController:editViewController];
}


+ (void) createHealthPlanMentalityDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status
{
    HealthPlanMentailitDetailViewController* planDetailViewController = [[HealthPlanMentailitDetailViewController alloc] initWithDetailModel:sectionModel status:status];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanSportsDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status  
{
    HealthPlanSportsDetailViewController* planDetailViewController = [[HealthPlanSportsDetailViewController alloc] initWithDetailModel:sectionModel status:status ];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanSportsTemplateDetailViewController:(HealthPlanTemplateModel*) templateModel selectHandle:(HealthPlanSubTemplateSelectHandle) selectHandle
{
    HealthPlanSportTemplateDetailViewController* detailViewController = [[HealthPlanSportTemplateDetailViewController alloc] initWithHealthPlanTemplateModel:templateModel selectHandle:selectHandle];
    [HMViewControllerManager entryPageViewController:detailViewController];
}

+ (void) createHealthPlanReviewDetailViewController:(HealthPlanDetailSectionModel*) sectionModel status:(NSString*) status
{
    HealthPlanReviewDetailViewController* planDetailViewController = [[HealthPlanReviewDetailViewController alloc] initWithDetailModel:sectionModel status:status ];
    [HMViewControllerManager entryPageViewController:planDetailViewController];
}

+ (void) createHealthPlanReviewEditView:(HealthPlanDetCriteriaModel*) model
                                 handel:(HeathPlanReviewEditHandle) handle
{
    HealthPlanReviewEditViewController* viewController = [[HealthPlanReviewEditViewController alloc] initWithHealthPlanDetCriteriaModel:model handle:handle];
    [HMViewControllerManager entryPageViewController:viewController];
}
@end
