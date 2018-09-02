//
//  BodyTemperatureManualInputViewController.m
//  HMClient
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"

@interface BodyTemperatureManualInputViewController ()
<UIScrollViewDelegate>
{
    DeviceInputWeightControl* temperatureControl;
    //YinQ 王光旭要求去掉测量方式
//    DeviceInputWeightControl* bodyPartControl;
    DeviceTestTimeControl* testTimeControl;
    
    DeviceTestTimeSelectView *testTimeView;
    BodyDetectUniversalPickerView* inputTemperaturePicker;
    //YinQ 王光旭要求去掉测量方式
//    BodyDetectUniversalPickerView* inputBodyPartPicker;
    UILabel* noticeLable;
    
    UIButton* submitButton;
    NSInteger bodyPartIndex;
}

@property (nonatomic, strong) NSArray* temperatureDataArray;

@property(nonatomic, strong) UIView  *comPickerView;

@property(nonatomic, strong) NSDate  *testDate;
//YinQ 王光旭要求去掉测量方式
//@property (nonatomic, retain) NSArray* bodyPartArray;
@end

@implementation BodyTemperatureManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    //YinQ 王光旭要求去掉测量方式
//    _bodyPartArray = @[@"腋测", @"口测", @"耳测", @"肛测"];
    
    [self createSubViews];
    [self layoutSubvuews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSubViews
{
    temperatureControl = [[DeviceInputWeightControl alloc] init];
    [self.view addSubview:temperatureControl];
    [temperatureControl setName:@"体温" unit:@"℃"];
    [temperatureControl showTopLine];
    [temperatureControl showBottomLine];
    [temperatureControl addTarget:self action:@selector(temperatureControlClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"BODY_TEMP"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"36.5";
    [temperatureControl setLabelValue:defaultStr];
    
    
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [self.view addSubview:testTimeControl];
    [testTimeControl showBottomLine];
    [testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    noticeLable = [[UILabel alloc] init];
    [self.view addSubview:noticeLable];
    [noticeLable setText:@"注意：测量时请测量腋温或耳温。"];
    [noticeLable setFont:[UIFont font_24]];
    [noticeLable setTextColor:[UIColor commonLightGrayTextColor]];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitButton];
    [submitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(240, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    submitButton.layer.cornerRadius = 3;
    submitButton.layer.masksToBounds = YES;
    
    [submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) layoutSubvuews
{
    [temperatureControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(14);
        make.height.mas_equalTo(45 * kScreenScale);
    }];

    
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(temperatureControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(testTimeControl.mas_bottom).with.offset(14);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 46));
        make.top.equalTo(noticeLable.mas_bottom).with.offset(30);
    }];
}

- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        
    }
}

- (void)createAlertFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}

#pragma mark - eventRespond

- (void)testTimeControlClick
{
    if (self.comPickerView && self.comPickerView == testTimeView) {
        return;
    }
    [self checkForOnce];
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerView = testTimeView;
    [self.view addSubview:testTimeView];
    [self createAlertFrame:testTimeView];
    __weak typeof(DeviceTestTimeControl) *controlSelf = testTimeControl;
    __weak typeof(self) weakSelf = self;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *tempStr = [format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:tempStr];
        weakSelf.testDate = selectedTime;
    }];
    [testTimeView setDate:self.testDate?:[NSDate date]];
    
}

- (void) temperatureControlClicked
{
    if (self.comPickerView && self.comPickerView == inputTemperaturePicker) {
        return;
    }
    [self checkForOnce];
    NSArray *initObj;
    NSArray *totalArray;
    if (temperatureControl.lbValue.text.length) {
        totalArray = [temperatureControl.lbValue.text componentsSeparatedByString:@"."];
    }
    else
    {
        NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"BODY_TEMP"];
        NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"36.5";
        totalArray = [defaultStr componentsSeparatedByString:@"."];
        
    }
    initObj = [NSArray arrayWithObjects:[totalArray firstObject],[NSString stringWithFormat:@".%@",[totalArray lastObject]], nil];
    
    inputTemperaturePicker = [[BodyDetectUniversalPickerView alloc] initWithDataArray:self.temperatureDataArray detaultArray:initObj pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        NSString *tempStr = @"";
        for (NSString *str in selectedItems) {
            tempStr = [NSString stringWithFormat:@"%@%@",tempStr,str];
        }
        temperatureControl.lbValue.text = tempStr;
    }];
    self.comPickerView = inputTemperaturePicker;
    [self.view addSubview:inputTemperaturePicker];
    [self createAlertFrame:inputTemperaturePicker];
}


#pragma mark - setterAndGetter
- (NSArray *) temperatureDataArray {
    if (!_temperatureDataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 35;  i<= 41 ; i ++) {
            [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
        }
        NSMutableArray *temperatureDataPoint = [[NSMutableArray alloc] init];
        for (NSInteger temperaturePoint = 0; temperaturePoint < 10; temperaturePoint++)
        {
            [temperatureDataPoint addObject:[NSString stringWithFormat:@".%ld",(long)temperaturePoint]];
        }
        _temperatureDataArray = [NSMutableArray arrayWithObjects:tempArray,temperatureDataPoint,nil];
    }
    return _temperatureDataArray;
}

#pragma mark - post detect result
- (void) submitButtonClicked:(id) sender
{
    NSString* temperatureString = temperatureControl.lbValue.text;
    if (!temperatureString && temperatureString.length == 0) {
        [self showAlertMessage:@"请输入您的体温。"];
        return;
    }
    
    NSString* testTimeString = testTimeControl.lbtestTime.text;
    if (!testTimeString && testTimeString.length == 0) {
        [self showAlertMessage:@"请输入您的测量时间。"];
        return;
    }
    
    NSMutableDictionary* detectResultDist = [NSMutableDictionary dictionary];
    
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [detectResultDist setValue:@"TEM" forKey:@"kpiCode"];
    [dicValue setValue:temperatureString forKey:@"TEM_SUB"];
    
    [detectResultDist setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [self.testDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [detectResultDist setValue:timeStr forKey:@"testTime"];
    /*
     上传数据
     */
    
    [self postDetectResult:detectResultDist];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"BODY_TEMP" number:temperatureString];
    
    
    //测试跳转。。。。
//    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectResultViewController" ControllerObject:nil];
    
}
@end
