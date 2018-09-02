//
//  SchedulesDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SchedulesDetailViewController.h"
#import "UserScheduleInfo.h"

@interface SchedulesDetailViewController ()<TaskObserver>
{
    UIButton *editButton;

    NSDictionary *dicTemp;
    
    UIView  *scheduleView;
    UILabel *lbScheduleTitle;
    UILabel *lbTime;
    UILabel *lbScheduleContent;
    
    UserScheduleInfo *scheduleInfo;
}
@end

@implementation SchedulesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"日程详情"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* deleteItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    [self.navigationItem setRightBarButtonItem:deleteItem];
    
    [self initWithSubViews];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[UserScheduleInfo class]])
    {
        scheduleInfo = (UserScheduleInfo *)self.paramObject;
        
        [self setuserScheduleInfo];
    }
}

- (void)setuserScheduleInfo
{
    [lbScheduleTitle setText:scheduleInfo.scheduleTitle];
    [lbTime setText:scheduleInfo.beginTime];
    [lbScheduleContent setText:scheduleInfo.scheduleCon];
    
    [lbScheduleContent mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo([lbScheduleContent.text heightSystemFont:lbScheduleContent.font width:kScreenWidth-25]+5);
    }];

}

- (void)initWithSubViews
{
    scheduleView = [[UIView alloc] init];
    [self.view addSubview:scheduleView];
    [scheduleView setBackgroundColor:[UIColor whiteColor]];
    lbScheduleTitle = [[UILabel alloc] init];
    [scheduleView addSubview:lbScheduleTitle];
    [lbScheduleTitle setTextColor:[UIColor commonTextColor]];
    [lbScheduleTitle setFont:[UIFont systemFontOfSize:20]];
    
    lbTime = [[UILabel alloc] init];
    [scheduleView addSubview:lbTime];
    [lbTime setTextColor:[UIColor commonGrayTextColor]];
    [lbTime setFont:[UIFont systemFontOfSize:16]];
    
    lbScheduleContent = [[UILabel alloc] init];
    [self.view addSubview:lbScheduleContent];
    [lbScheduleContent setTextColor:[UIColor commonGrayTextColor]];
    [lbScheduleContent setFont:[UIFont systemFontOfSize:16]];
    [lbScheduleContent setNumberOfLines:0];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:editButton];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setBackgroundColor:[UIColor mainThemeColor]];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [editButton.layer setCornerRadius:5.0f];
    [editButton.layer setMasksToBounds:YES];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewsLayout];

}

- (void)subViewsLayout
{
    [scheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(95);
    }];
    
    [lbScheduleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scheduleView).with.offset(12.5);
        make.top.equalTo(scheduleView).with.offset(20);
        make.right.equalTo(scheduleView);
        make.height.mas_equalTo(20);
    }];
    
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scheduleView).with.offset(12.5);
        make.top.equalTo(lbScheduleTitle.mas_bottom).with.offset(15);
        make.right.equalTo(scheduleView);
        make.height.mas_equalTo(20);
    }];
    
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view.mas_bottom).with.offset(-100);
        make.height.mas_equalTo(50);
    }];
    
    [lbScheduleContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(scheduleView.mas_bottom).with.offset(15);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(5);
    }];
}

- (void)editButtonClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"CustomTaskAddViewController" ControllerObject:scheduleInfo];
}

- (void)deleteBtnClick
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:scheduleInfo.scheduleId forKey:@"scheduleId"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"deleteUserScheduleTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([taskname isEqualToString:@"deleteUserScheduleTask"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
