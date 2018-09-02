//
//  BreathingManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"

@interface BreathingManualInputViewController ()<UITextViewDelegate,UIScrollViewDelegate>
{
    DeviceInputWeightControl *inputBreathingRateControl;
    DeviceTestTimeControl *testTimeControl;
    DeviceTestTimeSelectView *testTimeView;
    BodyDetectUniversalPickerView *breathingRateInputView;
    
    UIView *toplineView;
    UITextView *txView;
    UILabel *label;
    UIButton *saveButton;
}

@property(nonatomic, strong) NSDate  *testDate; //记录测试时间
@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *comPickerView;
@property(nonatomic, strong) NSDateFormatter  *format;

@end

@implementation BreathingManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.format = format;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initWithSubViews];
}
#pragma mark - uiscrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
    [self.view endEditing:YES];
//    [self clearAcition];
}
#pragma mark - privateMethod

//- (void)clearAcition
//{
//    [inputBreathingRateControl setBackgroundColor:[UIColor whiteColor]];
//    [testTimeControl setBackgroundColor:[UIColor whiteColor]];
//}

- (void)initWithSubViews
{
    inputBreathingRateControl = [[DeviceInputWeightControl alloc] init];
    [inputBreathingRateControl setArrowHide:YES];
    [self.scrollView addSubview:inputBreathingRateControl];
    [inputBreathingRateControl setName:@"呼吸频率" unit:@"次/分"];
    [inputBreathingRateControl addTarget:self action:@selector(breathRateClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    txView = [[UITextView alloc] init];
    [self.scrollView addSubview:txView];
    [txView.layer setBorderWidth:1.0f];
    [txView.layer setBorderColor:[[UIColor commonControlBorderColor] CGColor]];
    [txView setFont:[UIFont font_28]];
    [txView setDelegate:self];
    
    label = [[UILabel alloc] init];
    [label setEnabled:NO];
    [label setText:@"如果您有呼吸不适的症状，请输入您的症状"];
    [label setFont:[UIFont font_28]];
    [label setTextColor:[UIColor commonGrayTextColor]];
    [self.scrollView addSubview:label];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton.layer setMasksToBounds:YES];
    [saveButton.layer setCornerRadius:5.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont: [UIFont font_30]];
    [saveButton setBackgroundColor:[UIColor mainThemeColor] ];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:saveButton];
    
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
    
}

- (void)subviewLayout
{
    [inputBreathingRateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBreathingRateControl.mas_top);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(1);
    }];
    
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBreathingRateControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(testTimeControl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(10);
        make.width.equalTo(@(ScreenWidth - 20));
        make.height.mas_equalTo(100);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(testTimeControl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(14);
        make.width.equalTo(@(ScreenWidth - 28));
        make.height.mas_equalTo(35);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(txView.mas_bottom).with.offset(30);
        make.width.equalTo(@(ScreenWidth - 30));
        make.height.mas_equalTo(45);
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
//保存
- (void)saveButtonClick
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
    
    NSString *sBreathingRate = inputBreathingRateControl.lbValue.text;
    if (!sBreathingRate && 0 == sBreathingRate.length)
    {
        [self showAlertMessage:@"呼吸频率输入有误，请重新输入"];
        return;
    }
    if (![sBreathingRate mj_isPureInt]) {
        [self showAlertMessage:@"呼吸频率输入有误，请重新输入"];
        return;
    }
    if (sBreathingRate.intValue >= 300)
    {
        [self showAlertMessage:@"呼吸频率输入有误，请重新输入"];
        return;
    }
    if (sBreathingRate.intValue < 1)
    {
        [self showAlertMessage:@"呼吸频率输入有误，请重新输入"];
        return;
    }
    
    //添加呼吸数据
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"HX" forKey:@"kpiCode"];
    
    [dicResult setValue:dicValue forKey:@"testValue"];
    [dicValue setValue:sBreathingRate forKey:@"HX_SUB"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];

    [dicResult setValue:txView.text forKey:@"symptom"];
    
    [self postDetectResult:dicResult];
    //本地保存记录，为下次打开使用
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"HX_SUB" number:sBreathingRate];
}
//测试时间
- (void)testTimeControlClick
{
    if (self.comPickerView && self.comPickerView == testTimeView) {
        return;
    }
    [self checkForOnce];
    
    //只创建一次
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    
    [self.view endEditing:YES];
    [txView resignFirstResponder];
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    [self.view addSubview:testTimeView];
    [self createAlertFrame:testTimeView];
    __weak typeof(DeviceTestTimeControl) *controlSelf = testTimeControl;
    __weak typeof(self) weakSelf = self;
    self.comPickerView = testTimeView;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSString *tempStr = [self.format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:tempStr];
        weakSelf.testDate = selectedTime;
    }];
    [testTimeView setDate:self.testDate?:[NSDate date]];
}

//呼吸频率
- (void)breathRateClick
{
    //确保只创建一次
    if (self.comPickerView && self.comPickerView == breathingRateInputView) {
        return;
    }
    [self checkForOnce];
    [self.view endEditing:YES];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int  i = 5; i <= 100; i++) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    //读取本地上次保存数据
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"HX_SUB"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"20";
    NSArray *initialArray = [NSArray arrayWithObject:inputBreathingRateControl.lbValue.text?:defaultStr];
    BodyDetectUniversalPickerView *rateSelectView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:tempArray] detaultArray:initialArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        inputBreathingRateControl.lbValue.text = [selectedItems firstObject];
    }];
    [self.view addSubview:rateSelectView];
    self.comPickerView = rateSelectView;
    breathingRateInputView = rateSelectView;
    [self createAlertFrame:rateSelectView];
}


#pragma mark -- textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        label.text = @"如果您有呼吸不适的症状，请输入您的症状";
    }else
    {
        label.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

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
