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
#import "BloodPressureDetectViewController.h"
#import "BloodPressureManualInputViewController.h"
#import "BodyPressureDetectStartViewController.h"
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
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"PostBodyDetectResultTask" taskParam:dicPost TaskObserver:self];
        [self.view showWaitView];
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
        
        if (warningCount && warningCount.length > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"测量预警" message:@"请再次进行测量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"再次测量", nil];
            alert.tag = 0x1452;
            [alert show];
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
        
        if ([kpiCode isEqualToString:@"XD"])
        {
            //心电
//            [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
//            
//            NSLog(@"--%@",record.testValue);
            [self.upLoadSuccessView showSuccessView];
            [self.upLoadSuccessView jumpToNextStep:^{
                [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
            }];
            return;
        }
        
        if ([kpiCode isEqualToString:@"NL"])
        {
            //尿量
//            [self showAlertMessage:@"保存成功" clicked:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
            [self.upLoadSuccessView showSuccessView];
            [self.upLoadSuccessView jumpToNextStep:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            return;
        }

        [self.upLoadSuccessView showSuccessView];
        [self.upLoadSuccessView jumpToNextStep:^{
            if ([kpiCode isEqualToString:@"XY"])
            {
                //血压
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
                return;
            }
            
            if ([kpiCode isEqualToString:@"XL"])
            {
                //心率
                [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
                return;
            }
            
            
            if ([kpiCode isEqualToString:@"TZ"])
            {
                //有孕期服务不跳转结果页
                if ([_YQService isEqualToString:@"N"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
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
            
            if ([kpiCode isEqualToString:@"TEM"])
            {
                //体温
                [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectResultViewController" ControllerObject:record];
                return;
            }
        }];

        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0x1452)
    {
        if (0 == buttonIndex)
        {
            //取消,进入结果页
            warningCount = nil;
            prevWariningKpiCode = nil;
            record = [[DetectRecord alloc]init];
            [record setTestDataId:recordId];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
            return;
            
        }else
        {
            //多级预警
            switch (self.inputType)
            {
                case 1:
                {
                    //设备
                    
                    BloodPressureDetectViewController* vcdetect = (BloodPressureDetectViewController*)detectDeviceViewController;
                    [vcdetect.navigationItem setTitle:@"血压"];
                }
                    break;
                    
                case 2:
                {
                    //手动
                    BloodPressureManualInputViewController* vcdetect = (BloodPressureManualInputViewController*)detectManualViewController;
                    [vcdetect secondWaringhandle];
                }
                    break;
                    
                default:
                    break;
            }
        }
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
