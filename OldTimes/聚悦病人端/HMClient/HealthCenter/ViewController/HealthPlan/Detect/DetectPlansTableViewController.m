//
//  DetectPlansTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectPlansTableViewController.h"
#import "DetectPlansTableViewCell.h"
#import "SurveyPlanInfo.h"

@interface DetectPlansStartViewController ()
{
    DetectPlansTableViewController* tvcDetectPlan;
}
@end

@implementation DetectPlansStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    tvcDetectPlan = [[DetectPlansTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcDetectPlan];
    [self.view addSubview:tvcDetectPlan.tableView];
    
    [tvcDetectPlan.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(5);
    }];
}

@end

@interface DetectPlansTableViewController ()<TaskObserver>
{
    NSArray* detectPlanItem;
}
@end

@implementation DetectPlansTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectPlanListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detectPlanItem.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
    DetectHealthPlanInfo *detectInfo = [detectPlanItem objectAtIndex:indexPath.row];
    DetectPlansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetectPlansTableViewCell"];
    
    if (!cell)
    {
        cell = [[DetectPlansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetectPlansTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setDetctPlansInfo:detectInfo];
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
    
    if ([taskname isEqualToString:@"DetectPlanListTask"])
    {
        detectPlanItem = (NSArray *)taskResult;
        
        [self.tableView reloadData];
    }
}
@end
