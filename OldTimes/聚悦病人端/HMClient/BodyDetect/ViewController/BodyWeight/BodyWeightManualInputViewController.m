//
//  BodyWeightManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceSelectTestTimeView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
@interface BodyWeightManualInputViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
{
    DeviceInputWeightControl *inputWeightControl;
    DeviceInputWeightControl *inputHeightControl;
    DeviceTestTimeControl *testTimeControl;
    DeviceTestTimeSelectView *testTimeView; //时间选择控件
    BodyDetectUniversalPickerView *weightPickerView;
    BodyDetectUniversalPickerView *heightPickerView;
    
    UIView *toplineView;
    UIButton *saveButton;
}
@property(nonatomic, strong) NSArray      *pickerData;
@property(nonatomic, assign) BOOL         isWeightPicker;
@property(nonatomic, assign) NSInteger    row0;
@property(nonatomic, assign) NSInteger    row1;
@property(nonatomic, strong) NSArray  *weightDataArray;  //体重选择数据
@property(nonatomic, strong) NSArray  *heightDataArray; //身高选择数据
@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *compickerView;
@property(nonatomic, strong) NSDateFormatter  *format; //性能优化
@property(nonatomic, strong) NSDate  *testDate;

@end

@implementation BodyWeightManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
//    self.format = formatter;
    
    [self initWithSubViews];
}

#pragma mark - scrollviewdelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
//    [self clearAction];
}

#pragma mark - privateMethod
//- (void)clearAction
//{
//    [inputWeightControl setBackgroundColor:[UIColor whiteColor]];
//    [inputHeightControl setBackgroundColor:[UIColor whiteColor]];
//    [testTimeControl setBackgroundColor:[UIColor whiteColor]];
//}

- (void)initWithSubViews
{
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    //输入体重
    inputWeightControl = [[DeviceInputWeightControl alloc] init];
    [self.scrollView addSubview:inputWeightControl];
    [inputWeightControl setArrowHide:YES];
    [inputWeightControl setName:@"体重" unit:@"Kg"];
    if ([[NSNumber numberWithFloat:user.userWeight] integerValue] > 0) {
        [inputWeightControl setLabelValue:[NSString stringWithFormat:@"%.1f",user.userWeight]];
    }
    [inputWeightControl addTarget:self action:@selector(userWeightControlClicked) forControlEvents:UIControlEventTouchUpInside];
    toplineView = [[UIView alloc] init];
    [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [self.scrollView addSubview:toplineView];
    
    //输入身高
    inputHeightControl = [[DeviceInputWeightControl alloc] init];
    [self.scrollView addSubview:inputHeightControl];
    [inputHeightControl setArrowHide:YES];
    [inputHeightControl setName:@"身高" unit:@"cm"];
    if ([[NSNumber numberWithFloat:user.userHeight] integerValue] > 0) {
        [inputHeightControl setLabelValue:[NSString stringWithFormat:@"%.0f",user.userHeight * 100]];
    }
    [inputHeightControl addTarget:self action:@selector(userHeightControlClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //测试时间
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [testTimeControl setArrowHide:YES];
    [self.scrollView addSubview:testTimeControl];
    [testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* timeString = [formatter stringFromDate:[NSDate date]];
    self.format = formatter;
    [testTimeControl.lbtestTime setText:timeString];
    
    if (self.excTime && 0 < self.excTime.length) {
        NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd"];
        [testTimeControl.lbtestTime setText:dateStr];
    }
    

    NSString *strValue=[NSString stringWithFormat:@"%0.1f", user.userWeight];
    
    float userW = strValue.floatValue - floor(strValue.floatValue);
    self.row0 = floor(user.userWeight);
    self.row1 = userW*10;
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton.layer setMasksToBounds:YES];
    [saveButton.layer setCornerRadius:5.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont: [UIFont font_30]];
    [saveButton setBackgroundColor:[UIColor mainThemeColor] ];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:saveButton];
    [saveButton addTarget:self action:@selector(savebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
}

- (void)subviewLayout
{
    [inputWeightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputWeightControl.mas_top);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(1);
    }];
    
    [inputHeightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputWeightControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputHeightControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(testTimeControl.mas_bottom).with.offset(30);
        make.right.mas_equalTo(self.scrollView).with.offset(-15);
        make.height.mas_equalTo(45);
        make.width.equalTo(@(ScreenWidth - 30));
    }];
}

- (void)createAlertFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}

- (void)checkForOnce {
    if (self.compickerView) {
        [self.compickerView removeFromSuperview];
        self.compickerView = nil;
    }
}

#pragma mark - evenRespond
- (void)testTimeControlClick
{
    if (self.compickerView && self.compickerView == testTimeView) {
        return;
    }
    [self checkForOnce];
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    [self.view addSubview:testTimeView];
    self.scrollView.scrollEnabled = YES;
    [self createAlertFrame:testTimeView];
//    if (testTimeControl.lbtestTime.text.length) {
//        NSDate *date = [self.format dateFromString:testTimeControl.lbtestTime.text];
//        [testTimeView setDate:date];
//    }
    self.compickerView = testTimeView;
    __weak typeof(DeviceTestTimeControl) *controlSelf = testTimeControl;
    __weak typeof(self) weakSelf = self;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        
        NSString *timeStr = [self.format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:timeStr];
        weakSelf.testDate = selectedTime;
    }];
    [testTimeView setDateModel:UIDatePickerModeDate];
    [testTimeView setDate:self.testDate?:[NSDate date]];
}


- (void) savebuttonClicked:(UIButton *)sender
{
    [self checkForOnce];
    if (inputWeightControl.lbValue.text.intValue < 0.1)
    {
        [self showAlertMessage:@"选择体重有误，请重新选择"];
        return;
    }

    if (inputHeightControl.lbValue.text.floatValue < 0.3)
    {
        [self showAlertMessage:@"选择身高有误，请重新选择"];
        return;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* detecttime = [formatter dateFromString:testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
    
    //TDO 上传数据
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"TZ" forKey:@"kpiCode"];
    [dicValue setValue:inputWeightControl.lbValue.text forKey:@"TZ_SUB"];
    CGFloat height = inputHeightControl.lbValue.text.floatValue / 100;
    [dicValue setValue:[NSString stringWithFormat:@"%.2f",height] forKey:@"SG_OF_TZ"];
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];
    
    //更新本地的用户身高和体重信息
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    user.userHeight = height;
    user.userWeight = inputWeightControl.lbValue.text.floatValue;
    [[UserInfoHelper defaultHelper] saveUserInfo:user];
    
    [self postDetectResult:dicResult];
}

- (void) userWeightControlClicked
{
    if (self.compickerView && self.compickerView == weightPickerView) {
        return;
    }
    [self checkForOnce];
    NSArray *initObj;
    NSArray *totalArray;
    if (inputWeightControl.lbValue.text.length) {
         totalArray = [inputWeightControl.lbValue.text componentsSeparatedByString:@"."];
    }
    else {
        UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
        if ([[NSNumber numberWithFloat:user.userWeight] integerValue] > 0) {
            NSString *weight = [NSString stringWithFormat:@"%.1f",user.userWeight];
            totalArray = [weight componentsSeparatedByString:@"."];
        }else {
            totalArray = @[@"60",@"0"];
        }
    }
    initObj = [NSArray arrayWithObjects:[totalArray firstObject],[NSString stringWithFormat:@".%@",[totalArray lastObject]], nil];
    weightPickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:self.weightDataArray detaultArray:initObj pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        NSString *tempStr = @"";
        for (NSString *str in selectedItems) {
            tempStr = [NSString stringWithFormat:@"%@%@",tempStr,str];
        }
        inputWeightControl.lbValue.text = tempStr;
    }];
    self.compickerView = weightPickerView;
    [self.view addSubview:weightPickerView];
    [self createAlertFrame:weightPickerView];
}

- (void)userHeightControlClicked
{
    if (self.compickerView && self.compickerView == heightPickerView) {
        return;
    }
    [self checkForOnce];
    NSArray * initObj;
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (inputHeightControl.lbValue.text.length) {
        initObj = [NSArray arrayWithObject:inputHeightControl.lbValue.text];
    }
    else{
        if ([[NSNumber numberWithFloat:user.userHeight] integerValue] > 0) {
            initObj = [NSArray arrayWithObject:[NSString stringWithFormat:@"%.0f",user.userHeight * 100]];
        }
        else{
            initObj = [NSArray arrayWithObject:@"160"];
        }
    }
    heightPickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:self.heightDataArray detaultArray:initObj pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
         inputHeightControl.lbValue.text = [selectedItems firstObject];;
    }];
    self.compickerView = heightPickerView;
    [self.view addSubview:heightPickerView];
    [self createAlertFrame:heightPickerView];
}


#pragma mark - setterAndGetter
- (NSArray *)weightDataArray {
    if (!_weightDataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0;  i<= 1000 ; i ++) {
            [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
        }
        NSMutableArray *weightDataPoint = [[NSMutableArray alloc] init];
        for (NSInteger weightPoint = 0; weightPoint < 10; weightPoint++)
        {
            [weightDataPoint addObject:[NSString stringWithFormat:@".%ld",(long)weightPoint]];
        }
        _weightDataArray = [NSMutableArray arrayWithObjects:tempArray,weightDataPoint,nil];
    }
    return _weightDataArray;
}

- (NSArray *)heightDataArray {
    if (!_heightDataArray) {
        NSMutableArray *heightData = [[NSMutableArray alloc] init];
        for (int height = 30; height <=400; height++)
        {
            [heightData addObject:[NSString stringWithFormat:@"%d",height]];
        }
        _heightDataArray = [NSMutableArray arrayWithObject:heightData];
    }
    return _heightDataArray;
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
