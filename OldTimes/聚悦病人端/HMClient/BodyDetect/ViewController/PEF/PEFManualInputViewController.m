//
//  PEFManualInputViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFManualInputViewController.h"
#import "BloodPressureThriceDetectModel.h"
#import "HMPopupSelectViewController.h"
#import "BodyDetectUniversalPickerView.h"
#import "DetectRecord.h"
#import "HealthRecodUpLoadSuccessView.h"

static NSString *const kpiCode = @"FLSZ";
static NSString *const PEFSymptomNotify = @"PEFSymptomValue";

@interface PEFManualInputViewController ()<UIScrollViewDelegate,TaskObserver>

@property (nonatomic, strong) DeviceInputControl *PEFInputControl;
@property (nonatomic, strong) DeviceInputWeightControl *medicineInputControl;
@property (nonatomic, strong) DeviceInputWeightControl *symptomInputControl;
@property (nonatomic, strong) DeviceTestTimeControl* testTimeControl;
@property (nonatomic, strong) DeviceTestTimeSelectView *testTimeView;
@property(nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *submitButton;

@property(nonatomic, strong) UIView  *comPickerView;
@property(nonatomic, strong) NSDate  *testDate;

@property (nonatomic, strong) NSArray *medPeriodArray;

@property (nonatomic, strong) NSMutableArray *symptomArray;
@property (nonatomic, strong) NSMutableArray *symptomIDArray;
@property (nonatomic, strong) NSMutableArray *symptomNameArray;

@property (nonatomic, strong) HealthRecodUpLoadSuccessView *upLoadSuccessView;

@property (nonatomic, copy) NSString *testTimeId;

@end

@implementation PEFManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self configConstraints];
    
    //用药时段 不传默认为XY
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:kpiCode forKey:@"kpiCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectPeriodTask" taskParam:dicPost TaskObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BloodPressureSymptomsNotification:) name:PEFSymptomNotify object:nil];
}

#pragma mark -- Notification
//通知传值 症状值
- (void)BloodPressureSymptomsNotification:(NSNotification *)notification
{
    self.symptomArray = notification.object;
    
    if (kArrayIsEmpty(self.symptomArray)) {
        [_symptomInputControl.lbValue setText:@"无"];
        return;
    }
    
    if (!_symptomIDArray) {
        _symptomIDArray = [[NSMutableArray alloc] init];
    }
    
    if (!_symptomNameArray) {
        _symptomNameArray = [[NSMutableArray alloc] init];
    }
    
    [_symptomIDArray removeAllObjects];
    [_symptomNameArray removeAllObjects];
    
    [self.symptomArray enumerateObjectsUsingBlock:^(BloodPressureThriceDetectModel *symptomModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.symptomNameArray addObject:symptomModel.name];
        [self.symptomIDArray addObject:symptomModel.ID];
    }];
    
    NSString *str = [self.symptomNameArray componentsJoinedByString:@"、"];
    [_symptomInputControl.lbValue setText:str];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

#pragma mark - Private Method
// 设置约束
- (void)configConstraints
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.PEFInputControl];
    [self.scrollView addSubview:self.medicineInputControl];
    [self.scrollView addSubview:self.symptomInputControl];
    [self.scrollView addSubview:self.testTimeControl];
    [self.scrollView addSubview:self.promptLabel];
    [self.scrollView addSubview:self.submitButton];
    
    [self.scrollView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_PEFInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.scrollView).with.offset(10);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_medicineInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_PEFInputControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_symptomInputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_medicineInputControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_symptomInputControl.mas_bottom);
        make.height.mas_equalTo(45 * kScreenScale);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).with.offset(12.5);
        make.top.equalTo(_testTimeControl.mas_bottom).with.offset(14);
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 46));
        make.top.equalTo(_promptLabel.mas_bottom).with.offset(30);
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Action


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForOnce {
    [_PEFInputControl.tfValue resignFirstResponder];
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

//峰流速值
- (void)PEFInputControlClicked
{
    [_PEFInputControl.tfValue becomeFirstResponder];
    
    //读取本地上次保存数据
//    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"FLSZ_SUB"];
//    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"0";
//    [_PEFInputControl.tfValue setText:defaultStr];
}

//用药
- (void)medicineInputControlClicked
{
    [_PEFInputControl.tfValue resignFirstResponder];
    if (self.comPickerView && self.comPickerView == _testTimeView) {
        [_testTimeView removeFromSuperview];
    }
    
    if (kArrayIsEmpty(_medPeriodArray)) {
        [self showAlertMessage:@"无用药"];
        return;
    }
    
    [HMPopupSelectViewController createWithParentViewController:self kpiCode:nil dataList:_medPeriodArray selectblock:^(BloodPressureThriceDetectModel *model) {
        
        [_medicineInputControl.lbValue setText:model.name];
        _testTimeId = model.ID;

    }];
}

//症状
- (void)symptomControlClicked
{
    [_PEFInputControl.tfValue resignFirstResponder];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"PEFSymptomSelectViewController" ControllerObject:self.symptomArray];
}

- (void)testTimeControlClick
{
    [_PEFInputControl.tfValue resignFirstResponder];
    
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
    self.scrollView.scrollEnabled = YES;
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
//    [HMViewControllerManager createViewControllerWithControllerName:@"PEFResultContentViewController" ControllerObject:nil];
//    return;
    
    [self checkForOnce];
    [_PEFInputControl.tfValue resignFirstResponder];
    
    NSString *pefValue = _PEFInputControl.tfValue.text;
    
    if (kStringIsEmpty(pefValue) || pefValue.integerValue <= 0 || pefValue.integerValue >= 1000) {
        [self showAlertMessage:@"请输入1～1000的峰流速值"];
        return;
    }
    
    unichar single = [pefValue characterAtIndex:0];
    if (single == '0') {
        [self showAlertMessage:@"峰流速值输入有误，请重新输入"];
        return;
    }
    
    if (kStringIsEmpty(_testTimeId)) {
        [self showAlertMessage:@"请选择用药"];
        return;
    }
    
    NSString *medStr = _medicineInputControl.lbValue.text;
    //如果用药选择为药前或药后15分钟,必须选择症状
    if (!kStringIsEmpty(medStr) && ![medStr isEqualToString:@"无"]) {
        if (kArrayIsEmpty(self.symptomIDArray)) {
            [self showAlertMessage:@"请选择症状"];
            return;
        }
    }
    
    NSString* testTimeString = _testTimeControl.lbtestTime.text;
    if (kStringIsEmpty(testTimeString)) {
        [self showAlertMessage:@"请输入您的测量时间。"];
        return;
    }
    
    NSMutableDictionary* detectResultDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicValue setValue:pefValue forKey:@"FLSZ_SUB"];
    [detectResultDic setValue:_testTimeId forKey:@"testTimeId"];
    
    if (!kArrayIsEmpty(self.symptomIDArray)) {
        [detectResultDic setValue:self.symptomIDArray forKey:@"symptomList"];
    }
    
    [detectResultDic setValue:kpiCode forKey:@"kpiCode"];
    [detectResultDic setValue:dicValue forKey:@"testValue"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* detecttime = [formatter dateFromString:testTimeString];
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [detectResultDic setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:detectResultDic];
    
    //本地保存记录，为下次打开使用
//    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"FLSZ_SUB" number:pefValue];
}

#pragma mark -- TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"BloodPressureThriceDetectPeriodTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            _medPeriodArray = (NSArray *)taskResult;
            
            BloodPressureThriceDetectModel *model = [_medPeriodArray objectAtIndex:0];
            [_medicineInputControl.lbValue setText:model.name];
            _testTimeId = model.ID;
        }
    }
    
    if ([taskname isEqualToString:@"PostBodyDetectResultTask"]) {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            // 监测结果上传成功，监测图表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOADTESTSUCCESSED" object:nil];
            
            NSString *recordId = [(NSString*) taskResult valueForKey:@"recordId"];
            
            if (kStringIsEmpty(recordId)) {
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
            
            DetectRecord *record = [[DetectRecord alloc] init];
            [record setTestDataId:recordId];
            
            [self.upLoadSuccessView showSuccessView];
            [self.upLoadSuccessView jumpToNextStep:^{
                if ([kpiCode isEqualToString:@"FLSZ"])
                {
                    [HMViewControllerManager createViewControllerWithControllerName:@"PEFResultContentViewController" ControllerObject:record];
                }
            }];
        }

    }
}


#pragma mark -- init
- (DeviceInputControl *)PEFInputControl{
    if (!_PEFInputControl) {
        _PEFInputControl = [[DeviceInputControl alloc] init];
        [_PEFInputControl setName:@"峰流速值" unit:@"升/分"];
        [_PEFInputControl showTopLine];
        [_PEFInputControl.tfValue setKeyboardType:UIKeyboardTypeNumberPad];
        [_PEFInputControl addTarget:self action:@selector(PEFInputControlClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PEFInputControl;
}

- (DeviceInputWeightControl *)medicineInputControl{
    if (!_medicineInputControl) {
        _medicineInputControl = [[DeviceInputWeightControl alloc] init];
        [_medicineInputControl setName:@"用药" unit:@""];
        //[_medicineInputControl setLabelValue:@"无"];
        [_medicineInputControl addTarget:self action:@selector(medicineInputControlClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _medicineInputControl;
}

- (DeviceInputWeightControl *)symptomInputControl{
    if (!_symptomInputControl) {
        _symptomInputControl = [[DeviceInputWeightControl alloc] init];
        [_symptomInputControl setName:@"症状" unit:@""];
        [_symptomInputControl setLabelValue:@"无"];
        [_symptomInputControl addTarget:self action:@selector(symptomControlClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _symptomInputControl;
}

- (DeviceTestTimeControl *)testTimeControl{
    if (!_testTimeControl) {
        _testTimeControl = [[DeviceTestTimeControl alloc] init];
        [_testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testTimeControl;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        [_promptLabel setText:@"注意:请使用峰流速仪测三次，填写时填三次中的最高值"];
        [_promptLabel setTextColor:[UIColor commonGrayTextColor]];
        [_promptLabel setFont:[UIFont font_24]];
    }
    return _promptLabel;
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

- (HealthRecodUpLoadSuccessView *)upLoadSuccessView {
    if (!_upLoadSuccessView) {
        _upLoadSuccessView =[HealthRecodUpLoadSuccessView new];
    }
    return _upLoadSuccessView;
}

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
