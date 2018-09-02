//
//  BloodFatManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatManualInputViewController.h"
#import "DeviceInputBloodFatControl.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
@interface BloodFatManualInputViewController ()<UIScrollViewDelegate>
{
    DeviceInputWeightControl* tgInputControl;
    DeviceInputWeightControl* tcInputControl;
    DeviceInputWeightControl* hdlInputControl;
    DeviceInputWeightControl* ldlInputControl;

    DeviceTestTimeControl *testTimeControl;
    DeviceTestTimeSelectView *testTimeView;
    UIControl * currentControl;
    
    UIView *toplineView;
    UIButton *submitButton;
}

@property(nonatomic, strong) NSDate  *testDate; //记录测试时间
@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *comPickerView;
@property(nonatomic, assign) BOOL  isUp; //是否已经拉升

@end

@implementation BloodFatManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initWithSubviews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}



#pragma mark - privateMethod

- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        
        self.scrollView.contentSize = CGSizeMake(0, 0);
        self.isUp = NO;
    }
}

- (void)initWithSubviews
{
    tgInputControl = [[DeviceInputWeightControl alloc]init];
    [tgInputControl setArrowHide:YES];
    [self.scrollView addSubview:tgInputControl];
    [tgInputControl setName:@"甘油三酯" unit:@"mmol/L"];
    [tgInputControl setSubLabelText:@"( TG )"];
    [tgInputControl addTarget:self action:@selector(InputControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    toplineView = [[UIView alloc] init];
    [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [self.scrollView addSubview:toplineView];
    
    tcInputControl = [[DeviceInputWeightControl alloc]init];
    [tcInputControl setArrowHide:YES];
    [self.scrollView addSubview:tcInputControl];
    [tcInputControl setName:@"总胆固醇" unit:@"mmol/L"];
    [tcInputControl setSubLabelText:@"( TC )"];
//    [tcInputControl setName:@"总胆固醇" SubName:@"( TC )"];
    [tcInputControl addTarget:self action:@selector(InputControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    hdlInputControl = [[DeviceInputWeightControl alloc]init];
    [hdlInputControl setArrowHide:YES];
    [self.scrollView addSubview:hdlInputControl];
    [hdlInputControl setName:@"高密度脂蛋白胆固醇" unit:@"mmol/L"];
    [hdlInputControl setSubLabelText:@"( HDL-C )"];
//    [hdlInputControl setName:@"高密度脂蛋白胆固醇" SubName:@"( HDL-C )"];
    [hdlInputControl addTarget:self action:@selector(InputControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ldlInputControl = [[DeviceInputWeightControl alloc]init];
    [ldlInputControl setArrowHide:YES];
    [self.scrollView addSubview:ldlInputControl];
    [ldlInputControl setName:@"低密度脂蛋白胆固醇" unit:@"mmol/L"];
    [ldlInputControl setSubLabelText:@"( LDL-C )"];
//    [ldlInputControl setName:@"低密度脂蛋白胆固醇" SubName:@"( LDL-C )"];
    [ldlInputControl addTarget:self action:@selector(InputControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [testTimeControl setArrowHide:YES];
    [self.scrollView addSubview:testTimeControl];
    [testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.excTime && 0 < self.excTime.length) {
        NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
        [testTimeControl.lbtestTime setText:dateStr];
    }

    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton.layer setMasksToBounds:YES];
    [submitButton.layer setCornerRadius:5.0];
    [submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [submitButton.titleLabel setFont: [UIFont font_30]];
    [submitButton setBackgroundColor:[UIColor mainThemeColor] ];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
}

- (void)subviewLayout
{
    [tgInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.scrollView);
    }];
    
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tgInputControl.mas_top);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(1);
    }];
    
    [tcInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tgInputControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.scrollView);
    }];
    
    [hdlInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tcInputControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.scrollView);
    }];
    
    [ldlInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hdlInputControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.scrollView);
    }];

    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ldlInputControl.mas_bottom);
        make.height.mas_equalTo(45);
        make.width.equalTo(self.scrollView);
    }];

    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(testTimeControl.mas_bottom).with.offset(30);
        make.width.equalTo(@(ScreenWidth - 30));
        make.height.mas_equalTo(45);
    }];
}

- (void)createAlertFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}

- (void)scrollToBottom {
    
    if (self.isUp) {
        return;
    }
    self.isUp = YES;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 60);
    if (self.scrollView.contentSize.height - self.scrollView.frame.size.height > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height)];
        }completion:^(BOOL finished) {
            self.scrollView.scrollEnabled = YES;
        }];
    }
}

#pragma  mark - evetRespond
//测试时间
- (void)testTimeControlClick
{
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        currentControl = nil;
    }
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    
    [self.view endEditing:YES];
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    currentControl = testTimeControl;
    [self.view addSubview:testTimeView];
    [self scrollToBottom];
    [self createAlertFrame:testTimeView];
    self.comPickerView = testTimeView;
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

- (void)InputControlClick:(DeviceInputWeightControl *)sender {
    sender.selected = NO;
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        currentControl = nil;
    }
    currentControl = sender;
    NSMutableArray *tempArray = [NSMutableArray array];
    NSString *title;
    NSString *interValue;
    NSString *pointValue;
    if (sender == tgInputControl) {
        title = @"甘油三酯";
        //读取本地上次保存数据
        NSArray *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeArrayWithType:@"TG"];
        if (lastTimeNum.count) {
            interValue = lastTimeNum.firstObject;
            pointValue = lastTimeNum.lastObject;
        }
        else {
            interValue = @"1";
            pointValue = @".00";
        }
    }
    else if(sender == tcInputControl) {
        title = @"总胆固醇";
        //读取本地上次保存数据
        NSArray *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeArrayWithType:@"TC"];
        if (lastTimeNum.count) {
            interValue = lastTimeNum.firstObject;
            pointValue = lastTimeNum.lastObject;
        }
        else {
            interValue = @"4";
            pointValue = @".00";
        }
    }
    else if(sender == hdlInputControl) {
        title = @"高密度脂蛋白胆固醇";
        //读取本地上次保存数据
        NSArray *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeArrayWithType:@"HDL_C"];
        if (lastTimeNum.count) {
            interValue = lastTimeNum.firstObject;
            pointValue = lastTimeNum.lastObject;
        }
        else {
            interValue = @"1";
            pointValue = @".00";
        }

        
        [self scrollToBottom];
    }
    else if (sender == ldlInputControl) {
        title = @"低密度脂蛋白胆固醇";
        //读取本地上次保存数据
        NSArray *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeArrayWithType:@"LDL_C"];
        if (lastTimeNum.count) {
            interValue = lastTimeNum.firstObject;
            pointValue = lastTimeNum.lastObject;
        }
        else {
            interValue = @"2";
            pointValue = @".00";
        }
        
        [self scrollToBottom];
    }
    for (int i = 0; i<= 30; i++) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    
    NSMutableArray *pointArray = [NSMutableArray array];
    for (float i = 0; i <=0.99; i += 0.01) {
//        if (i<0.09) {
//            continue;
//        }
        NSString *tempStr = [NSString stringWithFormat:@"%.2f",i];
        NSArray *tepArray = [tempStr componentsSeparatedByString:@"."];
        [pointArray addObject:[NSString stringWithFormat:@".%@",[tepArray lastObject]]];

    }
    
    
    NSArray *initObj;
    if (sender.lbValue.text.length) {
        NSArray *totlaArray = [sender.lbValue.text componentsSeparatedByString:@"."];
        initObj = [NSArray arrayWithObjects:[totlaArray firstObject],[NSString stringWithFormat:@".%@",[totlaArray lastObject]], nil];
    }else {
        initObj = [NSArray arrayWithObjects:interValue,pointValue,nil];
    }
    
    BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObjects:tempArray,pointArray, nil] detaultArray:initObj pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        NSString *tempStr = @"";
        for (NSString *str in selectedItems) {
            tempStr = [NSString stringWithFormat:@"%@%@",tempStr,str];
        }
        sender.lbValue.text = tempStr;
    }];
    [self.view addSubview:pickerView];
    self.comPickerView = pickerView;
    [self createAlertFrame:pickerView];
}

//保存
- (void)submitButtonClick
{
    [self checkForOnce];
    
    //time
    /*NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeString = [formatter stringFromDate:timeControl.detectTime];
    [dicBloodFat setValue:timeString forKey:@"time"];*/
    
    //TG
    NSString* tgValue = tgInputControl.lbValue.text;
    if (!tgValue || 0 == tgValue.length)
    {
        [self showAlertMessage:@"请输入您的甘油三酯。"];
        return;
    }

    if (tgValue.floatValue > 30 || tgValue.floatValue < 0.1)
    {
        [self showAlertMessage:@"请正确输入您的甘油三酯(0.1~30)"];
        [tgInputControl.lbValue setText:nil];
        return;
    }
    
    //TC
    NSString* tcValue = tcInputControl.lbValue.text;
    if (!tcValue || 0 == tcValue.length)
    {
        [self showAlertMessage:@"请输入您的总胆固醇。"];
        return;
    }
    if (tcValue.floatValue > 30 || tcValue.floatValue < 0.1)
    {
        [self showAlertMessage:@"请正确输入您的总胆固醇(0.1~30)"];
        [tcInputControl.lbValue setText:nil];
        return;
    }
    
    //HDL_C
    NSString* hdcValue = hdlInputControl.lbValue.text;
    if (!hdcValue || 0 == hdcValue.length)
    {
        [self showAlertMessage:@"请输入您的高密度脂蛋白胆固醇。"];
        return;
    }
    if (hdcValue.floatValue > 30 || hdcValue.floatValue < 0.1)
    {
        [self showAlertMessage:@"请正确输入您的高密度脂蛋白胆固醇(0.1~30)"];
        [hdlInputControl.lbValue setText:nil];
        return;
    }
    
    //LDL_C
    NSString* ldcValue = ldlInputControl.lbValue.text;
    if (!ldcValue || 0 == ldcValue.length)
    {
        [self showAlertMessage:@"请输入您的低密度脂蛋白胆固醇。"];
        return;
    }

    if (ldcValue.floatValue > 30 || ldcValue.floatValue < 0.1)
    {
        [self showAlertMessage:@"请正确输入您的低密度脂蛋白胆固醇(0.1~30)"];
        [ldlInputControl.lbValue setText:nil];
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
    
    //上传数据
    
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"XZ" forKey:@"kpiCode"];
    [dicValue setValue:tcValue forKey:@"TC"];
    [dicValue setValue:tgValue forKey:@"TG"];
    [dicValue setValue:hdcValue forKey:@"HDL_C"];
    [dicValue setValue:ldcValue forKey:@"LDL_C"];
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:dicResult];
    //本地保存记录，为下次打开使用
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"TC" number:@[[tcValue substringToIndex:tcValue.length - 3],[tcValue substringFromIndex:tcValue.length - 3]]];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"TG" number:@[[tgValue substringToIndex:tgValue.length - 3],[tgValue substringFromIndex:tgValue.length - 3]]];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"HDL_C" number:@[[hdcValue substringToIndex:hdcValue.length - 3],[hdcValue substringFromIndex:hdcValue.length - 3]]];
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"LDL_C" number:@[[ldcValue substringToIndex:ldcValue.length - 3],[ldcValue substringFromIndex:ldcValue.length - 3]]];
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
