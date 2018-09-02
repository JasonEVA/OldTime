//
//  CDADiagnosisInputViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDADiagnosisInputViewController.h"
#import "PlaceholderTextView.h"
#import "CreateDocumetnMessionInfo.h"

@interface CDADiagnosisInputViewController ()
<TaskObserver>
{
    PlaceholderTextView* diagnosisTextView;
}
@property (nonatomic, readonly) CreateDocumetnTemplateTypeModel* typeModel;
@end

@implementation CDADiagnosisInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"诊断"];
    if (self.paramObject && [self.paramObject isKindOfClass:[CreateDocumetnTemplateTypeModel class]])
    {
        _typeModel = (CreateDocumetnTemplateTypeModel*) self.paramObject;
    }
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    diagnosisTextView = [[PlaceholderTextView alloc]init];
    [self.view addSubview:diagnosisTextView];
    [diagnosisTextView setPlaceholder:@"请输入评估内容"];
    [diagnosisTextView setTextColor:[UIColor commonTextColor]];
    diagnosisTextView.layer.borderWidth = 0.5;
    diagnosisTextView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
    diagnosisTextView.layer.cornerRadius = 2.5;
    diagnosisTextView.layer.masksToBounds = YES;
    
    [diagnosisTextView setFont:[UIFont systemFontOfSize:14]];
    [diagnosisTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(2.5);
        make.height.mas_equalTo(@236);
    }];
    
    [diagnosisTextView setText:_typeModel.reportComments];
    
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [historybutton setTitle:@"保存" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [historybutton addTarget:self action:@selector(saveDiagnosisButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];

    
    [diagnosisTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveDiagnosisButtonClicked:(id) sender
{
    NSString* remark = diagnosisTextView.text;
    if (!remark || 0 == remark.length)
    {
        [self showAlertMessage:@"请输入评估内容"];
        return;
    }
    
    //更新用户诊断
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:remark forKey:@"diagnosisContent"];
    [dicPost setValue:_typeModel.recordId forKey:@"recordId"];
    [dicPost setValue:[NSNumber numberWithInteger:staff.staffId] forKey:@"doctorUserId"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CDAUpdateDiagnosisTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
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
    
    
}

@end
