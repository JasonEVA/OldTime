//
//  MissionTypeListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionTypeListViewController.h"
#import "MissionTypeListAdapter.h"
#import "TaskTypeTitleAndCountModel.h"
#import "GetTaskTypeCountsTask.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import "NewMissionGroupModel.h"
#import "GetStaffTeamsTask.h"
#import "ServiceGroupTeamInfoModel.h"
@interface MissionTypeListViewController ()<ATTableViewAdapterDelegate,UISearchBarDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MissionTypeListAdapter *adapter;
@end

@implementation MissionTypeListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getStaffList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"清单"];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self.navigationItem setRightBarButtonItem:addBar];
    [self.view addSubview:self.tableView];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//获取所有团队信息（服务端原因，不得不先请求所有团队信息，望优化）
- (void)getStaffList {
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    
    NSDictionary *dictParam = @{
                                @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                                @"hasOwn" : @"1"
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetStaffTeamsTask class]) taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
    
}
// 请求任务类型标题和count
- (void)requestTaskTitleAndCountWithTeamIDs:(NSString *)teamIDs {
    
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"userId" : [NSString stringWithFormat:@"%ld",(long)info.userId],
                           @"teamIds":teamIDs
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetTaskTypeCountsTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

#pragma mark - event Response
- (void)addClick
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－协同任务－清单－新建任务"];
    [[ATModuleInteractor sharedInstance] goToAddNewMissionVC];
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
//    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.view endEditing:YES];
    return YES;
}
#pragma mark - UITableViewDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if ([cellData isKindOfClass:[TaskTypeTitleAndCountModel class]]) {
        [[ATModuleInteractor sharedInstance] goToNewMissionMainListVCWithModel:cellData];
    }
    else if ([cellData isKindOfClass:[NewMissionGroupModel class]]) {
        [[ATModuleInteractor sharedInstance] goToMissionMainListWithTeamModel:cellData];
    }
    
}
#pragma mark - request Delegate
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    
    [self at_hideLoading];
    [self.view closeWaitView];
    [self showAlertMessage:errorMessage];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:NSStringFromClass([GetTaskTypeCountsTask class])]) {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            //数据删选，只显示要的tabInd,按显示顺序排列
            NSArray *orderArr = @[@6,@2,@4,@5,@3];
            for (int i = 0; i < orderArr.count; i++) {
                for (TaskTypeTitleAndCountModel *model in taskResult[0]) {
                    if (model.tabInd == [orderArr[i] integerValue]) {
                        [tempArr addObject:model];
                    }
                }
            }
            self.adapter.adapterArray = [@[tempArr,taskResult[1]] mutableCopy];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([GetStaffTeamsTask class])])
    {
        NSMutableArray *tempTeamIDs = [NSMutableArray array];
        
        for (ServiceGroupTeamInfoModel *model in taskResult) {
            [tempTeamIDs addObject:[NSString stringWithFormat:@"%ld",(long)model.teamId]];
        }
        NSString *teamIds = [tempTeamIDs componentsJoinedByString:@","];
        [self requestTaskTitleAndCountWithTeamIDs:teamIds];
    }
        [self.tableView reloadData];
}


#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.estimatedRowHeight = 60;
        UISearchBar *searchBar = [UISearchBar new];
        searchBar.placeholder = @"搜索";
        [searchBar setDelegate:self];
        [searchBar sizeToFit];
        [searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
//        [_tableView setTableHeaderView:searchBar];

    }
    return _tableView;
}

- (MissionTypeListAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [MissionTypeListAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        _adapter.adapterArray = [@[@[[TaskTypeTitleAndCountModel new]],@[[TaskTypeTitleAndCountModel new],[TaskTypeTitleAndCountModel new],[TaskTypeTitleAndCountModel new],[TaskTypeTitleAndCountModel new]]] mutableCopy];
    }
    return _adapter;
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
