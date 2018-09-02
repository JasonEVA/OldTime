//
//  BodyTemperatureDetectResultViewController.m
//  HMClient
//
//  Created by yinquan on 17/4/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectResultViewController.h"
#import "BodyTemperatureDetectResultInstructView.h"
#import "CommonResultDetectTimeView.h"
#import "BodyTemperatureDetectRecord.h"
#import "BodyTemperatureDetectResultView.h"
#import "BodyTemperatureDetectResultRemarksView.h"
#import "DetectSymptomEditView.h"

@interface BodyTemperatureDetectResultViewController ()<TaskObserver>
{
    CGFloat keyboardHeight;
}

@property (nonatomic, readonly) UIScrollView* scrollView;
@property (nonatomic, readonly) CommonResultDetectTimeView* detectTimeView;
@property (nonatomic, readonly) BodyTemperatureDetectResultInstructView* instructView;
@property (nonatomic, readonly) BodyTemperatureDetectResultView* resultViwe;
@property (nonatomic, readonly) BodyTemperatureDetectResultRemarksView* remarkView;
@property (nonatomic, readonly) BodyTemperatureDetectResponsibilityRemarksView* responsibilityView;
@property (nonatomic,strong) DetectSymptomEditView *symptomEditView;
@end

@implementation BodyTemperatureDetectResultViewController

@synthesize scrollView = _scrollView;
@synthesize detectTimeView = _detectTimeView;
@synthesize instructView = _instructView;
@synthesize resultViwe = _resultViwe;
@synthesize remarkView = _remarkView;
@synthesize responsibilityView = _responsibilityView;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    [self scrollView];
    [self instructView];
    
    [self registerForKeyboardNotifications];
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (userId)
    {
        [targetUser setUserId:userId];
    }
    else
    {
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [targetUser setUserId:curUser.userId];
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectsRecordsStartViewController" ControllerObject:targetUser];
}

- (void) viewDidLayoutSubviews
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.detectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [self.instructView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@50);
        make.height.mas_equalTo(@175);
    }];
    
    [self.resultViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.instructView.mas_bottom).with.offset(5);
        make.height.mas_greaterThanOrEqualTo(@65);
//        make.height.mas_equalTo(@65);
    }];
    
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.resultViwe.mas_bottom);
        make.height.mas_offset(@200);
    }];
    
    [self.symptomEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.resultViwe.mas_bottom);
        make.height.mas_offset(@200);
    }];
    
    [self.responsibilityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.remarkView.mas_bottom);
        make.height.mas_equalTo(@105);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*) resultTaskName
{
    return @"BodyTemperatureDetectResultTask";
}


- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    detectResult = result;
    BodyTemperatureDetectResult* temperatureResult = (BodyTemperatureDetectResult*)result;
    
    
    [self.instructView setTemperature:temperatureResult.temperature];
    [self.detectTimeView setDetectResult:detectResult];
    
    [self.resultViwe setUserAlertResult:temperatureResult.userAlertResult];
    
    if (temperatureResult.symptom && temperatureResult.symptom.length > 0)
    {
        [_remarkView setHidden:YES];
        [_symptomEditView setHidden:NO];
        [_symptomEditView setDetectResult:temperatureResult];
        
        [self updateSymptomViewConstraints];
        
    }else{
        
        [_symptomEditView setHidden:YES];
        [_remarkView setHidden:NO];
    }
    
    NSLog(@"result height = %f", self.responsibilityView.bottom);
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.responsibilityView.bottom)];
}

#pragma mark - Medthod
//症状提交
- (void)remarkCommitButtonClick:(UIButton *)sender
{
    [_symptomEditView setHidden:NO];
    [_remarkView setHidden:YES];
    [_symptomEditView.contentLabel setText:_remarkView.symptomTextView.text];
    
    [self updateSymptomViewConstraints];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:_remarkView.symptomTextView.text forKey:@"symptom"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectSymptomEditTask" taskParam:dicPost TaskObserver:self];
}

//症状删除
- (void)symptomDeleteButtonClick:(UIButton *)sender
{
    [_remarkView setHidden:NO];
    [_symptomEditView setHidden:YES];
    [_remarkView.symptomTextView setText:@""];
    //
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:@"" forKey:@"symptom"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectSymptomEditTask" taskParam:dicPost TaskObserver:self];
}

//症状编辑
- (void)symptomeditButtonClick:(UIButton *)sender
{
    [_symptomEditView setHidden:YES];
    [_remarkView setHidden:NO];
    
    [_remarkView.symptomTextView setText:_symptomEditView.contentLabel.text];
    [_remarkView.symptomTextView setPlaceholder:@""];
    
    [self updateSymptomViewConstraints];
}

//更新
- (void)updateSymptomViewConstraints
{
    CGFloat resultheight = [_symptomEditView.contentLabel.text heightSystemFont:_symptomEditView.contentLabel.font width:_symptomEditView.contentLabel.width];
    
    float symptomEditViewHeight = resultheight + 70;

    if (symptomEditViewHeight > 200) {
        [_symptomEditView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(resultheight + 70);
        }];
        
        [self.responsibilityView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.symptomEditView.mas_bottom);
            make.height.mas_equalTo(@105);
        }];
        NSLog(@"result height = %f", self.responsibilityView.bottom);
        [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.responsibilityView.bottom)];
    }
}

#pragma mark - settingAndGetting
- (UIScrollView*) scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [self.scrollView setContentSize:CGSizeMake(kScreenWidth, 800)];
    }
    
    return _scrollView;
}

- (CommonResultDetectTimeView*) detectTimeView
{
    if (!_detectTimeView) {
        _detectTimeView = [[CommonResultDetectTimeView alloc] init];
        [_detectTimeView showBottomLine];
        [self.scrollView addSubview:_detectTimeView];
    }
    return _detectTimeView;
}

- (BodyTemperatureDetectResultInstructView*) instructView
{
    if(!_instructView) {
        _instructView = [[BodyTemperatureDetectResultInstructView alloc] init];
        [self.scrollView addSubview:_instructView];
    }
    
    return _instructView;
}

- (BodyTemperatureDetectResultView*) resultViwe
{
    if (!_resultViwe) {
        _resultViwe = [[BodyTemperatureDetectResultView alloc] init];
        [self.scrollView addSubview:_resultViwe];
    }
    
    return _resultViwe;
}

- (DetectSymptomEditView *)symptomEditView{
    if (!_symptomEditView) {
        _symptomEditView = [[DetectSymptomEditView alloc] init];
        [self.scrollView addSubview:_symptomEditView];
        [_symptomEditView setHidden:YES];
        [_symptomEditView.delButton addTarget:self action:@selector(symptomDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_symptomEditView.editButton addTarget:self action:@selector(symptomeditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _symptomEditView;
}

- (BodyTemperatureDetectResultRemarksView*) remarkView
{
    if (!_remarkView) {
        _remarkView = [[BodyTemperatureDetectResultRemarksView alloc] init];
        [self.scrollView addSubview:_remarkView];
        [_remarkView.commitButton addTarget:self action:@selector(remarkCommitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _remarkView;
}

- (BodyTemperatureDetectResponsibilityRemarksView*) responsibilityView
{
    if(!_responsibilityView)
    {
        _responsibilityView = [[BodyTemperatureDetectResponsibilityRemarksView alloc] init];
        [self.scrollView addSubview:_responsibilityView];
    }
    return _responsibilityView;
}

#pragma mark - Keyboard

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
    
    
    CGRect tvFrame = [self.remarkView.symptomTextView convertRect:self.remarkView.symptomTextView.frame toView:self.view];
    CGFloat tvBottom = tvFrame.origin.y + tvFrame.size.height;
    CGFloat maxOffset = self.scrollView.contentOffset.y - (self.view.height - keyboardHeight) + tvBottom + 5;
    
    if (maxOffset < 0)
    {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(0, maxOffset) animated:YES];
    [self.scrollView setScrollEnabled:NO];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardHeight = 0;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
