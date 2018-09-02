//
//  BreathingDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingDetectResultViewController.h"
#import "BreathingResultValueView.h"
#import "BreathingResultView.h"
#import "BreathingSymptomView.h"
#import "BreathingUpdateSymptomView.h"

@interface BreathingDetectResultViewController ()<TaskObserver,UITextViewDelegate>
{
    UIScrollView* scrollview;
    UIView* contentview;
    CGFloat keyboardHeight;
    
    BreathingResultValueView* retValueView;
    BreathingResultView* retView;
    BreathingSymptomView* symptomView;
    BreathingUpdateSymptomView* updateSymptomView;
    
    DetectAlertInterrogationControl* interrogationControl;
    
    NSInteger surveyId;
    NSString* surveyModuleName;
}
@end

@implementation BreathingDetectResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];

    CGRect rtScroll = CGRectMake(0, 0, self.view.width, 504);
    scrollview = [[UIScrollView alloc]initWithFrame:rtScroll];
    [self.view addSubview:scrollview];
    
    contentview = [[UIView alloc]initWithFrame:scrollview.bounds];
    [scrollview addSubview:contentview];
    //[contentview setBackgroundColor:[UIColor redColor]];
    [self createResultView];
    
    [self registerForKeyboardNotifications];
}

- (void)createResultView
{
    retValueView = [[BreathingResultValueView alloc]init];
    [contentview addSubview:retValueView];
    
    interrogationControl = [[DetectAlertInterrogationControl alloc]init];
    [interrogationControl addTarget:self action:@selector(interrogationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentview addSubview:interrogationControl];
    [interrogationControl setHidden:YES];
    
    retView = [[BreathingResultView alloc]init];
    [contentview addSubview:retView];
    
    symptomView = [[BreathingSymptomView alloc] init];
    [self.view addSubview:symptomView];
    [symptomView setHidden:YES];
    [symptomView.deleteButton addTarget:self action:@selector(symptomDelete) forControlEvents:UIControlEventTouchUpInside];
    [symptomView.editButton addTarget:self action:@selector(symptomEdit) forControlEvents:UIControlEventTouchUpInside];
    
    updateSymptomView = [[BreathingUpdateSymptomView alloc] init];
    [contentview addSubview:updateSymptomView];
    [updateSymptomView setHidden:YES];
    [updateSymptomView.txView setDelegate:self];
    [updateSymptomView.saveButton addTarget:self action:@selector(updateSymptomSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
    [scrollview setContentSize:contentview.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) resultTaskName
{
    return @"BreathingDetectResultTask";
}

- (void) interrogationControlClicked:(id) sender
{
    SurveyRecord *record = [[SurveyRecord alloc]init];
    
    [record setSurveyId:[NSString stringWithFormat:@"%ld", surveyId]];
    [record setSurveyMoudleName:surveyModuleName];
    [record setUserId:[NSString stringWithFormat:@"%ld", userId]];
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
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
    [HMViewControllerManager createViewControllerWithControllerName:@"BreathingRecordsStartViewController" ControllerObject:targetUser];
}

- (void) subviewLayout
{
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.bottom.and.right.equalTo(self.view);
    }];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(scrollview);
        make.width.equalTo(scrollview);
        make.height.mas_equalTo(504 * kScreenScale);
    }];
    
    [retValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(contentview);
        make.height.mas_equalTo(@144);
    }];
    
    [interrogationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(contentview);
        make.top.equalTo(retValueView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(45);
    }];
    
    [retView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(retValueView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@95);
    }];
    
    [symptomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(retView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@200);
    }];
    
    [updateSymptomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(retView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@200);
    }];
    
}

- (void)symptomDelete
{
    [updateSymptomView setHidden:YES];
    [symptomView removeFromSuperview];
    
    //
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:@"" forKey:@"symptom"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"BreathingSymptomUpdateTask" taskParam:dicPost TaskObserver:self];
}

- (void)symptomEdit
{
    [symptomView setHidden:YES];
    [updateSymptomView setHidden:NO];
    
    [updateSymptomView.txView setText:symptomView.lbResult.text];
    [updateSymptomView.label setText:@""];
    
    [self updateSymptomViewConstraints];
}

- (void)updateSymptomSaveButtonClick
{
    [updateSymptomView setHidden:YES];
    [symptomView setHidden:NO];
    [symptomView.lbResult setText:updateSymptomView.txView.text];
    
    [self updateSymptomViewConstraints];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:updateSymptomView.txView.text forKey:@"symptom"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"BreathingSymptomUpdateTask" taskParam:dicPost TaskObserver:self];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    BreathingDetctResult* breathResult = (BreathingDetctResult*) result;
    [retValueView setDetectResult:breathResult];
    if (0 < breathResult.surveyId && breathResult.surveyMoudleName && 0 < breathResult.surveyMoudleName.length)
    {
        surveyId = breathResult.surveyId;
        userId = breathResult.userId;
        surveyModuleName = breathResult.surveyMoudleName;
        [interrogationControl setHidden:NO];
        [interrogationControl setSurveyModuleName:breathResult.surveyMoudleName];
        
        [retView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(interrogationControl.mas_bottom).with.offset(5);
            make.height.mas_equalTo(@95);
        }];
    }

    [retView setDetectResult:breathResult];
    
    if (breathResult.symptom && breathResult.symptom.length > 0)
    {
        [symptomView setHidden:NO];
        [symptomView setDetectResult:breathResult];
        
        [self updateSymptomViewConstraints];

    }else{
        
        [symptomView setHidden:YES];
        [updateSymptomView setHidden:NO];
    }
    
    if (![self userIsSelf])
    {
        //用户不是自己
        [updateSymptomView setHidden:YES];
        [symptomView setHidden:YES];
    }
    
}


- (void)updateSymptomViewConstraints
{
    CGFloat resultheight = [symptomView.lbResult.text heightSystemFont:symptomView.lbResult.font width:symptomView.lbResult.width];
    
    [symptomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(resultheight + 70);
    }];
}

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
    ///keyboardWasShown = YES;
    
    if (updateSymptomView.txView)
    {
        
        CGFloat offsetHeight = scrollview.height - 32 - (keyboardHeight + updateSymptomView.txView.bottom + updateSymptomView.top);
        if (offsetHeight > 0) {
            offsetHeight = 0;
        }
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        
        contentview.frame = CGRectMake(0.0f, offsetHeight, contentview.width, contentview.height);//64-216
        
        [UIView commitAnimations];
    }
    
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardHeight = 0;
    // keyboardWasShown = NO;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    contentview.frame = CGRectMake(0.0f, 0.0f, contentview.width, contentview.height);//64-216
    [UIView commitAnimations];
}

#pragma mark -- textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        updateSymptomView.label.text = @"如果您有呼吸不适的症状，请输入您的症状";
    }else
    {
        updateSymptomView.label.text = @"";
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

@end
