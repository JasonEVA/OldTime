//
//  DepartmentDetailViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//  部门详情页

#import "DepartmentDetailViewController.h"
#import "AddFriendSearchResultsController.h"
#import "NewAddFriendsAdpter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "DepartmentAdapter.h"
#import "CoordinationDepartmentModel.h"
#import "DoctorSearchResultsModel.h"
#import "DoctorCompletionInfoModel.h"
#import "DoctorSearchTask.h"

@interface DepartmentDetailViewController()<UISearchResultsUpdating,ATTableViewAdapterDelegate,TaskObserver>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  AddFriendSearchResultsController  *resultVC; // <##>
@property (nonatomic, strong)  DepartmentAdapter  *adapter; // <##>
@property (nonatomic, strong)  DoctorSearchResultsModel  *resultModel; // <##>
@end
@implementation DepartmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.navigationItem setTitle:self.deptModel.depName];
    self.definesPresentationContext = YES;
    
    [self configElements];
    
}

#pragma mark -private method


// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];

}

// 设置数据
- (void)configData {
    
    NSDictionary *dictParam = @{
                                @"depId" : [NSString stringWithFormat:@"%ld",self.deptModel.depId]
                                };

    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([DoctorSearchTask class]) taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
}

// cell 点击
- (void)cellClickedWithData:(id)cellData {
    if ([cellData isKindOfClass:[DoctorCompletionInfoModel class]]) {
        DoctorCompletionInfoModel *model = (DoctorCompletionInfoModel *)cellData;
        UserInfo *userInfo = [UserInfoHelper defaultHelper].currentUserInfo;
        if (model.userId == userInfo.userId) {
            [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_none model:cellData];
        }
        else {
            MessageRelationInfoModel *relationModel = [[MessageManager share] queryRelationInfoWithUserID:[NSString stringWithFormat:@"%ld",model.userId]];
            if (relationModel) {
                [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_friend model:cellData];
            }
            else {
                [[ATModuleInteractor sharedInstance] goAddFriendsSubVCWith:cellData];
            }
            
        }
    }

}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"-------------->updating");
    if (searchController.searchBar.text.length > 0) {
        AddFriendSearchResultsController *VC = (AddFriendSearchResultsController *)searchController.searchResultsController;
        __weak typeof(self) weakSelf = self;
        [VC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [searchController.searchBar resignFirstResponder];
            [strongSelf cellClickedWithData:resultData];
        }];
    }

}
#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    [self cellClickedWithData:cellData];
}

#pragma mark - TaskObserver

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
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
    
    if ([taskname isEqualToString:NSStringFromClass([DoctorSearchTask class])])
    {
        if ([taskResult isKindOfClass:[DoctorSearchResultsModel class]]) {
            self.resultModel = taskResult;
            self.adapter.adapterArray = [self.resultModel.list mutableCopy];
            [self.tableView reloadData];
        }
    }
}
#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.placeholder = @"输入姓名或电话号码";
        [_searchVC.searchBar sizeToFit];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        [_searchVC.searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];


    }
    return _searchVC;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[ContactDoctorInfoTableViewCell class] forCellReuseIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
        [_tableView setTableHeaderView:self.searchVC.searchBar];
    }
    return _tableView;
}

- (AddFriendSearchResultsController *)resultVC {
    if (!_resultVC) {
        _resultVC = [AddFriendSearchResultsController new];
    }
    return _resultVC;
}
- (DepartmentAdapter *)adapter {
    if (!_adapter) {
        _adapter = [DepartmentAdapter new];
        _adapter.adapterDelegate = self;
    }
    return _adapter;
}

@end
