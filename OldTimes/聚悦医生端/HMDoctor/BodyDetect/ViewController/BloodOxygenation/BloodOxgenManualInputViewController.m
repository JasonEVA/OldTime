//
//  BloodOxgenManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxgenManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"

@interface BloodOxgenManualInputViewController ()
{
    DeviceManualInputControl *inputBloodOxgenControl;
    DeviceManualInputControl *inputPulseRateControl;

    BodyDetectUniversalPickerView *blookOxgenPickerview;
    BodyDetectUniversalPickerView *pluseRatePickerView;
}

@end

@implementation BloodOxgenManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithSubViews];
}

#pragma makr - privateMethod
- (void)initWithSubViews
{
    inputBloodOxgenControl = [[DeviceManualInputControl alloc] init];
    [inputBloodOxgenControl setArrowHide:YES];
    [self.scrollView addSubview:inputBloodOxgenControl];
    [inputBloodOxgenControl setName:@"血氧" unit:@"％"];
    [inputBloodOxgenControl showTopLine];
    [inputBloodOxgenControl addTarget:self action:@selector(bloodOxgenControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    inputPulseRateControl = [[DeviceManualInputControl alloc] init];
    [self.scrollView addSubview:inputPulseRateControl];
    [inputPulseRateControl setArrowHide:YES];
    [inputPulseRateControl setName:@"脉率" unit:@"次/分"];
    [inputPulseRateControl addTarget:self action:@selector(pluseRateControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveButton addTarget:self action:@selector(savebuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self subviewLayout];
}

- (void)subviewLayout
{
    [inputBloodOxgenControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(5);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [inputPulseRateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBloodOxgenControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.testTimeControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPulseRateControl.mas_bottom);
    }];
}


#pragma mark - eventRespond

- (void)bloodOxgenControlClick {
    if (self.comPickerView && self.comPickerView == blookOxgenPickerview) {
        return;
    }
    [self checkForOnce];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i <= 100; i++) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    //读取本地上次保存数据
//    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"OXY_SUB"];
//    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"90";

    NSArray *initDataArray = [NSArray arrayWithObject:inputBloodOxgenControl.lbValue.text?:@"90"];
    
    BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:tempArray] detaultArray:initDataArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        inputBloodOxgenControl.lbValue.text = [selectedItems firstObject];
    }];
    blookOxgenPickerview = pickerView;
    [self.view addSubview:pickerView];
    self.comPickerView = pickerView;
    [self createAlertFrame:pickerView];
}

- (void)pluseRateControlClick {
    
    if (self.comPickerView && self.comPickerView ==pluseRatePickerView) {
        return;
    }
    
    [self checkForOnce];
    NSMutableArray *temArray = [NSMutableArray array];
    for (int i = 1; i <= 300; i++) {
        [temArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    //读取本地上次保存数据
//    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"PULSE_RATE"];
//    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"60";
    NSArray *initDataArray = [NSArray arrayWithObject:inputPulseRateControl.lbValue.text?:@"60"];
    
    __weak DeviceManualInputControl *t = inputPulseRateControl;
    BodyDetectUniversalPickerView *pickerView =[[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:temArray] detaultArray:initDataArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        t.lbValue.text = [selectedItems firstObject];
    }];
    
    [self.view addSubview:pickerView];
    self.comPickerView = pickerView;
    pluseRatePickerView = pickerView;
    self.scrollView.scrollEnabled = YES;
    [self createAlertFrame:pickerView];

}

- (void)btnClickedOperations {
    [self.saveButton setEnabled:YES];

}

- (void)savebuttonClicked
{
    [self checkForOnce];
    if (0 == inputBloodOxgenControl.lbValue.text.floatValue)
    {
        [self showAlertMessage:@"请输入血氧值。"];
        return;
    }
    if (0 == inputPulseRateControl.lbValue.text.floatValue)
    {
        [self showAlertMessage:@"请输入脉率值。"];
        return;
    }
    
    [self.saveButton setEnabled:NO];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:3];

    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:self.testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
    
    //[self.view showWaitView];
    //上传数据
    
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"OXY" forKey:@"kpiCode"];
    [dicValue setValue:inputBloodOxgenControl.lbValue.text forKey:@"OXY_SUB"];
    [dicValue setValue:inputPulseRateControl.lbValue.text forKey:@"PULSE_RATE"];
   
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:dicResult];
    //本地保存记录，为下次打开使用
//    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"OXY_SUB" number:inputBloodOxgenControl.lbValue.text];
//    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"PULSE_RATE" number:inputPulseRateControl.lbValue.text];

}

@end
