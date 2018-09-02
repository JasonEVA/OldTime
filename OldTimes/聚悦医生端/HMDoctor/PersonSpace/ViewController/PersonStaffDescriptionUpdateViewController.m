//
//  PersonStaffDescriptionUpdateViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/7/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PersonStaffDescriptionUpdateViewController.h"
#import "PlaceholderTextView.h"

@interface PersonStaffDescriptionUpdateViewController ()
<TaskObserver>


@end

@implementation PersonStaffDescriptionUpdateViewController

@synthesize inputTextView = _inputTextView;
@synthesize updateButton = _updateButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.inputTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputTextView becomeFirstResponder];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220, 45));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-264);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(self.updateButton.mas_top).with.offset(-10);
    }];
}

- (void) updateButtonClicked:(id) sender
{
    //验证输入是否正确
    NSString* inputString = self.inputTextView.text;
    if (!inputString || inputString.length == 0) {
        [self showAlertMessage:@"请正确输入内容。"];
        return;
    }
    
    [self updateDescription:inputString];
}

- (void) updateDescription:(NSString*) inputString
{
    if (!inputString) {
        return;
    }
    NSDictionary* postDictionary = [self updateDescriptionParam:inputString];
    if (!postDictionary) {
        return;
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateStaffInfoTask" taskParam:postDictionary TaskObserver:self];
}

- (NSMutableDictionary*) updateDescriptionParam:(NSString*) inputString
{
    return nil;
}

#pragma mark - settingAndGetting

- (PlaceholderTextView*) inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[PlaceholderTextView alloc] init];
        [self.view addSubview:_inputTextView];
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _inputTextView.layer.masksToBounds = YES;
        
        [_inputTextView setFont:[UIFont systemFontOfSize:15]];
    }
    return _inputTextView;
}

- (UIButton*) updateButton
{
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_updateButton];
        [_updateButton setBackgroundImage:[UIImage rectImage:CGSizeMake(200, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_updateButton setTitle:@"提交" forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _updateButton.layer.cornerRadius = 5;
        _updateButton.layer.masksToBounds = YES;
        
        [_updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    
    if ([taskname isEqualToString:@"UpdateStaffInfoTask"])
    {
        if (taskError != StepError_None) {
            [self showAlertMessage:errorMessage];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    
}
@end

@implementation PersonStaffDescriptionGoodAtUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputTextView setPlaceholder:@"请输入您的擅长"];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [self.inputTextView setText:curStaff.gootAt];
}

- (NSMutableDictionary*) updateDescriptionParam:(NSString*) inputString
{
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    [postDictionary setValue:inputString forKey:@"gootAt"];
    return postDictionary;
}
@end

@implementation PersonStaffDescriptionSummaryUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputTextView setPlaceholder:@"请输入您的简介"];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [self.inputTextView setText:curStaff.staffDesc];
}

- (NSMutableDictionary*) updateDescriptionParam:(NSString*) inputString
{
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    [postDictionary setValue:inputString forKey:@"staffDesc"];
    return postDictionary;
}
@end
