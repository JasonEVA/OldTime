//
//  AppointmentReceiveViewController.m
//  HMDoctor
//
//  Created by lkl on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppointmentReceiveViewController.h"
#import "SelectAppointmentTimeView.h"

@interface AppointmentReceiveViewController ()<UITextViewDelegate,TaskObserver>
{
    UIControl *timeControl;
    UILabel *lbtime;
    UILabel *label;
    
    UIView *locationView;
    SelectAppointmentTimeView *testTimeView;
    
    UITextView *txView;
}
@end

@implementation AppointmentReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithTimeSubViews];

    [self initWithLocationSubViews];

    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initWithTimeSubViews
{
    timeControl = [[UIControl alloc] init];
    [self.view addSubview:timeControl];
    [timeControl setBackgroundColor:[UIColor whiteColor]];
    [timeControl addTarget:self action:@selector(timeControlClick) forControlEvents:UIControlEventTouchUpInside];

    [timeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyInfoView.mas_bottom).with.offset(15);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [timeControl addSubview:lbtitle];
    [lbtitle setText:@"就诊时间:"];
    [lbtitle setTextColor:[UIColor commonDarkGrayTextColor]];
    [lbtitle setFont:[UIFont systemFontOfSize:15]];
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.centerY.equalTo(timeControl);
        make.width.mas_equalTo(@80);
    }];
    
    lbtime = [[UILabel alloc] init];
    [timeControl addSubview:lbtime];
    [lbtime setTextColor:[UIColor commonTextColor]];
    [lbtime setFont:[UIFont systemFontOfSize:14]];
    [lbtime setText:@"点击选择时间"];
    
    [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbtitle.mas_right).with.offset(5);
        make.centerY.equalTo(timeControl);
        make.width.mas_equalTo(@150);
    }];

}

- (void)timeControlClick
{
    [self.view endEditing:YES];
    if (testTimeView.superview) {
        return;
    }

    testTimeView = [[SelectAppointmentTimeView alloc] init];
    [testTimeView setBackgroundColor:[UIColor mainThemeColor]];
    [self.view addSubview:testTimeView];
    
    __weak typeof(lbtime) weakLbTime = lbtime;
    testTimeView.testTimeBlock = ^(NSString *testTime){
        [weakLbTime setText:testTime];
    };
    
    [testTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-260);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(260);
    }];
}

- (void)initWithLocationSubViews
{
    locationView = [[UIView alloc] init];
    [self.view addSubview:locationView];
    [locationView setBackgroundColor:[UIColor whiteColor]];
    
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeControl.mas_bottom).with.offset(15);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@95);
    }];

    txView = [[UITextView alloc] init];
    [locationView addSubview:txView];
    [txView setFont:[UIFont systemFontOfSize:15]];
    [txView setDelegate:self];

    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(locationView).with.offset(10);
        make.right.equalTo(locationView.mas_right).with.offset(-12.5);
        make.bottom.equalTo(locationView.mas_bottom).with.offset(-10);
    }];
    
    label = [[UILabel alloc] init];
    [label setEnabled:NO];
    [label setText:@"请输入就诊地点"];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor commonGrayTextColor]];
    [locationView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(locationView).with.offset(15);
        make.right.equalTo(locationView.mas_right).with.offset(-12.5);
        make.height.mas_equalTo(@25);
    }];
}

- (void)confirmBtnClicked
{
    if ([lbtime.text isEqualToString:@"点击选择时间"])
    {
        [self showAlertMessage:@"请选择约诊时间"];
        return;
    }
    
    if (txView.text.length == 0)
    {
        [self showAlertMessage:@"请填写约诊地点"];
        return;
    }
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld",appointInfo.appointId] forKey:@"appointId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",appointInfo.userId] forKey:@"doUserId"];
    [dicPost setValue:@"Y" forKey:@"status"];
    [dicPost setValue:@"4" forKey:@"doWay"];
    [dicPost setValue:lbtime.text forKey:@"appointDate"];
    [dicPost setValue:txView.text forKey:@"appointAddr"];
    [dicPost setValue:@"同意" forKey:@"content"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"DealUserAppointmetnTask" taskParam:dicPost TaskObserver:self];
    
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    if ([taskname isEqualToString:@"DealUserAppointmetnTask"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        label.text = @"请输入就诊地点";
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [testTimeView removeFromSuperview];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [testTimeView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
