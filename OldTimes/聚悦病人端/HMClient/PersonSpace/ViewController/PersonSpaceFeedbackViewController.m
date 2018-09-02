//
//  PersonSpaceFeedbackViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceFeedbackViewController.h"
#import "PlaceholderTextView.h"

@interface PersonSpaceFeedbackViewController ()<UITextViewDelegate,TaskObserver>
{
    UIButton *submitBtn;
    PlaceholderTextView *txView;
}
@end

@implementation PersonSpaceFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"意见反馈"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    txView = [[PlaceholderTextView alloc]init];
    [self.view addSubview:txView];
    [txView setPlaceholder:@"感谢您的宝贵意见或建议"];
    [txView.layer setBorderWidth:0.5];
    [txView.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
    
    [txView setFont:[UIFont font_28]];
    [txView setTextColor:[UIColor commonTextColor]];
    [txView setReturnKeyType:UIReturnKeyDone];
    [txView setDelegate:self];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    [submitBtn setBackgroundColor:[UIColor mainThemeColor]];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn.layer setCornerRadius:3.0f];
    [submitBtn.layer setMasksToBounds:YES];
    
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewsLayout];
}

- (void)subViewsLayout
{
    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(@250);
    }];
    
   /* [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(250);
    }];*/
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txView.mas_bottom).with.offset(25);
        make.left.equalTo(txView);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)submitBtnClicked
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    if (txView.text.length == 0)
    {
        [self.view showAlertMessage:@"请输入您的宝贵意见或建议！"];
        return;
    }
    [dicPost setValue:txView.text forKey:@"msg"];
    [dicPost setValue:@"YJFK" forKey:@"msgType"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"addMessageTask" taskParam:dicPost TaskObserver:self];
    
}

#pragma mark--UITextViewDelegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
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
    
    if ([taskname isEqualToString:@"addMessageTask"])
    {
        //[self showAlertMessage:@"提交成功"];
        //[self.navigationController popViewControllerAnimated:YES];
        [self showAlertMessage:@"提交成功" clicked:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
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
