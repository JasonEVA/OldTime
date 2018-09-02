//
//  BloodPressureManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureManualInputViewController.h"
#import "DeviceSelectTestTimeView.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
#import "BloodPressureThreeDetectViewController.h"
#import "NSDate+MsgManager.h"

static NSString *const BloodPressureDetectResultNotify = @"BloodPressureDetectResultValue";
static NSString *const BloodPressureDetectTimeCompare = @"onceDetectTime";

@interface BloodPressureManualInputViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIPickerView        *pickerView;
    UIView              *dateView;
    UIDatePicker        *datePicker;
    UIView *toplineView;
    UIButton *confirmBtn;
    DeviceInputWeightControl *inputHeartRateControl; //心率输入
    DeviceTestTimeControl *testTimeControl;    //测试时间cell
    DeviceTestTimeSelectView *testTimeView;    //测试时间选择控件
    DeviceInputWeightControl *pressureControl; //收缩压／舒张压
    
    BodyDetectUniversalPickerView *pressurePickerView;
    BodyDetectUniversalPickerView *ratePickerView;

}
@property(nonatomic,strong)NSArray      *pickerData;
@property(nonatomic,copy)NSString       *highTension;
@property(nonatomic,copy)NSString       *lowTension;
@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *compickerView;

@property (nonatomic, assign) BOOL isThriceDetect;
@property (nonatomic,copy) NSString *onceDetectTimeStr;
@end

@implementation BloodPressureManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initWithSubViews];

}

#pragma mark - UISccrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

#pragma mark - privateMethod

- (void)initWithSubViews
{
    inputHeartRateControl = [[DeviceInputWeightControl alloc] init];
    [self.scrollView addSubview:inputHeartRateControl];
    [inputHeartRateControl setArrowHide:YES];
    [inputHeartRateControl setName:@"心率" unit:@"次/分"];
    [inputHeartRateControl addTarget:self action:@selector(heartRateControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    toplineView = [[UIView alloc] init];
    [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [self.scrollView addSubview:toplineView];
    
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [testTimeControl setArrowHide:YES];
    [self.scrollView addSubview:testTimeControl];
    [testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.excTime && 0 < self.excTime.length) {
        NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
        [testTimeControl.lbtestTime setText:dateStr];
    }
    
    pressureControl = [[DeviceInputWeightControl alloc] init];
    [pressureControl setArrowHide:YES];
    [pressureControl setName:@"血压" unit:@"mmHg"];
    [self.scrollView addSubview:pressureControl];
    self.highTension = @"120";
    self.lowTension = @"80";
    [pressureControl addTarget:self action:@selector(pressureControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确定
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn.layer setMasksToBounds:YES];
    [confirmBtn.layer setCornerRadius:5.0];
    [confirmBtn setTitle:@"保存" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont font_30];
    [confirmBtn setBackgroundColor:[UIColor mainThemeColor]];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:confirmBtn];
    [self subviewLayout];
}

- (void)subviewLayout
{
    [inputHeartRateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputHeartRateControl.mas_top);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(1);
    }];
    
    [pressureControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputHeartRateControl.mas_bottom).offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pressureControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(testTimeControl.mas_bottom).with.offset(30);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.width.equalTo(@(ScreenWidth - 30));
    }];
    [self prepareSeletData];
}


- (void)prepareSeletData
{
    NSMutableArray *sysData = [[NSMutableArray alloc] init];
    for (int i = 30; i <= 350; i++)
    {
        [sysData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *diaData = [[NSMutableArray alloc] init];
    for (int i = 10; i <= 300; i++)
    {
        [diaData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.pickerData = [[NSArray alloc] initWithObjects:sysData,diaData,nil];
}

- (void)checkForOnce {
    if (self.compickerView) {
        [self.compickerView removeFromSuperview];
        self.compickerView = nil;
    }
}

- (void)createAlterFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}
#pragma mark - EventRespond

//血压点击
- (void)pressureControlClick {
    if (self.compickerView && self.compickerView == pressurePickerView) {
        return;
    }
    [self checkForOnce];
    //读取本地上次保存数据
    NSString *lastTimeNumhighTension = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"SSY"];
    if (lastTimeNumhighTension.length) {
        self.highTension = lastTimeNumhighTension;
    }
    NSString *lastTimeNumlowTension = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"SZY"];
    if (lastTimeNumlowTension.length) {
        self.lowTension = lastTimeNumlowTension;
    }
    BodyDetectUniversalPickerView *selectView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:self.pickerData detaultArray:[NSArray arrayWithObjects:self.highTension, self.lowTension,nil] pickerType:k_PickerType_BloodPressure dataCallBackBlock:^(NSMutableArray *selectedItems) {
        self.highTension = [selectedItems firstObject];
        self.lowTension = [selectedItems lastObject];
          [pressureControl setLabelValue:[NSString stringWithFormat:@"%@/%@",self.highTension,self.lowTension]];
    }];
    self.compickerView = selectView;
    [self.view addSubview:selectView];
    pressurePickerView = selectView;
    [self createAlterFrame:selectView];
}

//心率点击
- (void)heartRateControlClick {
    if (self.compickerView && self.compickerView == ratePickerView) {
        return;
    }
    [self checkForOnce];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i <= 300; i ++) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    //读取本地上次保存数据
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"XL_OF_XY"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"60";
    NSArray *initArray = [NSArray arrayWithObject:inputHeartRateControl.lbValue.text?:defaultStr];
    BodyDetectUniversalPickerView *heartRatepickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:tempArray] detaultArray:initArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
         inputHeartRateControl.lbValue.text  = [selectedItems firstObject];
    }];
    self.compickerView  = heartRatepickerView;
    [self.view addSubview:heartRatepickerView];
    ratePickerView = heartRatepickerView;
    [self createAlterFrame:heartRatepickerView];
}

//测试时间点击
- (void)testTimeControlClick
{
    [self checkForOnce];
    if (self.excTime && 0 < self.excTime.length)
    {
        return;
    }
    
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    self.compickerView = testTimeView;
    [self.view addSubview:testTimeView];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (testTimeControl.lbtestTime.text.length) {
        NSDate *date = [formatter dateFromString:testTimeControl.lbtestTime.text];
        [testTimeView setDate:date];
    }
    [self createAlterFrame:testTimeView];
    __weak typeof(DeviceTestTimeControl) *controlSelf = testTimeControl;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _onceDetectTimeStr = [userDefaults objectForKey:BloodPressureDetectTimeCompare];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:selectedTime];
        
        NSLog(@"%ld", [NSDate compareDate:_onceDetectTimeStr withDate:strDate]);
        
        if ([NSDate compareDate:_onceDetectTimeStr withDate:strDate] == -1){
            [self.view showAlertMessage:[NSString stringWithFormat:@"请选择%@以后的日期",_onceDetectTimeStr]];
        }
        else{
            controlSelf.lbtestTime.text = [formatter stringFromDate:selectedTime];
        }
    }];
}
- (void)btnClickedOperations {
    [confirmBtn setEnabled:YES];
    
}
//保存点击
- (void)confirmBtnClick:(UIButton *)sender
{
    [self checkForOnce];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
    NSString *sHeartRate = inputHeartRateControl.lbValue.text;
    if (!sHeartRate && 0 == sHeartRate.length)
    {
        [self showAlertMessage:@"请选择心率值"];
        return;
    }
    if (![sHeartRate mj_isPureInt]) {
        [self showAlertMessage:@"心率输入有误，请重新输入"];
        return;
    }
    if (sHeartRate.intValue >= 300)
    {
        [self showAlertMessage:@"心率输入有误，请重新输入"];
        return;
    }
    if (sHeartRate.intValue < 1)
    {
        [self showAlertMessage:@"心率输入有误，请重新输入"];
        return;
    }

    NSString *pressure = pressureControl.lbValue.text;
    if (!pressure && 0 == pressure.length) {
        [self showAlertMessage:@"请选择血压值"];
        return;
    }
    
    if (_highTension.intValue <= _lowTension.intValue)
    {
        [self showAlertMessage:@"血压选择有误，请重新选择"];
        return;
    }
    [confirmBtn setEnabled:NO];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:3];
    
    //上传血压数据 改为三次测量
/*    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"XY" forKey:@"kpiCode"];
    
    [dicValue setValue:sHeartRate forKey:@"XL_OF_XY"];
    [dicValue setValue:_highTension forKey:@"SSY"];
    [dicValue setValue:_lowTension forKey:@"SZY"];
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:dicResult];
 */
    
    //本地保存记录，为下次打开使用
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"XL_OF_XY" number:sHeartRate];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"SSY" number:_highTension];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"SZY" number:_lowTension];

    //返回上一层 带数据
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
    
    [dicValue setValue:sHeartRate forKey:@"XL_OF_XY"];
    [dicValue setValue:_highTension forKey:@"SSY"];
    [dicValue setValue:_lowTension forKey:@"SZY"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicValue setValue:timeStr forKey:@"testTime"];
    
    [dicValue setValue:@"1" forKey:@"inputMode"];
    //[dicValue setValue:@"XY" forKey:@"kpiCode"];
    
    
    //如果是手动录入，则下次测量默认为手动
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:@"XYManualInputTpye"];
    [userDefaults synchronize];
    
    /*
     _isThriceDetect 判断是否从BloodPressureThreeDetectViewController点击按钮进入本页面
     是：测量完成 pop 回去
    */
    NSArray *vcs = self.navigationController.viewControllers;
    [vcs enumerateObjectsUsingBlock:^(HMBasePageViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:[BloodPressureThreeDetectViewController class]] && [vcs[vcs.count-2] isKindOfClass:[BloodPressureThreeDetectViewController class]]) {
            _isThriceDetect = YES;
            *stop = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BloodPressureDetectResultNotify object:nil userInfo:dicValue];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    if (!_isThriceDetect) {
        
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureThreeDetectViewController" ControllerObject:dicValue];
    }
 
}

//二次预警
- (void)secondWaringhandle
{
    [pressureControl.lbValue setText:@""];

}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - PickViewDelegateAndDataSource

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - setterAndGetter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

@end
