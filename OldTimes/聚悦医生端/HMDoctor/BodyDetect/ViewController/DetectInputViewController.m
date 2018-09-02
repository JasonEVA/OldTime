//
//  DetectInputViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectInputViewController.h"
#import "BodyDetetBaseViewController.h"
#import "DetectRecord.h"
//#import "BloodPressureDetectViewController.h"
//#import "BloodPressureManualInputViewController.h"
//#import "BodyPressureDetectStartViewController.h"
#import "HealthRecodUpLoadSuccessView.h"

@interface DetectInputViewController ()
<TaskObserver>
{
    NSString* warningCount;
    NSString* prevWariningKpiCode;
    DetectManualInputViewController* detectManualViewController;
    DetectDeviceInputViewController* detectDeviceViewController;
    DetectRecord* record;
    NSString* recordId;
}
@property (nonatomic, strong) HealthRecodUpLoadSuccessView *upLoadSuccessView;
@property (nonatomic, strong) NSString *YQService;
@end

@implementation DetectInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上传检测结果
- (void) postDetectResult:(id) dicResult
{
    //PostBodyDetectResultTask
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)dicResult];
        [dicPost setValue:self.userId forKey:@"userId"];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", self.inputType] forKey:@"inputMode"];
        if (_detectTaskId && 0 < _detectTaskId.length)
        {
            [dicPost setValue:_detectTaskId forKey:@"taskId"];
        }

        if (warningCount && warningCount.length > 0)
        {
            [dicPost setValue:[NSString stringWithFormat:@"%@",warningCount] forKey:@"count"];
        }
        
        //prevWariningKpiCode
        if (prevWariningKpiCode && prevWariningKpiCode.length > 0)
        {
            [dicPost setValue:[NSString stringWithFormat:@"%@",prevWariningKpiCode] forKey:@"prevWariningKpiCode"];
        }
        
        [self.view showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"PostBodyDetectResultTask" taskParam:dicPost TaskObserver:self];
        
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self.view closeWaitView];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    NSLog(@"%@",taskResult);
    
    if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
    {
        // 监测结果上传成功，监测图表刷新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOADTESTSUCCESSED" object:nil];

        warningCount = (NSString*)taskResult[@"count"];
        prevWariningKpiCode = (NSString*) taskResult[@"prevWariningKpiCode"];
        recordId = [(NSString*) taskResult valueForKey:@"recordId"];
        _YQService = [(NSString*) taskResult valueForKey:@"YQService"];
        
        if (!recordId || ![recordId isKindOfClass:[NSString class]] || 0 == recordId.length) {
            return;
        }
        
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        NSString* kpiCode = nil;
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            kpiCode = [dicParam valueForKey:@"kpiCode"];
        }
        if (!kpiCode || ![kpiCode isKindOfClass:[NSString class]] || 0 == kpiCode.length)
        {
            return;
        }
        
        record = [[DetectRecord alloc]init];
        [record setTestDataId:recordId];
        [record setKpiCode:kpiCode];

        [self.upLoadSuccessView showSuccessView];
        [self.upLoadSuccessView jumpToNextStep:^{
            
            //先dismiss测量页
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
                if ([kpiCode isEqualToString:@"XY"]){
                    //血压
                    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
                    return;
                }
                
                if ([kpiCode isEqualToString:@"XD"]) {
                    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
                    return;
                }
                
                if ([kpiCode isEqualToString:@"XL"]){
                    //心率
                    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
                    return;
                }
                
                if ([kpiCode isEqualToString:@"XT"]){
                    //血糖
                    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
                    return;
                }
                
                if ([kpiCode isEqualToString:@"OXY"]){
                    //血氧
                    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
                    return;
                }
            }];
        }];
    }
}


- (HealthRecodUpLoadSuccessView *)upLoadSuccessView {
    if (!_upLoadSuccessView) {
        _upLoadSuccessView =[HealthRecodUpLoadSuccessView new];
    }
    return _upLoadSuccessView;
}

@end


@implementation DetectDeviceInputViewController

- (void)viewDidLoad {
    self.inputType = DetectInput_Device;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isAppear = NO;
}

@end

@implementation DetectManualInputViewController

- (void)viewDidLoad {
    self.inputType = DetectInput_Manual;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
}

@end
