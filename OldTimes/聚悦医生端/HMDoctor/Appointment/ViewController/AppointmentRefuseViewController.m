//
//  AppointmentRefuseViewController.m
//  HMDoctor
//
//  Created by lkl on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppointmentRefuseViewController.h"

@interface AppointmentRefuseViewController ()<UITextViewDelegate,TaskObserver>
{
    UILabel *label;
    UITextView *txView;
}
@end

@implementation AppointmentRefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *refuseView = [[UIView alloc] init];
    [self.view addSubview:refuseView];
    [refuseView setBackgroundColor:[UIColor whiteColor]];
    
    [refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyInfoView.mas_bottom).with.offset(15);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@95);
    }];

    txView = [[UITextView alloc] init];
    [self.view addSubview:txView];
    [txView setFont:[UIFont systemFontOfSize:15]];
    [txView setDelegate:self];
    
    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(refuseView).with.offset(10);
        make.right.equalTo(refuseView.mas_right).with.offset(-12.5);
        make.bottom.equalTo(refuseView.mas_bottom).with.offset(-10);
    }];
    
    label = [[UILabel alloc] init];
    [label setEnabled:NO];
    [label setText:@"请输入拒绝理由"];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor commonGrayTextColor]];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12.5);
        make.top.equalTo(refuseView).with.offset(15);
        make.right.equalTo(refuseView.mas_right).with.offset(-12.5);
        make.height.mas_equalTo(@25);
    }];
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmBtnClick
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld",appointInfo.appointId] forKey:@"appointId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",appointInfo.userId] forKey:@"doUserId"];
    [dicPost setValue:@"N" forKey:@"status"];
    [dicPost setValue:@"4" forKey:@"doWay"];
    [dicPost setValue:txView.text forKey:@"content"];
    
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
        label.text = @"请输入拒绝理由";
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 #import "PlaceholderTextView.h"
 PlaceholderTextView* tvSymptom;
 tvSymptom = [[PlaceholderTextView alloc]init];
 [self.view addSubview:tvSymptom];
 [tvSymptom setPlaceholder:@"请输入详细症状，病因，想获取的帮助等。"];
 [tvSymptom.layer setBorderWidth:0.5];
 [tvSymptom.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
 
 [tvSymptom setFont:[UIFont systemFontOfSize:14]];
 [tvSymptom setTextColor:[UIColor commonTextColor]];
 [tvSymptom setReturnKeyType:UIReturnKeyDone];
 [tvSymptom setDelegate:self];
 
 [tvSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(self.view).with.offset(12.5);
 make.right.equalTo(self.view).with.offset(-12.5);
 make.top.equalTo(headerview.mas_bottom);
 make.height.mas_equalTo(@93);
 }];
 */
@end
