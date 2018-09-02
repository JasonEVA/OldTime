//
//  RecordSportsExecuteViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecordSportsExecuteViewController.h"
#import "ZJKDatePickerSheet.h"
#import "SportsDurationPickerSheet.h"
#import "SportsTypeSelectViewController.h"
#import "DeviceTestTimeSelectView.h"
#import "BodyDetectUniversalPickerView.h"
#import "UIView+SizeExtension.h"

@interface RecordSportsExecuteControl : UIControl
{
    UILabel* lbTitle;
    UILabel* lbValue;
    UIImageView* ivArrow;
    NSString* placeholderStr;
    NSString* valueString;
    
   
}

- (void) setPlaceholder:(NSString*) placeholder;

- (void) setName:(NSString*) name;
- (void) setValueString:(NSString*) valueStr;
- (void)setArrowHide:(BOOL)isHide;
@end

@implementation RecordSportsExecuteControl

- (id) init
{
    self = [super init];
    if (self)
    {
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setFont:[UIFont font_30]];
        [lbTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(7, 13));
        }];
        self.backgroundColor = [UIColor whiteColor];
        [self showBottomLine];
        
        [self createValueLable];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted?[UIColor commonGrayTouchHihtLightColor]:[UIColor whiteColor];
}

- (void)setArrowHide:(BOOL)isHide
{
    ivArrow.hidden = YES;
}

- (void) setName:(NSString*) name
{
    [lbTitle setText:name];
}

- (void) setPlaceholder:(NSString*) placeholder
{
    placeholderStr = placeholder;
    if (lbValue)
    {
        if (!valueString)
        {
            [lbValue setTextColor:[UIColor commonGrayTextColor]];
            [lbValue setText:placeholderStr];
        }
    }
}

- (void) setValueString:(NSString*) valueStr
{
    valueString = valueStr;
    if (valueStr && 0 < valueStr.length)
    {
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setText:valueStr];
    }
    else
    {
        [lbValue setTextColor:[UIColor commonGrayTextColor]];
        [lbValue setText:placeholderStr];
    }
}

- (void) createValueLable
{
    lbValue = [[UILabel alloc]init];
    [self addSubview:lbValue];
    [lbValue setFont:[UIFont font_30]];
    [lbValue setTextColor:[UIColor commonTextColor]];
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ivArrow.mas_left).with.offset(-5);
        make.centerY.equalTo(self);
    }];

}

@end

@interface RecordSportsExecuteDurationControl : RecordSportsExecuteControl

{
    UILabel* lbUnit;
}
@end

@implementation RecordSportsExecuteDurationControl

- (void) createValueLable
{
    lbUnit = [[UILabel alloc]init];
    [self addSubview:lbUnit];
    [lbUnit setFont:[UIFont font_26]];
    [lbUnit setTextColor:[UIColor blackColor]];
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ivArrow.mas_left).with.offset(-5);
        make.centerY.equalTo(self);
    }];
    [lbUnit setText:@"分钟"];
    
    lbValue = [[UILabel alloc]init];
    [self addSubview:lbValue];
    [lbValue setFont:[UIFont font_30]];
    [lbValue setTextColor:[UIColor commonTextColor]];
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbUnit.mas_left).with.offset(-1);
        make.centerY.equalTo(self);
    }];
}

@end

@interface RecordSportsExecuteViewController ()
<ZJKPickerSheetDelegate,
TaskObserver,UIScrollViewDelegate>
{
    RecordSportsExecuteControl* dateControl;
    RecordSportsExecuteControl* sportstypeControl;
    RecordSportsExecuteControl* durationControl;
    
    RecordSportsExecuteControl *currentControl; //记录当前选择Control
    
    NSString* dateString;
    RecommandSportsType* selectedSportsType;
    NSInteger durationInMinute;
}

@property(nonatomic, strong) NSDate  *recordDate;   //记录选中过的记录时间
@property(nonatomic, copy) NSString  *recordPeriod; //记录选中过的运动时长

@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *comPickerView;


@end

@implementation RecordSportsExecuteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"记录运动"];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self createRecordOptionControls];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
    [dateControl setValueString:[self reformatDateString:dateString]];
    
    [sportstypeControl setPlaceholder:@"请选择运动方式"];
    [durationControl setPlaceholder:@"--"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

#pragma mark - pvivateMethod
- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        currentControl = nil;
    }
}
- (NSString*)reformatDateString:(NSString*) dateStr
{
    NSDate* date = [NSDate dateWithString:dateStr formatString:@"yyyy-MM-dd"];
    NSString* retString = [date formattedDateWithFormat:@"yyyy年MM月dd日"];
    return retString;
}

- (void)createRecordOptionControls
{
    dateControl = [[RecordSportsExecuteControl alloc]init];
    [dateControl setArrowHide:YES];
    [self.scrollView addSubview:dateControl];
    [dateControl setName:@"记录日期"];
    [dateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(@45);
    }];
    [dateControl addTarget:self action:@selector(dateControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dateControl setArrowHide:YES];
    sportstypeControl = [[RecordSportsExecuteControl alloc]init];
    [self.scrollView addSubview:sportstypeControl];
    [sportstypeControl setName:@"运动方式"];
    [sportstypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.top.equalTo(dateControl.mas_bottom);
        make.height.mas_equalTo(@45);
    }];
    [sportstypeControl addTarget:self action:@selector(sportsTypeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sportstypeControl setArrowHide:YES];
    durationControl = [[RecordSportsExecuteDurationControl alloc]init];
    [self.scrollView addSubview:durationControl];
    [durationControl setName:@"运动时长"];
    [durationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.top.equalTo(sportstypeControl.mas_bottom);
        make.height.mas_equalTo(@45);
    }];
    
    [durationControl addTarget:self action:@selector(durationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:commitButton];
    [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 2.5;
    commitButton.layer.masksToBounds = YES;
    [commitButton.titleLabel setFont:[UIFont font_28]];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).with.offset(12.5);
        make.width.equalTo(@(ScreenWidth - 25));
        make.top.equalTo(durationControl.mas_bottom).with.offset(30);
        make.height.mas_equalTo(@40);
    }];
    
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createAlterFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}

#pragma mark - eventRespond
- (void) commitButtonClicked:(id) sender
{
    [self checkForOnce];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateString forKey:@"date"];
    if (!selectedSportsType)
    {
        
        [self showAlertMessage:@"请选择运动方式。"];
        return;
    }
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedSportsType.sportsTypeId] forKey:@"sportsTypeId"];
    
    if (0 == durationInMinute)
    {
        [self showAlertMessage:@"请选择运动时长。"];
        return;
    }
    [dicPost setValue:[NSString stringWithFormat:@"%ld", durationInMinute] forKey:@"sportTimes"];
    
    [self.view showWaitView];
    //RecordUserSportsTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"RecordUserSportsTask" taskParam:dicPost TaskObserver:self];
}

- (void) sportsTypeControlClicked:(id) sender
{
    if (currentControl && currentControl == sportstypeControl) {
        return;
    }
    //SportsTypesListTask
    [self checkForOnce];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SportsTypesListTask" taskParam:nil TaskObserver:self];
}

- (void) dateControlClicked:(id) sender
{
    if (currentControl  && currentControl == sender) {
        return;
    }
    currentControl = sender;
    [self checkForOnce];
    DeviceTestTimeSelectView *timeSelectView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerView = timeSelectView;
    [self.view addSubview:timeSelectView];
    [self createAlterFrame:timeSelectView];
    if (self.recordDate) {
        [timeSelectView setDate:self.recordDate];
    }
    [timeSelectView setDateModel:UIDatePickerModeDate];
    [timeSelectView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd日"];
        NSString *timeStr = [format stringFromDate:selectedTime];
        [format setDateFormat:@"yyyy-MM-dd"];
        dateString = [format stringFromDate:selectedTime];
        [dateControl setValueString:timeStr];
        
        self.recordDate = selectedTime;
    }];
}

- (void) durationControlClicked:(id) sender
{
    if (currentControl && currentControl == sender) {
        return;
    }
    [self checkForOnce];
    currentControl = sender;
    NSMutableArray * durationList = [NSMutableArray array];
    for (NSInteger index = 1; index < 180; index++)
    {
        NSString* dura = [NSString stringWithFormat:@"%ld", index];
        [durationList addObject:dura];
    }
    NSArray *initArray = [NSArray arrayWithObject:self.recordPeriod?:@"30"];
    BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:durationList] detaultArray:initArray pickerType:k_PickerType_Default dataCallBackBlock:^(NSMutableArray *selectedItems) {
        NSString *period = [selectedItems firstObject] ;
        durationInMinute = period.integerValue;
        [durationControl setValueString:period];
        self.recordPeriod = period;
    }];
    [self.view addSubview:pickerView];
    [self createAlterFrame:pickerView];
    self.comPickerView = pickerView;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"RecordUserSportsTask"])
    {
        [self.view showWaitView:@"记录运动成功。"];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:0.5];
        return;
    }
}

- (void)popAction {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"SportsTypesListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            //弹出运动方式选择界面
            NSArray* types = (NSArray*) taskResult;
            
            [self checkForOnce];
            currentControl = sportstypeControl;
            if (types.count) {
                BodyDetectUniversalPickerView *pickerView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:[NSArray arrayWithObject:types] detaultArray:[NSArray arrayWithObject:types.count > 1?types[1]:types[0]] pickerType:k_PickerType_SportMode dataCallBackBlock:^(NSMutableArray *selectedItems) {
                    selectedSportsType = [selectedItems firstObject];
                    RecommandSportsType *item = [selectedItems firstObject];
                    [sportstypeControl setValueString:item.sportsName];
                }];
                [self.view addSubview:pickerView];
                self.comPickerView = pickerView;
                [self createAlterFrame:pickerView];
            }
            else {
                [self.view showAlertMessage:@"没有可选运动方式"];
            }
        }
    }
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
