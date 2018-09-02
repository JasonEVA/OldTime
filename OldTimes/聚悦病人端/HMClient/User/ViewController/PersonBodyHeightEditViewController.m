//
//  PersonBodyHeightEditViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonBodyHeightEditViewController.h"

@interface PersonBodyHeightNoticeView : UIView
{
    UILabel* lbNotice;
    UIView* bottomline;
}
@end

@implementation PersonBodyHeightNoticeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        lbNotice = [[UILabel alloc]init];
        [self addSubview:lbNotice];
        [lbNotice setText:@"为了能正确判断您的指标，请务必认真填写以下资料哦！"];
        [lbNotice setTextColor:[UIColor commonGrayTextColor]];
        [lbNotice setFont:[UIFont font_24]];
        
        bottomline = [[UIView alloc]init];
        [self addSubview:bottomline];
        [bottomline setBackgroundColor:[UIColor commonControlBorderColor]
         ];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
}

@end

@interface PersonBodyHeightValueView : UIView
{
    UILabel* lbName;
    UILabel* lbValue;
    UILabel* lbUnit;
}

- (void) setHeightValue:(float)height;
@end

@implementation PersonBodyHeightValueView


- (instancetype)init
{
    self = [super init];
    if (self) {
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setText:@"身高"];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont font_30]];
        
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        
        lbValue = [[UILabel alloc]init];
        [self addSubview:lbValue];
        [lbValue setText:[NSString stringWithFormat:@"%.1f", curUser.userHeight * 100]];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setFont:[UIFont font_30]];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setText:@"cm"];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setFont:[UIFont font_20]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5);
        make.bottom.equalTo(lbValue);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(lbUnit.mas_left).with.offset(-3);
    }];
    
}

- (void) setHeightValue:(float)height
{
    [lbValue setText:[NSString stringWithFormat:@"%.1f", height]];
}
@end

@interface  PersonBodyHeightPickerValueView : UIView
{
    
}
@property (nonatomic, readonly) UILabel* pickerLable;

- (void) setPickerComponent:(NSInteger) component;
@end

@implementation PersonBodyHeightPickerValueView

- (id) init
{
    self = [super init];
    if (self)
    {
        _pickerLable = [[UILabel alloc]init];
        [self addSubview:_pickerLable];
        [_pickerLable setBackgroundColor:[UIColor clearColor]];
        
        [_pickerLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void) setPickerComponent:(NSInteger) component
{
    switch (component)
    {
        case 0:
        {
            [_pickerLable setTextAlignment:NSTextAlignmentRight];
            [_pickerLable setFont:[UIFont font_34]];
            [_pickerLable setTextColor:[UIColor commonTextColor]];
            [_pickerLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-8);
                make.centerY.equalTo(self);
            }];
        }
            break;
        case 1:
        {
            [_pickerLable setTextAlignment:NSTextAlignmentLeft];
            [_pickerLable setFont:[UIFont font_30]];
            [_pickerLable setTextColor:[UIColor commonGrayTextColor]];
            [_pickerLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(8);
                make.centerY.equalTo(self);
            }];
        }
            break;
        default:
            break;
    }
}

@end

@interface PersonBodyHeightEditViewController ()
<UIPickerViewDelegate,
UIPickerViewDataSource,
TaskObserver>
{
    PersonBodyHeightNoticeView* noticeview;
    PersonBodyHeightValueView* valueview;
    UIView* sepview;
    UIPickerView* heightPicker;
    
    float userHeight;
    
    NSMutableArray* heightCMList;
    NSMutableArray* heightMMList;
    UIButton* commitButton;
}
@end

@implementation PersonBodyHeightEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"修改身高"];
    
    noticeview = [[PersonBodyHeightNoticeView alloc]init];
    [self.view addSubview:noticeview];
    
    valueview = [[PersonBodyHeightValueView alloc]init];
    [self.view addSubview:valueview];
    
    sepview = [[UIView alloc]init];
    [self.view addSubview:sepview];
    [sepview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    heightPicker = [[UIPickerView alloc]init];
    [self.view addSubview:heightPicker];
    [heightPicker setDataSource:self];
    [heightPicker setDelegate:self];
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commitButton];
    [commitButton setBackgroundColor:[UIColor mainThemeColor]];
    [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton.titleLabel setFont:[UIFont font_30]];
    commitButton.layer.cornerRadius = 2.5;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
    
    heightCMList = [NSMutableArray array];
    for (NSInteger index = 45; index < 250; ++index)
    {
        NSString* cm = [NSString stringWithFormat:@"%ld", index];
        [heightCMList addObject:cm];
    }
    
    heightMMList = [NSMutableArray array];
    for (NSInteger index = 0; index < 9; ++index)
    {
        NSString* mm = [NSString stringWithFormat:@".%ld cm", index];
        [heightMMList addObject:mm];
    }
    
    [heightPicker reloadAllComponents];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (0.4 > curUser.userHeight)
    {
        userHeight = curUser.userHeight * 100;
        [self defaultHeightInPicker:userHeight];
    }
    else
    {
        userHeight = 1.70 * 100;
        [self defaultHeightInPicker:userHeight];
    }
    //[heightPicker setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewLayout
{
    [noticeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [valueview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@45);
        make.top.equalTo(noticeview.mas_bottom);
    }];
    
    [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@5);
        make.top.equalTo(valueview.mas_bottom);
    }];
    
    [heightPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(sepview.mas_bottom).with.offset(15);
    }];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.height.mas_equalTo(@45);
        make.top.equalTo(heightPicker.mas_bottom).with.offset(23);
    }];
}

- (void) defaultHeightInPicker:(float) height
{
    if (0 == height)
    {
        return;
    }
    NSInteger heightCM = (NSInteger)height;
    NSString* cmStr = [NSString stringWithFormat:@"%ld", heightCM];
    NSInteger cmIndex = 0;
    for (NSInteger index = 0; index < heightCMList.count; ++index)
    {
        if ([cmStr isEqualToString:heightCMList[index]])
        {
            cmIndex = index;
            break;
        }
    }
    
    [heightPicker selectRow:cmIndex inComponent:0 animated:NO];
    
    NSInteger mmIndex = (NSInteger)(height * 10) - heightCM;
    if (mmIndex < 0 || mmIndex > 9)
    {
        mmIndex = 0;
    }
    [heightPicker selectRow:mmIndex inComponent:1 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            if (heightCMList)
            {
                return heightCMList.count;
            }
            return 0;
        }
            break;
        case 1:
        {
            if (heightMMList)
            {
                return heightMMList.count;
            }
            return 0;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            if (heightCMList)
            {
                return heightCMList[row];
            }
            return nil;
        }
            break;
        case 1:
        {
            if (heightMMList)
            {
                return heightMMList[row];
            }
            return nil;
        }
            break;
        default:
            break;
    }
    return nil;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            float heightMM = userHeight - (NSInteger)userHeight;
            NSInteger heightCM = row + 45;
            userHeight = heightCM + heightMM;
            [valueview setHeightValue:userHeight];
        }
            break;
        case 1:
        {
            NSInteger heightCM = (NSInteger) userHeight;
            float heightMM = (float)row / 10;
            userHeight = heightCM + heightMM;
            [valueview setHeightValue:userHeight];
        }
            break;
        default:
            break;
    }
}

- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    PersonBodyHeightPickerValueView* pickervalueview = (PersonBodyHeightPickerValueView*) view;
    if (!pickervalueview || ![pickervalueview isKindOfClass:[PersonBodyHeightPickerValueView class]])
    {
        pickervalueview = [[PersonBodyHeightPickerValueView alloc] init];
    }
    [pickervalueview setPickerComponent:component];
    
    pickervalueview.pickerLable.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickervalueview;
}

- (void) commitButtonClicked:(id) sender
{
    //UpdateUserInfoTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%.3f", userHeight / 100.0] forKey:@"height"];
    [self.view showWaitView:@"修改用户身高"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserInfoTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
//    if (StepError_None == taskError)
//    {
//        //跳转 个人信息设置界面
//        [HMViewControllerManager createViewControllerWithControllerName:@"PersonInfoViewController" ControllerObject:nil];
//        return;
//    }
//    [self showAlertMessage:errorMessage];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UpdateUserInfoTask"]) {
        //先保存一下用户信息
        [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
    }
    
    if ([taskname isEqualToString:@"UserInfoTask"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end

@interface PersonBodyWeightValueView : UIView
{
    UILabel* lbName;
    UILabel* lbValue;
    UILabel* lbUnit;
}

- (void) setWeightValue:(float)weight;
@end

@implementation PersonBodyWeightValueView


- (instancetype)init
{
    self = [super init];
    if (self) {
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setText:@"体重"];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont font_30]];
        
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        
        lbValue = [[UILabel alloc]init];
        [self addSubview:lbValue];
        [lbValue setText:[NSString stringWithFormat:@"%.1f", curUser.userWeight]];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setFont:[UIFont font_30]];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setText:@"kg"];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        [lbUnit setFont:[UIFont font_20]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5);
        make.bottom.equalTo(lbValue);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(lbUnit.mas_left).with.offset(-3);
    }];
    
}

- (void) setWeightValue:(float)weight
{
    [lbValue setText:[NSString stringWithFormat:@"%.1f", weight]];
}
@end

@interface  PersonBodyWeightPickerValueView : UIView
{
    
}
@property (nonatomic, readonly) UILabel* pickerLable;

- (void) setPickerComponent:(NSInteger) component;
@end

@implementation PersonBodyWeightPickerValueView

- (id) init
{
    self = [super init];
    if (self)
    {
        _pickerLable = [[UILabel alloc]init];
        [self addSubview:_pickerLable];
        [_pickerLable setBackgroundColor:[UIColor clearColor]];
        
        [_pickerLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void) setPickerComponent:(NSInteger) component
{
    switch (component)
    {
        case 0:
        {
            [_pickerLable setTextAlignment:NSTextAlignmentRight];
            [_pickerLable setFont:[UIFont font_34]];
            [_pickerLable setTextColor:[UIColor commonTextColor]];
            [_pickerLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-8);
                make.centerY.equalTo(self);
            }];
        }
            break;
        case 1:
        {
            [_pickerLable setTextAlignment:NSTextAlignmentLeft];
            [_pickerLable setFont:[UIFont font_30]];
            [_pickerLable setTextColor:[UIColor commonGrayTextColor]];
            [_pickerLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(8);
                make.centerY.equalTo(self);
            }];
        }
            break;
        default:
            break;
    }
}

@end


@interface PersonBodyWeightEditViewController ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
TaskObserver>
{
    PersonBodyHeightNoticeView* noticeview;
    PersonBodyWeightValueView* valueview;
    
    UIPickerView* weightPicker;
    float userWeight;
    NSMutableArray* weightKgList;   //整数
    NSMutableArray* weightHgList;   //小数
}
@end

@implementation PersonBodyWeightEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"修改体重"];
    
    noticeview = [[PersonBodyHeightNoticeView alloc]init];
    [self.view addSubview:noticeview];
    
    [noticeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    valueview = [[PersonBodyWeightValueView alloc]init];
    [self.view addSubview:valueview];
    
    [valueview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@45);
        make.top.equalTo(noticeview.mas_bottom);
    }];
    
    UIView* sepview = [[UIView alloc]init];
    [self.view addSubview:sepview];
    [sepview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@5);
        make.top.equalTo(valueview.mas_bottom);
    }];
    
    weightKgList = [NSMutableArray array];
    for (NSInteger index = 20; index <= 180; ++index)
    {
        NSString* kgStr = [NSString stringWithFormat:@"%ld", index];
        [weightKgList addObject:kgStr];
    }
    
    weightHgList = [NSMutableArray array];
    for (NSInteger index = 0; index < 10; ++index)
    {
        NSString* kgStr = [NSString stringWithFormat:@".%ld kg", index];
        [weightHgList addObject:kgStr];
    }
    
    weightPicker = [[UIPickerView alloc]init];
    [self.view addSubview:weightPicker];
    [weightPicker setDataSource:self];
    [weightPicker setDelegate:self];
    
    [weightPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(sepview.mas_bottom).with.offset(15);
    }];
    
    UIButton* commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commitButton];
    [commitButton setBackgroundColor:[UIColor mainThemeColor]];
    [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton.titleLabel setFont:[UIFont font_30]];
    commitButton.layer.cornerRadius = 2.5;
    commitButton.layer.masksToBounds = YES;
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.height.mas_equalTo(@45);
        make.top.equalTo(weightPicker.mas_bottom).with.offset(23);
    }];
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置缺省身高
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (20 < curUser.userWeight) {
        [self setUserDefaultWeight:curUser.userWeight];
    }
    else
    {
        [self setUserDefaultWeight:70];
    }
}

- (void) setUserDefaultWeight:(CGFloat) bodyWeight
{
    NSInteger bwKg = (NSInteger)bodyWeight;
    NSInteger kgIndex = bwKg - 20;
    NSInteger hgIndex = bodyWeight * 10 - bwKg * 10;
    
    CGFloat mod = bodyWeight - (bwKg + 0.1 * hgIndex);
    if (mod > 0.05)
    {
        hgIndex += 1;
    }
    
    [weightPicker selectRow:kgIndex inComponent:0 animated:NO];
    [weightPicker selectRow:hgIndex inComponent:1 animated:NO];
    
    userWeight = bodyWeight;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            //整数
            if (weightKgList)
            {
                return weightKgList.count;
            }
        }
            break;
        case 1:
        {
            //小数
            if (weightHgList)
            {
                return weightHgList.count;
            }
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* weightStr = nil;
    switch (component)
    {
        case 0:
        {
            //整数
            if (weightKgList && row < weightKgList.count)
            {
                weightStr = weightKgList[row];
            }
        }
            break;
        case 1:
        {
            //小数
            if (weightHgList && row < weightHgList.count)
            {
                weightStr = weightHgList[row];
            }
        }
            break;
        default:
            break;
    }
    
    return weightStr;
}

- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    PersonBodyWeightPickerValueView* pickervalueview = (PersonBodyWeightPickerValueView*) view;
    if (!pickervalueview || ![pickervalueview isKindOfClass:[PersonBodyWeightPickerValueView class]])
    {
        pickervalueview = [[PersonBodyWeightPickerValueView alloc] init];
    }
    [pickervalueview setPickerComponent:component];
    
    pickervalueview.pickerLable.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickervalueview;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            float weightKg = userWeight - (NSInteger)userWeight;
            NSInteger weightHg = row + 20;
            userWeight = weightHg + weightKg;
            [valueview setWeightValue:userWeight];
        }
            break;
        case 1:
        {
            NSInteger heightKg = (NSInteger) userWeight;
            float heightHg = (float)row / 10;
            userWeight = heightKg + heightHg;
            [valueview setWeightValue:userWeight];
        }
            break;
        default:
            break;
    }
}

- (void) commitButtonClicked:(id) sender
{
    //UpdateUserInfoTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%.1f", userWeight] forKey:@"weight"];
    [self.view showWaitView:@"修改用户体重"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserInfoTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None == taskError)
    {
        //跳转 个人信息设置界面
        [HMViewControllerManager createViewControllerWithControllerName:@"PersonInfoViewController" ControllerObject:nil];
        return;
    }
    [self showAlertMessage:errorMessage];
}


@end


