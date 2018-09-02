//
//  BloodSugarManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
#import "DetectRecord.h"
#import "HealthRecodUpLoadSuccessView.h"

@interface BloodSugarManualInputViewController ()<UITextFieldDelegate, UIScrollViewDelegate,TaskObserver>
{
    DeviceManualInputControl *inputControl;
    DeviceTestPeriodControl *testPeriodControl;
    
    DeviceTestTimeSelectView *testTimeView;
    BodyDetectUniversalPickerView *bloodSugarPickerView;
    BodyDetectUniversalPickerView *testPeriodPickerView;
    NSString *testPeriodCode;
}
@property (nonatomic, strong) HealthRecodUpLoadSuccessView *upLoadSuccessView;

@end

@implementation BloodSugarManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithSubViews];
}

#pragma mark - privateMethod
- (void)initWithSubViews
{
    inputControl = [[DeviceManualInputControl alloc] init];
    [inputControl setArrowHide:YES];
    [self.scrollView addSubview:inputControl];
    [inputControl setName:@"血糖" unit:@"mmol/L"];
    [inputControl addTarget:self action:@selector(inputControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    testPeriodControl = [[DeviceTestPeriodControl alloc] init];
    [self.scrollView addSubview:testPeriodControl];
    [testPeriodControl setArrowHide:YES];
    [testPeriodControl setName:@"时段"];
    [testPeriodControl addTarget:self action:@selector(testPeriodControlClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
}

- (void)subviewLayout
{
    [inputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(5);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [testPeriodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.testTimeControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(testPeriodControl.mas_bottom);
    }];
}

#pragma mark - eventRespond
//时段点击
- (void)testPeriodControlClicked
{
    if (self.comPickerView && self.comPickerView == testPeriodPickerView) {
        return;
    }
    
    [self checkForOnce];
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@"XT" forKey:@"kpiCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PostUserTestPeriodTask" taskParam:dicPost TaskObserver:self];
}

//血糖点击
- (void)inputControlClick {
    if (self.comPickerView && self.comPickerView == bloodSugarPickerView) {
        return;
    }
    [self checkForOnce];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i <= 33; i ++) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    
    NSMutableArray *pointArray = [NSMutableArray array];
    for (int j = 0; j< 10; j++) {
        [pointArray addObject:[NSString stringWithFormat:@".%@",@(j)]];
    }
    NSArray *initObj;
    if (inputControl.lbValue.text.length) {
        NSArray *totalArray = [inputControl.lbValue.text componentsSeparatedByString:@"."];
        initObj = [NSArray arrayWithObjects:[totalArray firstObject],[NSString stringWithFormat:@".%@",[totalArray lastObject]],nil];
    }else {
        //读取本地上次保存数据
//        NSArray *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeArrayWithType:@"XT_LUNCH_AFT"];
//        initObj = lastTimeNum.count ? lastTimeNum: [NSArray arrayWithObjects:@"5",@".0",nil];
        initObj = [NSArray arrayWithObjects:@"5",@".0",nil];
    }
    BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObjects:tempArray,pointArray, nil] detaultArray:initObj pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        NSString *tempStr = @"";
        for (NSString *item in selectedItems) {
            tempStr = [NSString stringWithFormat:@"%@%@",tempStr,item];
        }
        inputControl.lbValue.text = tempStr;
    }];
    self.comPickerView = pickerView;
    bloodSugarPickerView = pickerView;
    [self.view addSubview:pickerView];
    [self createAlertFrame:pickerView];
}

- (void)saveDatabuttonClick
{
    [self checkForOnce];
    NSString *bloodSugarValue = inputControl.lbValue.text;
    
    if (!bloodSugarValue && 0 == bloodSugarValue.length)
    {
        [self showAlertMessage:@"血糖输入有误，请重新输入"];
        return;
    }
//    if (![bloodSugarValue isPureFloat]) {
//        [self showAlertMessage:@"血糖输入有误，请重新输入"];
//        return;
//    }
    if (bloodSugarValue.floatValue > 33 | bloodSugarValue.floatValue < 0.1)
    {
        [self showAlertMessage:@"血糖输入有误，请重新输入"];
        return;
    }
    
    NSString *testPeriod = testPeriodControl.lbtestPeriod.text;
    if ([testPeriod isEqualToString:@"请选择时段"])
    {
        [self showAlertMessage:@"请点击选择时段"];
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:self.testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
 
    //上传数据
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"XT" forKey:@"kpiCode"];
    [dicValue setValue:bloodSugarValue forKey:testPeriodCode];
    
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];

    [self.view showWaitView];
    
    [self postDetectResult:dicResult];
    //本地保存记录，为下次打开使用
//    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"XT_LUNCH_AFT" number:@[[bloodSugarValue substringToIndex:bloodSugarValue.length - 2],[bloodSugarValue substringFromIndex:bloodSugarValue.length - 2]]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - TaskObserVer 
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (taskId)
    {
        NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
        if (!taskname && 0 < taskname.length) {
            return;
        }
        if ([taskname isEqualToString:@"PostUserTestPeriodTask"])
        {
            NSArray *testItemArray = (NSArray *)taskResult;
            if (testItemArray.count) {
                BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:testItemArray] detaultArray:[NSArray arrayWithObject:testItemArray.count>1?testItemArray[1]:[testItemArray firstObject]] pickerType:k_PickerType_BloodSugar dataCallBackBlock:^(NSMutableArray *selectedItems) {
                    NSDictionary *dict = [selectedItems firstObject];
                    testPeriodCode = [dict valueForKey:@"code"];
                    [testPeriodControl setTestPeriod:[dict valueForKey:@"name"]];
                }];
                [self.view addSubview:pickerView];
                [self createAlertFrame:pickerView];
                self.scrollView.scrollEnabled = YES;
                testPeriodPickerView = pickerView;
                self.comPickerView = pickerView;
            }else {
                [self.view showAlertMessage:@"无可选时间段"];
            }
        }else { //保存的时候进行跳转
            if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
                NSString *warningCount = (NSString*)taskResult[@"count"];
                NSString *recordId = [(NSString*) taskResult valueForKey:@"recordId"];
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
                
               DetectRecord*  record = [[DetectRecord alloc]init];
                [record setTestDataId:recordId];
                if ([kpiCode isEqualToString:@"XT"])
                {
                     //血糖
                    // 监测结果上传成功，监测图表刷新通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOADTESTSUCCESSED" object:nil];
                    
                    [self.upLoadSuccessView showSuccessView];
                    [self.upLoadSuccessView jumpToNextStep:^{
                        //先dismiss测量页
                        [self.navigationController dismissViewControllerAnimated:NO completion:^{
                            [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
                        }];
                    }];
                    return;
                }
            }
        }
        
    }
}


#pragma mark - setterAndGetter
- (HealthRecodUpLoadSuccessView *)upLoadSuccessView {
    if (!_upLoadSuccessView) {
        _upLoadSuccessView =[HealthRecodUpLoadSuccessView new];
    }
    return _upLoadSuccessView;
}
@end
