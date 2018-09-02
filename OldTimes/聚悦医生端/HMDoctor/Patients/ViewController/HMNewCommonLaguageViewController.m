//
//  HMNewCommonLaguageViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMNewCommonLaguageViewController.h"
#import "HMNewEditCommonLangageRequest.h"

@interface HMNewCommonLaguageViewController ()<TaskObserver>
@end

@implementation HMNewCommonLaguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"常用语"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.JWTextView];
    [self.JWTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(5);
        make.height.equalTo(@160);
    }];
    [self.JWTextView becomeFirstResponder];

}
- (void)rightClick {
    if (self.JWTextView.text.length > 0) {
        StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"staffId"];
        [dict setValue:self.JWTextView.text forKey:@"content"];
        if (self.commonLanguageId.length > 0) {
            [dict setValue:self.commonLanguageId forKey:@"commonLanguageId"];
        }
        [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([HMNewEditCommonLangageRequest class]) taskParam:dict TaskObserver:self];

    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult {
    NSLog(@"常用语保存成功");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage {
    if (StepError_None != taskError &&errorMessage.length > 0)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (UITextView *)JWTextView {
    if (!_JWTextView) {
        _JWTextView = [UITextView new];
        [_JWTextView setFont:[UIFont systemFontOfSize:15]];
    }
    return _JWTextView;
}
@end
