//
//  ContactsViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactsViewController.h"
#import "CoordinationFilterView.h"
#import "CoordinationSearchResultViewController.h"
#import "CoordinationContactsAdapter.h"
#import "CoordinationContactsManager.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ContactInfoModel.h"
#import "CoordinationContactTableViewCell.h"
#import "IMMessageHandlingCenter.h"

@interface ContactsViewController()<ATTableViewAdapterDelegate,CoordinationFilterViewDelegate,CoordinationContactsAdapterDelegate,UISearchBarDelegate,MessageManagerDelegate>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
//@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
@property (nonatomic, strong)  CoordinationSearchResultViewController  *resultVC; // <##>
@property (nonatomic, strong)  CoordinationContactsAdapter  *contactAdapter; // <##>
@property (nonatomic, assign)  BOOL  loadingRelationGroup; // <##>
@end
@implementation ContactsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"联系人"];
    self.definesPresentationContext = YES;

    [self configElements];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
    [self p_loadRelationGroupInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除委托
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
}
#pragma mark - private method

- (void)p_loadRelationGroupInfo {
    if (self.loadingRelationGroup) {
        return;
    }
    self.loadingRelationGroup = YES;
    [self configData];
}

- (void)configElements {
    
    UIBarButtonItem *taskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(taskAction)];
    [self.navigationItem setRightBarButtonItem:taskItem];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)configData {
    [self at_postLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray<MessageRelationGroupModel *> *sectionData = [[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:YES];
        __block NSInteger dataCount = 0;
        __weak typeof(self) weakSelf = self;
        [sectionData enumerateObjectsUsingBlock:^(MessageRelationGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[CoordinationContactsManager sharedManager] getContactsWithWithRelationGroup:obj.relationGroupId completion:^(long groupID, NSArray *contacts) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                ++dataCount;
                
                NSMutableArray *arrayContacts = [NSMutableArray arrayWithCapacity:contacts.count];
                for (id cellData in contacts) {
                    ContactInfoModel *model;
                    if ([cellData isKindOfClass:[ContactInfoModel class]]) {
                        model = (ContactInfoModel *)cellData;
                    }
                    else if ([cellData isKindOfClass:[UserProfileModel class]]) {
                        model = [[ContactInfoModel alloc] initWithUserProfileModel:cellData];
                    }
                    else if ([cellData isKindOfClass:[ContactDetailModel class]]) {
                        model = [[ContactInfoModel alloc] initWithContactDetailModel:cellData];
                    }
                    else if ([cellData isKindOfClass:[MessageRelationInfoModel class]]) {
                        model = [[ContactInfoModel alloc] initWithMessageRelationInfoModel:cellData];
                    }
                    else if ([cellData isKindOfClass:[SuperGroupListModel class]]) {
                        model = [[ContactInfoModel alloc] initWithSuperGroupListModel:cellData];
                    }
                    if (model) {
                        [arrayContacts addObject:model];
                    }
                }
                
                if (obj.relationGroupId == groupID) {
                    obj.relationList = arrayContacts;
                }
                else {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationGroupId == %ld",groupID];
                    NSArray<MessageRelationGroupModel *> *temp = [sectionData filteredArrayUsingPredicate:predicate];
                    if (temp.count > 0) {
                        temp.firstObject.relationList = arrayContacts;
                    }
                }
                if (dataCount == sectionData.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.contactAdapter.adapterArray = [sectionData mutableCopy];
                        [strongSelf.tableView reloadData];
                        [strongSelf at_hideLoading];
                        strongSelf.loadingRelationGroup = NO;
                    });
                }
            }];
        }];
    });
}

#pragma mark - event Response
- (void)taskAction {
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }
    
}
#pragma mark - ATTableViewAdapterDelegate

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    TitelType type = (TitelType)tag;
    switch (type) {
        case AddNewFriendType: {
            //
            [[ATModuleInteractor sharedInstance] goAddFriends];
            
            break;
        }
        case CreateWorkCircle: {
            [[ATModuleInteractor sharedInstance] goCreateWorkCircleIsCreate:YES nonSelectableContacts:nil workCircleID:nil];
            
            break;
        }
        case AddNewMissionType: {
            [[ATModuleInteractor sharedInstance] goToAddNewMission];
            break;
        }
    }
    
}
//#pragma mark - UISearchResultUpdating
//
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSLog(@"-------------->updating");
//    
//}

#pragma mark - MessageManagerDelegate

- (void)MessageManagerDelegateCallBack_needRefreshRelationFromSQL {
    [self p_loadRelationGroupInfo];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
    [resultVC setSearchType:searchType_onlySearchContact];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - CoordinationContactsAdapterDelegate

- (void)coordinationContactsAdapterDelegateCallBack_headerLongPressed {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *actionDel = [UIAlertAction actionWithTitle:@"分组管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 分组管理
        
        [[ATModuleInteractor sharedInstance] gofriendsGroupingWithDataList:strongSelf.contactAdapter.adapterArray Edit:YES];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    [alertController addAction:actionDel];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)coordinationContactsAdapterDelegateCallBack_clickedWithCellData:(id)cellData {
    
    ContactInfoModel *model = (ContactInfoModel *)cellData;
    if (!model.isGroup) {
        [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_friend model:model];
    }
    else {
        ContactDetailModel *tempModel = [[ContactDetailModel alloc]init];
        tempModel._target = model.relationInfoModel.relationName;
        tempModel._nickName = model.relationInfoModel.nickName;
        [[ATModuleInteractor sharedInstance] goToGroupChatVCWith:tempModel chatType:IMChatTypeWorkGroup];
    }

}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.contactAdapter;
        _tableView.dataSource = self.contactAdapter;
        _tableView.rowHeight = 60;
        UISearchBar *searchBar = [UISearchBar new];
        searchBar.placeholder = @"搜索";
        [searchBar setDelegate:self];
        [searchBar sizeToFit];
        [searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
        [_tableView setTableHeaderView:searchBar];
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    }
    return _tableView;
}

//- (UISearchController *)searchVC {
//    if (!_searchVC) {
//        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
//        _searchVC.searchResultsUpdater = self;
//        [_searchVC.searchBar sizeToFit];
//        [_searchVC.searchBar setBarTintColor:[UIColor colorWithHexString:@"f0f0f0"]];
//
//    }
//    return _searchVC;
//}
- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_addFriend",@"c_addWorkCircle",@"c_newTask"] titles:@[@"加好友",@"创建工作圈",@"新建任务"] tags:@[@(AddNewFriendType),@(CreateWorkCircle),@(AddNewMissionType)]];
        _filterView.delegate = self;
        
    }
    return _filterView;
}

- (CoordinationSearchResultViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [CoordinationSearchResultViewController new];
    }
    return _resultVC;
}
- (CoordinationContactsAdapter *)contactAdapter {
    if (!_contactAdapter) {
        _contactAdapter = [[CoordinationContactsAdapter alloc] initWithSelectType:ContactsSelectTypeNone selectedContacts:nil nonSelectableContacts:nil];
        _contactAdapter.tableView = self.tableView;
        _contactAdapter.customeDelegate = self;
    }
    return _contactAdapter;
}

@end
