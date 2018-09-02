//
//  BodyDetetBaseViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetetBaseViewController.h"
#import "HMSwitchView.h"
#import "DetectInputViewController.h"
#import "DetectPlanInfo.h"
#import "DetectRecord.h"
#import "BloodPressureDetectViewController.h"
#import "BloodPressureManualInputViewController.h"
#import "UIBarButtonItem+BackExtension.h"

@interface BodyDetetBaseViewController ()
<HMSwitchViewDelegate,
TaskObserver,UINavigationControllerDelegate>
{
    HMSwitchView* inputswitchview;
    //DetectInputViewController* vcDetectInput;
    
    UITabBarController* tabbarController;
    DetectPlanInfo* planInfo;
}
@property (nonatomic, assign) BOOL isXY;
@end

@implementation BodyDetetBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self.navigationController action:@selector(backUp)];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]) {
        self.userId = self.paramObject;
    }
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicParam = self.paramObject;
        NSString* planIdStr = [dicParam valueForKey:@"taskId"];
        if (planIdStr && [planIdStr isKindOfClass:[NSString class]])
        {
            detectTaskId = planIdStr;
        }
    }
    
    if (!detectTaskId || 0 == detectTaskId.length)
    {
        [self initContentView];
        return;
    }
    else
    {
        // 获取检测计划相关信息
        [self.view showWaitView];
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:detectTaskId forKey:@"taskId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"UserDetectPlanInfoTask" taskParam:dicPost TaskObserver:self];
        
    }
}

- (void)backUp{

}
#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self) {
//        
//        return;
//        
//    } else {
//        
//        // 进入其他视图控制器,删除测量页
//        NSArray *vcs = self.navigationController.viewControllers;
//        NSMutableArray *mutvcs = [NSMutableArray arrayWithArray:vcs];
//        [mutvcs enumerateObjectsUsingBlock:^(HMBasePageViewController *VC, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([VC isKindOfClass:[BodyDetetBaseViewController class]]) {
//                [mutvcs removeObject:VC];
//            }
//        }];
//        [self.navigationController setViewControllers:[NSArray arrayWithArray:mutvcs] animated:YES];
//    }
//}

- (void) initContentView
{
    [self createSwitchView];
    
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    [tabbarController.tabBar setHidden:YES];
    [self.view addSubview:tabbarController.view];
    
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        if (inputswitchview)
        {
            make.top.equalTo(inputswitchview.mas_bottom);
        }
        else
        {
            make.top.equalTo(self.view);
            
        }
        
        make.bottom.equalTo(self.view);
    }];
    
    NSMutableArray* detectControllers = [NSMutableArray array];
    
    if (0 != (DetectInput_Device & self.allowInputType)) {
        DetectInputViewController* vcDevice = [self createDeviceInputViewController];
        [detectControllers addObject:vcDevice];
        [vcDevice setDetectTaskId:detectTaskId];
        [vcDevice setUserId:self.userId];
        //return;
        
        if ([vcDevice isKindOfClass:[BloodPressureDetectViewController class]]) {
            _isXY = YES;
        }
    }
    
    if (0 != (DetectInput_Manual & self.allowInputType)) {
        DetectInputViewController* vcDevice = [self createManualInputViewController];
        [detectControllers addObject:vcDevice];
        [vcDevice setDetectTaskId:detectTaskId];
        [vcDevice setUserId:self.userId];
        
        if ([vcDevice isKindOfClass:[BloodPressureManualInputViewController class]]) {
            _isXY = YES;
        }
    }
    
    [tabbarController setViewControllers:detectControllers];
    
    if (_isXY) {
        //如果是手动录入，则三次测量默认为手动
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([userDefaults objectForKey:@"XYManualInputTpye"]) {
            NSString *type = [userDefaults objectForKey:@"XYManualInputTpye"];
            [inputswitchview setSelectedIndex:type.integerValue];
            [tabbarController setSelectedIndex:type.integerValue];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) createSwitchView
{
    if (0 == (DetectInput_Device & self.allowInputType))
    {
        //没有设备监测
        return;
    }
    if (0 == (DetectInput_Manual & self.allowInputType))
    {
        //没有手动输入
        return;
    }
    
    inputswitchview = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 47)];
    [self.view addSubview:inputswitchview];
    
    [inputswitchview createCells:@[@"设备监测", @"手动录入"]];
    [inputswitchview setDelegate:self];
}

- (DetectInputViewController*) createDeviceInputViewController
{
    DetectInputViewController* vcDetectInput = [[NSClassFromString([self deviceInputClassName]) alloc]initWithNibName:nil bundle:nil];
   
    return vcDetectInput;
}

- (DetectInputViewController*) createManualInputViewController
{
    DetectInputViewController* vcDetectInput = [[NSClassFromString([self manualInputClassName]) alloc]initWithNibName:nil bundle:nil];
    if (planInfo)
    {
        [vcDetectInput setExcTime:planInfo.EXC_TIME];
    }
    return vcDetectInput;
}

#pragma mark - 需要在子类创建具体类
- (NSString*) deviceInputClassName
{
    return @"DetectDeviceInputViewController";
}

- (NSString*) manualInputClassName
{
    return @"DetectManualInputViewController";
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [tabbarController setSelectedIndex:selectedIndex];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self initContentView];
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserDetectPlanInfoTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[DetectPlanInfo class]])
        {
            planInfo = (DetectPlanInfo*) taskResult;
            
            if (3 == planInfo.STATUS) {
                _allowInputType &= 0x02;
            }
            
            if (planInfo.TEST_ID && 0 < planInfo.TEST_ID.length)
            {
                [self entryDetectResultController:planInfo.TEST_ID KpiCode:planInfo.KPI_CODE];
            }
        }
    }
}

- (void) entryDetectResultController:(NSString*) recordId
                             KpiCode:(NSString*) kpiCode
{
    DetectRecord* record = [[DetectRecord alloc]init];
    [record setTestDataId:recordId];
    
    if ([kpiCode isEqualToString:@"XY"])
    {
        //血压
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XL"])
    {
        //心电
        if (planInfo.SOURCE_KPI_CODE)
        {
            if ([planInfo.SOURCE_KPI_CODE isEqualToString:@"XY"])
            {
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
                return;
            }
        }
        else
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
            return;
        }
    }
    
    if ([kpiCode isEqualToString:@"TZ"])
    {
        //体重
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XT"])
    {
        //血糖
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XZ"])
    {
        //血脂
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
        return;
    }
}
@end
