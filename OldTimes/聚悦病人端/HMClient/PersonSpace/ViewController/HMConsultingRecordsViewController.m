//
//  HMConsultingRecordsViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMConsultingRecordsViewController.h"
#import "HMConsultingRecordsModel.h"
#import "HMConsultingrecordsTableViewCell.h"
#import "HMStaffNavTitleHistoryChatViewController.h"
#import "HMClientGroupChatModel.h"

@interface HMConsultingRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation HMConsultingRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"咨询记录"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self startGroupListRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
}

- (void)startGroupListRequest {
    UserInfo *userInfo = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%ld",userInfo.userId] forKey:@"userId"];
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMFindUserServiceRecordTimeRequest" taskParam:dict TaskObserver:self];

}


#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMConsultingRecordsModel *model = self.dataList[indexPath.row];
    HMConsultingrecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMConsultingrecordsTableViewCell at_identifier]];
    [cell fillDataWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMConsultingRecordsModel *model = self.dataList[indexPath.row];
    HMStaffNavTitleHistoryChatViewController *VC = [[HMStaffNavTitleHistoryChatViewController alloc] initWithHMConsultingRecordsModel:model];
    
    [self.navigationController pushViewController:VC animated:YES];
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
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMFindUserServiceRecordTimeRequest"]) {
        
        self.dataList = taskResult;
        [self.tableView reloadData];
    }
}
#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无记录" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_l"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
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
        [_tableView setRowHeight:90];
        [_tableView registerClass:[HMConsultingrecordsTableViewCell class] forCellReuseIdentifier:[HMConsultingrecordsTableViewCell at_identifier]];
    }
    return _tableView;
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
