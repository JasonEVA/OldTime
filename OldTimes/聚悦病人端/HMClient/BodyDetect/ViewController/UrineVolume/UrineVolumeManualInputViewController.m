//
//  UrineVolumeManualInputViewController.m
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UrineVolumeManualInputViewController.h"
#import "DeviceInputView.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
@interface UrineVolumePeriodControl ()
{
    UILabel *lbName;
    UIView *bottomlineView;
    UIButton *dayButton;
    UIButton *nightButton;
}


@end

@implementation UrineVolumePeriodControl

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setText:@"时段"];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_30]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];
        
        dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:dayButton];
        [dayButton setImage:[UIImage imageNamed:@"btn_daytime_hit"] forState:UIControlStateNormal];
        [dayButton addTarget:self action:@selector(dayButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        nightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:nightButton];
        [nightButton setImage:[UIImage imageNamed:@"btn_night_default"] forState:UIControlStateNormal];
        [nightButton addTarget:self action:@selector(nightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self subviewLayout];
    }
    return self;
}

- (void)dayButtonClick:(UIButton *)sender
{
    [dayButton setImage:[UIImage imageNamed:@"btn_daytime_hit"] forState:UIControlStateNormal];
    [nightButton setImage:[UIImage imageNamed:@"btn_night_default"] forState:UIControlStateNormal];
    _timetype = UrineVolumeDayTime;
}

- (void)nightButtonClick:(UIButton *)sender
{
    [nightButton setImage:[UIImage imageNamed:@"btn_night_hit"] forState:UIControlStateNormal];
    [dayButton setImage:[UIImage imageNamed:@"btn_daytime_default"] forState:UIControlStateNormal];
    _timetype = UrineVolumeNightTime;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 25));
    }];
    
    [dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nightButton.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
        make.size.equalTo(nightButton);
    }];
}

@end


@interface UrineVolumeManualInputViewController ()<UIScrollViewDelegate>
{
    DeviceInputWeightControl *inputUrineVolumeControl;
    DeviceTestTimeControl *testTimeControl;
    UrineVolumePeriodControl *periodControl;
    
    DeviceTestTimeSelectView *testTimeView;
    BodyDetectUniversalPickerView *urineVolumeView;
    
    UIView *toplineView;
    UIButton *saveButton;
    UILabel *lbdaytimedesc;
    UILabel *lbnightdesc;
}
@property(nonatomic, strong) NSDate  *testDate;
@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *comPickerView;
@property(nonatomic, strong) NSDateFormatter  *format;
@end

@implementation UrineVolumeManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initWithSubViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

#pragma mark - privateMethod

- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
    }
}

- (void)initWithSubViews
{
    inputUrineVolumeControl = [[DeviceInputWeightControl alloc] init];
    [inputUrineVolumeControl setArrowHide:YES];
    [self.scrollView addSubview:inputUrineVolumeControl];
    [inputUrineVolumeControl setName:@"尿量" unit:@"ml"];
    [inputUrineVolumeControl addTarget:self action:@selector(UrineVolumeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    toplineView = [[UIView alloc] init];
    [toplineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [self.scrollView addSubview:toplineView];
    
    testTimeControl = [[DeviceTestTimeControl alloc] init];
    [self.scrollView addSubview:testTimeControl];
    [testTimeControl setArrowHide:YES];
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

    
    periodControl = [[UrineVolumePeriodControl alloc] init];
    [self.scrollView addSubview:periodControl];
    lbdaytimedesc = [[UILabel alloc]init];
    [self.scrollView addSubview:lbdaytimedesc];
    [lbdaytimedesc setBackgroundColor:[UIColor clearColor]];
    [lbdaytimedesc setFont:[UIFont font_22]];
    [lbdaytimedesc setTextColor:[UIColor commonGrayTextColor]];
    [lbdaytimedesc setText:@"按白天:每天早上8:00到晚上20:00的尿量合计值"];
    
    lbnightdesc = [[UILabel alloc]init];
    [self.scrollView addSubview:lbnightdesc];
    [lbnightdesc setBackgroundColor:[UIColor clearColor]];
    [lbnightdesc setFont:[UIFont font_22]];
    [lbnightdesc setTextColor:[UIColor commonGrayTextColor]];
    [lbnightdesc setText:@"按晚上:每天晚上20:00到第二天早上8:00的尿量合计值"];
    
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
    [inputUrineVolumeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputUrineVolumeControl.mas_top);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(1);
    }];
    
    [testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputUrineVolumeControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [periodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(testTimeControl.mas_bottom).with.offset(1);
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [lbdaytimedesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(periodControl.mas_bottom).with.offset(10);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    [lbnightdesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lbdaytimedesc.mas_left);
        make.top.equalTo(lbdaytimedesc.mas_bottom).with.offset(5);
        make.width.and.height.equalTo(lbdaytimedesc);
    }];

    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(lbnightdesc.mas_bottom).with.offset(30);
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
    [self.view addSubview:testTimeView];
    self.comPickerView = testTimeView;
    [self createAlertFrame:testTimeView];
    
    __weak typeof(DeviceTestTimeControl) *controlSelf = testTimeControl;
    __weak typeof(self) weakSelf = self;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSString *tempStr = [self.format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:tempStr];
        weakSelf.testDate = selectedTime;
    }];
    [testTimeView setDateModel:UIDatePickerModeDate];
    [testTimeView setDate:self.testDate?:[NSDate date]];
}

- (void)UrineVolumeClicked {
    if (self.comPickerView && self.comPickerView == urineVolumeView) {
        return;
    }
    [self checkForOnce];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i <= 3000 ; i += 10) {
        [tempArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    //读取本地上次保存数据
    NSString *lastTimeNum = [[RecordHealthHistoryManager sharedInstance] getHealthTypeNumberWithType:@"NL_SUB_DAY"];
    NSString *defaultStr = [lastTimeNum length] ? lastTimeNum : @"400";
    NSArray *initArray = [NSArray arrayWithObject:inputUrineVolumeControl.lbValue.text?:defaultStr];
    
    BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:tempArray] detaultArray:initArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
         inputUrineVolumeControl.lbValue.text = [selectedItems firstObject];
    }];
    [self.view addSubview:pickerView];
    urineVolumeView = pickerView;
    self.comPickerView = pickerView;
    [self createAlertFrame:pickerView];
}

- (void)saveButtonClick
{
    [self checkForOnce];
    NSDate* detecttime = [self.format dateFromString:testTimeControl.lbtestTime.text];
    NSTimeInterval ti = [detecttime timeIntervalSinceNow];
    if (ti > 0)
    {
        [self showAlertMessage:@"测量时间选择有误，请重新选择。"];
        return;
    }
    
    NSString *volumestring = inputUrineVolumeControl.lbValue.text;
    if (!volumestring || 0 == volumestring.length)
    {
        [self showAlertMessage:@"请输入您的尿量值。"];
        return;
    }
    
    NSInteger volume = volumestring.integerValue;
    if (volume > 2000 || volume < 1)
    {
        [self showAlertMessage:@"请输入正确的尿量值（1~2000）。"];
        return;
    }
    //[self.view showWaitView];
    //上传尿量数据
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"NL" forKey:@"kpiCode"];
    
    [dicResult setValue:dicValue forKey:@"testValue"];
    NSString* subKey = @"NL_SUB_DAY";
    if(UrineVolumeNightTime == periodControl.timetype)
    {
        subKey = @"NL_SUB_NIGHT";
    }
    [dicValue setValue:volumestring forKey:subKey];
    
    NSString* timeStr = [detecttime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:timeStr forKey:@"testTime"];
    
    [self postDetectResult:dicResult];
    //本地保存记录，为下次打开使用
    [[RecordHealthHistoryManager sharedInstance] saveWithHealthType:@"NL_SUB_DAY" number:volumestring];
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
