//
//  HeartRateManualInputViewController.m
//  HMClient
//
//  Created by lkl on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HeartRateManualInputViewController.h"

@interface HeartRateManualInputViewController ()

@property (nonatomic, strong) DeviceInputControl *hrInputControl;
@property (nonatomic, strong) DeviceTestTimeControl* testTimeControl;
@property (nonatomic, strong) DeviceTestTimeSelectView *testTimeView;
@property (nonatomic, strong) UIButton *submitButton;
@property(nonatomic, strong) UIView  *comPickerView;
@property(nonatomic, strong) NSDate  *testDate;

@end

@implementation HeartRateManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置元素控件
    [self configElements];
}

#pragma mark - Interface Method

#pragma mark - Private Method
// 设置约束
- (void)configElements {
    [self.view addSubview:self.hrInputControl];
    [self.view addSubview:self.testTimeControl];
    [self.view addSubview:self.submitButton];
    
    [_hrInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(10);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_hrInputControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 46));
        make.top.equalTo(_testTimeControl.mas_bottom).with.offset(30);
    }];
}

- (void)checkForOnce {
    [_hrInputControl.tfValue resignFirstResponder];
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

#pragma mark - Event Response
- (void)hrInputControlClicked
{
    [_hrInputControl.tfValue becomeFirstResponder];
    
    //读取本地上次保存数据
    //    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"FLSZ_SUB"];
    //    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"0";
    //    [_PEFInputControl.tfValue setText:defaultStr];
}

- (void)testTimeControlClick
{
    [_hrInputControl.tfValue resignFirstResponder];
    
    if (self.comPickerView && self.comPickerView == _testTimeView) {
        return;
    }
    [self checkForOnce];
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    _testTimeView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerView = _testTimeView;
    [self.view addSubview:_testTimeView];
    [self createAlertFrame:_testTimeView];
    __weak typeof(DeviceTestTimeControl) *controlSelf = _testTimeControl;
    __weak typeof(self) weakSelf = self;
    [_testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *tempStr = [format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:tempStr];
        weakSelf.testDate = selectedTime;
    }];
    [_testTimeView setDate:self.testDate?:[NSDate date]];
    
}

//上传数据
- (void)submitButtonClicked:(UIButton *)sender
{
    [self checkForOnce];
    [_hrInputControl.tfValue resignFirstResponder];
    
    NSString *hrValue = _hrInputControl.tfValue.text;
    
    if (kStringIsEmpty(hrValue) || hrValue.integerValue <= 0 || hrValue.integerValue >= 200) {
        [self showAlertMessage:@"请输入1～200的心率值"];
        return;
    }
    
    unichar single = [hrValue characterAtIndex:0];
    if (single == '0') {
        [self showAlertMessage:@"心率输入有误，请重新输入"];
        return;
    }
    
    NSString* testTimeString = _testTimeControl.lbtestTime.text;
    if (kStringIsEmpty(testTimeString)) {
        [self showAlertMessage:@"请输入您的测量时间。"];
        return;
    }
    
    NSMutableDictionary* detectResultDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicValue setValue:hrValue forKey:@"XL_SUB"];
    
    [detectResultDic setValue:@"XL" forKey:@"kpiCode"];
    [detectResultDic setValue:dicValue forKey:@"testValue"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:testTimeString];
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [detectResultDic setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:detectResultDic];
    
}

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Action

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init
- (DeviceInputControl *)hrInputControl{
    if (!_hrInputControl) {
        _hrInputControl = [[DeviceInputControl alloc] init];
        [_hrInputControl setName:@"心率" unit:@"次/分"];
        [_hrInputControl showTopLine];
        [_hrInputControl.tfValue setKeyboardType:UIKeyboardTypeNumberPad];
        [_hrInputControl addTarget:self action:@selector(hrInputControlClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hrInputControl;
}
- (DeviceTestTimeControl *)testTimeControl{
    if (!_testTimeControl) {
        _testTimeControl = [[DeviceTestTimeControl alloc] init];
        [_testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.excTime && 0 < self.excTime.length) {
            NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
            [_testTimeControl.lbtestTime setText:dateStr];
        }
    }
    return _testTimeControl;
}
- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_submitButton];
        [_submitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(240, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_submitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        _submitButton.layer.cornerRadius = 3;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
