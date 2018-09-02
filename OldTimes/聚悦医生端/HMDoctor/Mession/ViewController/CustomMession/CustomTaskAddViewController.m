//
//  CustomTaskAddViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CustomTaskAddViewController.h"
#import "SelectAppointmentTimeView.h"
#import "UserScheduleInfo.h"

@interface EditDateControl ()
{
    UILabel *lbName;
    UIImageView *ivRightArrow;
}
@end

@implementation EditDateControl

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"日期"];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        
        _lbTime = [[UILabel alloc] init];
        [self addSubview:_lbTime];
        [_lbTime setText:@"请选择日期"];
        [_lbTime setTextColor:[UIColor commonTextColor]];
        [_lbTime setFont:[UIFont systemFontOfSize:15]];
        
        [_lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        ivRightArrow = [[UIImageView alloc] init];
        [self addSubview:ivRightArrow];
        [ivRightArrow setImage:[UIImage imageNamed:@"ic_right_arrow"]];
        
        [ivRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(8, 15));
        }];
    }
    return self;
}
@end

@interface CustomTaskAddViewController ()<TaskObserver,UITextFieldDelegate,UITextViewDelegate>
{
    UIView *titleView;
    UITextField *tfTitle;
    EditDateControl *timeControl;
    UITextView *txView;
    UIButton *saveButton;
    
    SelectAppointmentTimeView *testTimeView;
    UserScheduleInfo *userSchedule;
    BOOL isEdit;
}
@end

@implementation CustomTaskAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"编辑"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self initWithSubViews];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[UserScheduleInfo class]])
    {
        userSchedule = (UserScheduleInfo *)self.paramObject;
        
        [self setuserScheduleInfo:userSchedule];
        isEdit = YES;
    }
    
}

- (void)setuserScheduleInfo:(UserScheduleInfo *)info
{
    if (info)
    {
        [tfTitle setText:info.scheduleTitle];
        [timeControl.lbTime setText:info.beginTime];
        [txView setText:info.scheduleCon];
    }

}

- (void)initWithSubViews
{
    titleView = [[UIView alloc] init];
    [self.view addSubview:titleView];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    tfTitle = [[UITextField alloc] init];
    [titleView addSubview:tfTitle];
    [tfTitle setDelegate:self];
    [tfTitle setPlaceholder:@"请输入标题"];
    
    timeControl = [[EditDateControl alloc] init];
    [self.view addSubview:timeControl];
    [timeControl addTarget:self action:@selector(timeControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    txView = [[UITextView alloc] init];
    [self.view addSubview:txView];
    [txView setDelegate:self];
    [txView setBackgroundColor:[UIColor whiteColor]];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor mainThemeColor]];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [saveButton.layer setCornerRadius:2.5];
    [saveButton.layer setMasksToBounds:YES];
    
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewsLayout];
}

- (void)subViewsLayout
{
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [tfTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.equalTo(titleView).with.offset(10);
        make.right.equalTo(titleView.mas_right);
    }];
    
    [timeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeControl.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(240);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(50);
    }];
}

- (void)timeControlClick
{
    [self.view endEditing:YES];
    
    testTimeView = [[SelectAppointmentTimeView alloc] init];
    [testTimeView setBackgroundColor:[UIColor mainThemeColor]];
    [self.view addSubview:testTimeView];
    
    __weak EditDateControl* weakControl = timeControl;
    testTimeView.testTimeBlock = ^(NSString *testTime){
        [weakControl.lbTime setText:testTime];
    };
    
    [testTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-260);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(260);
    }];
}

- (void)saveButtonClick
{
    NSString* sTitle = tfTitle.text;
    NSString* sDate = timeControl.lbTime.text;
    NSString* sContent = txView.text;
    
    if (!sTitle || sTitle.length <= 0) {
        [self.view showAlertMessage:@"请输入标题"];
        return;
    }
    if ([sDate isEqualToString:@"请选择日期"])
    {
        [self.view showAlertMessage:@"请选择日期"];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    [dicPost setValue:sTitle forKey:@"scheduleTitle"];
    [dicPost setValue:sDate forKey:@"beginTime"];
    [dicPost setValue:sContent forKey:@"scheduleCon"];
    
    if (isEdit)
    {
        [dicPost setValue:userSchedule.scheduleId forKey:@"scheduleId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"updateUserScheduleTask" taskParam:dicPost TaskObserver:self];
    }else
    {
        StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"userId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"addUserScheduleTask" taskParam:dicPost TaskObserver:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
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
    
    if ([taskname isEqualToString:@"addUserScheduleTask"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([taskname isEqualToString:@"updateUserScheduleTask"])
    {
        [self.view showAlertMessage:@"更新成功！"];
        //[self.navigationController popViewControllerAnimated:YES];
        [HMViewControllerManager createViewControllerWithControllerName:@"CustomTaskViewController" ControllerObject:nil];
    }
}

@end
