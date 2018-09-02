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
@property (nonatomic, strong) DeviceTestTimeSelectView *testTimeView;

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
// 设置元素控件
- (void)configElements {
    [self.scrollView addSubview:self.hrInputControl];
    
    [_hrInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).with.offset(5);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];

    [self.testTimeControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hrInputControl.mas_bottom);
    }];
}

- (void)checkForOnce {
    [_hrInputControl.tfValue resignFirstResponder];
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        
    }
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
    __weak typeof(DeviceTestTimeControl) *controlSelf = self.testTimeControl;
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
- (void)saveDatabuttonClick
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
    
    NSString* testTimeString = self.testTimeControl.lbtestTime.text;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
