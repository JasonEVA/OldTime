//
//  HealthPlanStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanStartViewController.h"
#import "HMSwitchView.h"

//#import "MedicationPlanViewController.h"

typedef enum : NSUInteger {
    HealthPlanOverallIndex,
    HealthPlanDetectIndex,          //监测
    HealthPlanMedicationIndex,      //用药
    HealthPlanLifeStyleIndex,       //生活
    HealthPlanSurveyIndex,          //随访
    HealthPlanNutritionIndex,       //营养
    HealthPlanSportsIndex,          //运动
    HealthPlanPsychologyIndex,           //心理
    
} HealthPlanSwitchIndex;

@interface HealthPlanStartViewController ()
<HMSwitchViewDelegate>
{
    UIScrollView* switchScrollView;
    HMSwitchView* switchview;
    UIViewController* vcPlan;
}
@end

@implementation HealthPlanStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    
    [self createSwitchView];
}

- (void) createSwitchView
{
    switchScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [self.view addSubview:switchScrollView];
    
    [switchScrollView setContentSize:CGSizeMake(kScreenWidth * 2, 45)];
    
    switchview = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, 45)];
    [switchScrollView addSubview:switchview];
    [switchview createCells:@[@"总览", @"监测", @"用药", @"生活", @"随访", @"营养", @"运动", @"心理"]];
    [switchview setDelegate:self];
    
    [switchScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self createPlanController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createPlanController:(HealthPlanSwitchIndex)switchindex
{
    NSString* controllerName = [self planControllerClassName:switchindex];
    if (!controllerName || 0 == controllerName.length) {
        
        return;
    }
    
    if (vcPlan)
    {
        if ([vcPlan isKindOfClass:NSClassFromString(controllerName)])
        {
            return;
        }
        
        [vcPlan.view removeFromSuperview];
        [vcPlan removeFromParentViewController];
    }
    
    vcPlan = [[NSClassFromString(controllerName) alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcPlan];
    [self.view addSubview:vcPlan.view];
    [vcPlan.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(switchScrollView.mas_bottom);
    }];
}

- (NSString*)planControllerClassName:(HealthPlanSwitchIndex)switchindex
{
    NSString* classname = @"HealthPlanDefaultViewController";
    switch (switchindex) {
        case HealthPlanOverallIndex:
        {
            //总览
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－总揽"];
            classname = @"HealthPlanOverAllViewController";
        }
            break;
        case HealthPlanMedicationIndex:
        {
            //用药
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－用药"];
            classname = @"MedicationPlanViewController";
        }
            break;
        case HealthPlanNutritionIndex:
        {
            //营养
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－营养"];
            classname = @"NutritionPlanViewController";
        }
            break;
        case HealthPlanSportsIndex:
        {
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－运动"];
            classname = @"SportsPlanViewController";
        }
            break;
        case HealthPlanPsychologyIndex:
        {
            //心理
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－心理"];
            classname = @"PsychologyPlanViewController";
        }
            break;
        case HealthPlanLifeStyleIndex:
        {
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－生活"];
            classname = @"LifeStylePlanViewController";
        }
            break;
        case HealthPlanDetectIndex:
        {
            //监测
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－监测"];
            classname = @"DetectPlansStartViewController";
        }
            break;
        case HealthPlanSurveyIndex:
        {
            //随访
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－随访"];
            classname = @"SurveyPlansStartViewController";
        }
            break;
        default:
            break;
    }
    return classname;
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [self createPlanController:selectedIndex];
}

@end
