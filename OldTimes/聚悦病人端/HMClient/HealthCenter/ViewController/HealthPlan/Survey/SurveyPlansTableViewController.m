//
//  SurveyPlansTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyPlansTableViewController.h"
#import "SurveyPlansTableViewCell.h"
#import "SurveyPlanInfo.h"

@implementation SurveyPlansListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"记随访"];
    SurveyPlansTableViewController* tvcDetectPlan = [[SurveyPlansTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcDetectPlan];
    [self.view addSubview:tvcDetectPlan.tableView];
    
    [tvcDetectPlan.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
    }];
}

@end

@interface SurveyPlansStartViewController ()
{
    SurveyPlansTableViewController* tvcDetectPlan;

}
@end

@implementation SurveyPlansStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    tvcDetectPlan = [[SurveyPlansTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcDetectPlan];
    [self.view addSubview:tvcDetectPlan.tableView];
    
    [tvcDetectPlan.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
    }];
}

@end

@interface SurveyPlansTableViewController ()<TaskObserver>
{
    
    NSArray* surveyPlansItem;
}
@end

@implementation SurveyPlansTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //SurveyPlanListTask
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyPlanListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return surveyPlansItem.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyPlanInfo* surveyInfo = [surveyPlansItem objectAtIndex:indexPath.row];
    
    SurveyPlansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyPlansTableViewCell"];
    
    if (!cell)
    {
        cell = [[SurveyPlansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveyPlansTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setSurveyPlanInfo:surveyInfo];
    return cell;
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
    
    if ([taskname isEqualToString:@"SurveyPlanListTask"])
    {
        surveyPlansItem = (NSArray *)taskResult;
        
        [self.tableView reloadData];

    }
}

@end
