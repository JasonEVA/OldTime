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

@interface BloodOxgenManualInputViewController ()<UIScrollViewDelegate>
{
    DeviceInputWeightControl *inputBloodOxgenControl;
    DeviceInputWeightControl *inputPulseRateControl;
    DeviceTestTimeControl *testTimeControl;
    
    DeviceTestTimeSelectView *testTimeView;
    BodyDetectUniversalPickerView *blookOxgenPickerview;
    BodyDetectUniversalPickerView *pluseRatePickerView;
    UIView *toplineView;
    UIButton *saveButton;
}

@property(nonatomic, strong) NSDate  *testDate;

@property(nonatomic, strong) UIScrollView  *scrollview;
@property(nonatomic, strong) UIView  *comPickerView;

@end

@implementation BloodOxgenManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initWithSubViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

#pragma makr - privateMethod

- (void)initWithSubViews
{
    inputBloodOxgenControl = [[DeviceInputWeightControl alloc] init];
    [inputBloodOxgenControl setArrowHide:YES];
    [self.scrollview addSubview:inputBloodOxgenControl];
    [inputBloodOxgenControl setName:@"血氧" unit:@"％"];
    [inputBloodOxgenControl addTarget:self action:@selector(bloodOxgenControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    toplineView = [[UIView alloc] init];
    [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [self.scrollview addSubview:toplineView];
    
    
    inputPulseRateControl = [[DeviceInputWeightControl alloc] init];
    [self.scrollview addSubview:inputPulseRateControl];
    [inputPulseRateControl setArrowHide:YES];
    [inputPulseRateControl setName:@"脉率" unit:@"次/分"];
    [inputPulseRateControl addTarget:self action:@selector(pluseRateControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [testTimeControl setArrowHide:YES];
    [self.scrollview addSubview:testTimeControl];
    [testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.excTime && 0 < self.excTime.length) {
        NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
        [testTimeControl.lbtestTime setText:dateStr];
    }
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton.layer setMasksToBounds:YES];
    [saveButton.layer setCornerRadius:5.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont: [UIFont font_30]];
    [saveButton setBackgroundColor:[UIColor mainThemeColor] ];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollview addSubview:saveButton];
    [saveButton addTarget:self action:@selector(savebuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self subviewLayout];
}

- (void)subviewLayout
{
    [inputBloodOxgenControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollview);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollview);
    }];

    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBloodOxgenControl.mas_top);
        make.width.equalTo(self.scrollview);
        make.height.mas_equalTo(1);
    }];
    
    [inputPulseRateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBloodOxgenControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollview);
    }];
    
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPulseRateControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollview);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(testTimeControl.mas_bottom).with.offset(30);
        make.width.equalTo(@(ScreenWidth - 30));
        make.height.mas_equalTo(45);
    }];
}

- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        self.scrollview.contentOffset = CGPointMake(0, 0);
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
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"OXY_SUB"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"90";

    NSArray *initDataArray = [NSArray arrayWithObject:inputBloodOxgenControl.lbValue.text?:defaultStr];
    
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
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"PULSE_RATE"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"60";
    NSArray *initDataArray = [NSArray arrayWithObject:inputPulseRateControl.lbValue.text?:defaultStr];
    
    __weak DeviceInputWeightControl *t = inputPulseRateControl;
    BodyDetectUniversalPickerView *pickerView =[[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:temArray] detaultArray:initDataArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        t.lbValue.text = [selectedItems firstObject];
    }];
    
    [self.view addSubview:pickerView];
    self.comPickerView = pickerView;
    pluseRatePickerView = pickerView;
    self.scrollview.scrollEnabled = YES;
    [self createAlertFrame:pickerView];

}

- (void)btnClickedOperations {
    [saveButton setEnabled:YES];

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
    
    [saveButton setEnabled:NO];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:3];

    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:testTimeControl.lbtestTime.text];
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
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"OXY_SUB" number:inputBloodOxgenControl.lbValue.text];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"PULSE_RATE" number:inputPulseRateControl.lbValue.text];

}

#pragma mark - setterAndGetter
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.scrollEnabled = YES;
        _scrollview.directionalLockEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.alwaysBounceHorizontal = NO;
        _scrollview.alwaysBounceVertical = YES;
        _scrollview.bounces = YES;
    }
    return _scrollview;
}

@end
