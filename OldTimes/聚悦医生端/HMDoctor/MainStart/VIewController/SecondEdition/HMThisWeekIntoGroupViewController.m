//
//  HMThisWeekIntoGroupViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThisWeekIntoGroupViewController.h"
#import "PatientListTableViewCell.h"
#import "NewPatientListInfoModel.h"
#import "ATModuleInteractor+PatientChat.h"

@interface HMThisWeekIntoGroupViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong) UILabel *headViewLb;
@end

@implementation HMThisWeekIntoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"本周入组"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self startGetThisWeekPatientListRequest];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startGetThisWeekPatientListRequest {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)curStaff.staffId] forKey:@"staffId"];
    [dict setObject:@(0) forKey:@"startRow"];
    [dict setObject:@(1000) forKey:@"rows"];
    [self at_postLoading];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetThisWeekInGroupRequest" taskParam:dict TaskObserver:self];

}
#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"本周还没有用户入组哦" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"g"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientListTableViewCell at_identifier]];
    [cell configCellDataWithNewPatientListInfoModel:self.dataList[indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewPatientListInfoModel *model = self.dataList[indexPath.row];
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",model.userId]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    [back setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [back addSubview:self.headViewLb];
    [self.headViewLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(back);
        make.left.equalTo(back).offset(15);
    }];
    return back;
}


#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
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
    if (!taskname || 0 == taskname.length) {
        return;
    }
    [self at_hideLoading];
    
    if ([taskname isEqualToString:@"HMGetThisWeekInGroupRequest"]) {
        NSDictionary *dict = (NSDictionary *)taskResult;
        self.dataList = [NewPatientListInfoModel mj_objectArrayWithKeyValuesArray:dict[@"list"]];
        NSDate *start = [NSDate dateWithString:dict[@"startDate"] formatString:@"yyyy-MM-dd"];
        NSDate *end = [NSDate dateWithString:dict[@"endDate"] formatString:@"yyyy-MM-dd"];
        
        [self.headViewLb setText:[NSString stringWithFormat:@"入组时间：%@-%@",[start formattedDateWithFormat:@"MM-dd"],[end formattedDateWithFormat:@"MM-dd"]]];
        [self.tableView reloadData];
    }
    
}


#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:135/2];
        [_tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:[PatientListTableViewCell at_identifier]];
    }
    return _tableView;
}

- (UILabel *)headViewLb {
    if (!_headViewLb) {
        _headViewLb = [[UILabel alloc] init];
        [_headViewLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_headViewLb setText:@"入组时间：8.12-8.19"];
        [_headViewLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _headViewLb;
}

@end

