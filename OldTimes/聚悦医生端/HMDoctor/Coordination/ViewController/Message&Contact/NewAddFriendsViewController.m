//
//  NewAddFriendsViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewAddFriendsViewController.h"
#import "AddFriendSearchResultsController.h"
#import "NewAddFriendsAdpter.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "GetDepartmentsTask.h"
#import "CoordinationDepartmentModel.h"
#import "DoctorCompletionInfoModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface NewAddFriendsViewController()<UISearchResultsUpdating,ATTableViewAdapterDelegate,TaskObserver>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  AddFriendSearchResultsController  *resultVC; // <##>
@property (nonatomic, strong)  NewAddFriendsAdpter  *adapter; // <##>

@end


@implementation NewAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self.navigationItem setTitle:@"添加好友"];
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
        make.edges.equalTo(self.view);
    }];

}

// 设置数据
- (void)configData {
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;

    NSDictionary *dictParam = @{
                                @"orgId" : [NSString stringWithFormat:@"%ld",info.orgId]
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetDepartmentsTask class]) taskParam:dictParam TaskObserver:self];

}
#pragma mark - event Response


#pragma mark - Delegate
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        AddFriendSearchResultsController *VC = (AddFriendSearchResultsController *)searchController.searchResultsController;
        [VC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            [searchController.searchBar resignFirstResponder];
            if ([resultData isKindOfClass:[DoctorCompletionInfoModel class]]) {
                DoctorCompletionInfoModel *model = (DoctorCompletionInfoModel *)resultData;
                UserInfo *userInfo = [UserInfoHelper defaultHelper].currentUserInfo;
                if (model.userId == userInfo.userId) {
                    [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_none model:resultData];
                }
                else {
                    MessageRelationInfoModel *relationModel = [[MessageManager share] queryRelationInfoWithUserID:[NSString stringWithFormat:@"%ld",model.userId]];
                    if (relationModel) {
                        [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_friend model:resultData];
                    }
                    else {
                        [[ATModuleInteractor sharedInstance] goAddFriendsSubVCWith:resultData];
                    }
                    
                }
            }

        }];
    }
}
#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if ([cellData isKindOfClass:[CoordinationDepartmentModel class]]) {
        CoordinationDepartmentModel *model = (CoordinationDepartmentModel *)cellData;
        [[ATModuleInteractor sharedInstance] goToDeptDetailVCWithDeptModel:model];

    }
    
}

#pragma mark - request Delegate

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    [self at_postError:errorMessage];
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
    
    if ([taskname isEqualToString:NSStringFromClass([GetDepartmentsTask class])])
    {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            self.adapter.adapterArray = taskResult;
            [self.tableView reloadData];
        }
    }
}

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
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setTableHeaderView:self.searchVC.searchBar];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
    }
    return _tableView;
}
- (AddFriendSearchResultsController *)resultVC {
    if (!_resultVC) {
        _resultVC = [AddFriendSearchResultsController new];
    }
    return _resultVC;
}
- (NewAddFriendsAdpter *)adapter {
    if (!_adapter) {
        _adapter = [NewAddFriendsAdpter new];
        _adapter.adapterDelegate = self;
    }
    return _adapter;
}

@end
