//
//  CoordinationSearchResultViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationSearchResultViewController.h"
#import "CoordinationSearchResultAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ChatSearchResultViewController.h"
#import "NewPatientListInfoModel.h"
#import "PatientListTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"
#import "ChatIMConfigure.h"
#import "DAOFactory.h"

@interface CoordinationSearchResultViewController ()<ATTableViewAdapterDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UISearchBar  *searchBar;
@property (nonatomic, strong)  CoordinationSearchResultAdapter  *adapter; // <##>
@property (nonatomic, strong)  NSMutableArray<NewPatientListInfoModel *>  *allPatients; // <##>

@end

@implementation CoordinationSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    [self configElements];
    [self.navigationItem setTitleView:self.searchBar];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clanceClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    if (self.adapter.searchText.length > 0) {
        self.searchBar.text = self.adapter.searchText;
    }
    else {
        [self.searchBar becomeFirstResponder];
    }
    if (self.searchType == searchType_searchPatients || self.searchType == searchType_searchPatientChatAndPatients) {
        // 请求病人列表
        [self.allPatients addObjectsFromArray:self.adapter.adapterArray.firstObject];
        [self requestPatientsList];
    }
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

#pragma mark - Private Method

- (void)clanceClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
// 设置元素控件
- (void)configElements {
    
    [self.view addSubview:self.tableView];
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestPatientsList {
    [self.view showWaitView];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:NO removeDuplicateWithId:@"userId" CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view closeWaitView];
        
        if (success) {
            [strongSelf.allPatients removeAllObjects];
            [strongSelf.allPatients addObjectsFromArray:results];
        }
        else {
            [strongSelf showAlertMessage:errorMsg];
        }
    }];
}

// 搜索工作组聊天和联系人
- (void)p_searchCoodinationChatMessageAndContactsWithSearchText:(NSString *)searchText {
    NSMutableArray *allMessageArr = [NSMutableArray arrayWithArray:[[MessageManager share] querySearchMessageListWithKeyword:self.searchBar.text]];
    //筛选掉病患消息
    for (MessageBaseModel *model in allMessageArr) {
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] querySessionDataWithUid:model._target completion:^(ContactDetailModel *contactModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([contactModel._tag isEqualToString:im_doctorPatientGroupTag]) {
                [allMessageArr removeObject:model];
            }
            if (allMessageArr.count > 3) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[allMessageArr subarrayWithRange:NSMakeRange(0, 3)]];
                moreModel *moreM = [moreModel new];
                moreM.contentStr = @"查看更多聊天记录";
                [tempArr addObject:moreM];
                [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:tempArr];
            }
            else {
                [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:allMessageArr];
            }
            strongSelf.adapter.chatList = allMessageArr;
            [strongSelf.tableView reloadData];
        }];
    }
    [self.adapter.adapterArray replaceObjectAtIndex:1 withObject:@[]];
    //搜索好友信息
    NSMutableArray *contactArr = [NSMutableArray arrayWithArray:[[MessageManager share] queryRelationInfoWithNickName:searchText remark:searchText]];
    self.adapter.contactList = contactArr;
    if (contactArr.count > 3) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[contactArr subarrayWithRange:NSMakeRange(0, 3)]];
        moreModel *moreM = [moreModel new];
        moreM.contentStr = @"查看更多联系人";
        [tempArr addObject:moreM];
        [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:tempArr];
    }
    else {
        [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:contactArr];
    }
    self.adapter.searchText = searchText;
    [self.tableView reloadData];
}

// 搜索工作组聊天记录
- (void)p_searchCoordinationChatMessageWithSearchText:(NSString *)searchText {
    NSMutableArray *allMessageArr = [NSMutableArray arrayWithArray:[[MessageManager share] querySearchMessageListWithKeyword:self.searchBar.text]];
    //筛选掉病患消息
    for (MessageBaseModel *model in allMessageArr) {
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] querySessionDataWithUid:model._target completion:^(ContactDetailModel *contactModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([contactModel._tag isEqualToString:im_doctorPatientGroupTag]) {
                [allMessageArr removeObject:model];
            }
            [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:allMessageArr];
            strongSelf.adapter.searchText = searchText;
            [strongSelf.tableView reloadData];
        }];
    }
    [self.adapter.adapterArray replaceObjectAtIndex:1 withObject:@[]];
    [self.tableView reloadData];
}

// 搜索工作组联系人
- (void)p_searchCoordinationContactsWithSearchText:(NSString *)searchText {
    NSMutableArray *contactArr = [NSMutableArray arrayWithArray:[[MessageManager share] queryRelationInfoWithNickName:searchText remark:searchText]];
    [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:contactArr];
    self.adapter.searchText = searchText;
    [self.tableView reloadData];
}

// 搜索病人聊天记录
- (void)p_searchPatientsChatMessageWithSearchText:(NSString *)searchText {
    NSMutableArray *allMessageArr = [NSMutableArray arrayWithArray:[[MessageManager share] querySearchMessageListWithKeyword:self.searchBar.text]];
    //筛选出病患消息
    NSMutableArray *tempArr = [NSMutableArray array];
    for (MessageBaseModel *model in allMessageArr) {
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] querySessionDataWithUid:model._target completion:^(ContactDetailModel *contactModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([contactModel._tag isEqualToString:im_doctorPatientGroupTag]) {
                [tempArr addObject:model];
            }
            [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:tempArr];
            strongSelf.adapter.searchText = searchText;
            [strongSelf.tableView reloadData];
        }];
    }
    [self.adapter.adapterArray replaceObjectAtIndex:1 withObject:@[]];
    [self.tableView reloadData];
}

// 搜索病人和病人聊天记录
- (void)p_searchPatientsAndPatientChatMessageWithSearchText:(NSString *)searchText {
    NSMutableArray *allMessageArr = [NSMutableArray arrayWithArray:[[MessageManager share] querySearchMessageListWithKeyword:self.searchBar.text]];
    //筛选掉病患消息
    for (MessageBaseModel *model in allMessageArr) {
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] querySessionDataWithUid:model._target completion:^(ContactDetailModel *contactModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (![contactModel._tag isEqualToString:im_doctorPatientGroupTag]) {
                [allMessageArr removeObject:model];
            }
            if (allMessageArr.count > 3) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[allMessageArr subarrayWithRange:NSMakeRange(0, 3)]];
                moreModel *moreM = [moreModel new];
                moreM.contentStr = @"查看更多聊天记录";
                [tempArr addObject:moreM];
                [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:tempArr];
            }
            else {
                [strongSelf.adapter.adapterArray replaceObjectAtIndex:1 withObject:allMessageArr];
            }
            strongSelf.adapter.chatList = allMessageArr;
            [strongSelf.tableView reloadData];
        }];
    }
    [self.adapter.adapterArray replaceObjectAtIndex:1 withObject:@[]];
    //搜索病人信息
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName CONTAINS %@",searchText];
    NSArray<NewPatientListInfoModel *> *filteredPatients = [self.allPatients filteredArrayUsingPredicate:predicate];
    self.adapter.contactList = [filteredPatients mutableCopy];
    if (filteredPatients.count > 3) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[filteredPatients subarrayWithRange:NSMakeRange(0, 3)]];
        moreModel *moreM = [moreModel new];
        moreM.contentStr = @"查看更多用户";
        [tempArr addObject:moreM];
        [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:tempArr];
    }
    else {
        [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:filteredPatients];
    }
    self.adapter.searchText = searchText;
    [self.tableView reloadData];

}

- (void)p_searchPatientsWithSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName CONTAINS %@",searchText];
    NSArray<NewPatientListInfoModel *> *filteredPatients = [self.allPatients filteredArrayUsingPredicate:predicate];
    [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:filteredPatients];
    self.adapter.searchText = searchText;
    [self.tableView reloadData];
}
#pragma mark - Event Response

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        switch (self.searchType) {
            case searchType_searchAll: {
                //聊天和联系人都搜（工作组）
                [self p_searchCoodinationChatMessageAndContactsWithSearchText:searchText];
                break;
            }
            case searchType_onlySearchChat: {
                //只搜工作组聊天记录
                [self p_searchCoordinationChatMessageWithSearchText:searchText];
                break;
            }
            case searchType_onlySearchContact: {
                //只搜工作组联系人
                [self p_searchCoordinationContactsWithSearchText:searchText];
                break;
            }
            case searchType_onlySearchPatientChat: {
                //只搜病患聊天记录
                [self p_searchPatientsChatMessageWithSearchText:searchText];
                break;
            }
            case searchType_searchPatientChatAndPatients: {
                // 搜索病人和病人聊天
                [self p_searchPatientsAndPatientChatMessageWithSearchText:searchText];
                break;
            }
            case searchType_searchPatients: {
                // 搜索病人
                [self p_searchPatientsWithSearchText:searchText];
            }
        }
    }
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"无搜索结果" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"icon_searchEmpty"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if ((!self.adapter.adapterArray[0] ||[self.adapter.adapterArray[0] count] == 0) && (!self.adapter.adapterArray[1] ||[self.adapter.adapterArray[1] count] == 0)) {
        return YES;
    }
    return NO;
}


#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    if (indexPath.section) {
        if ([cellData isKindOfClass:[moreModel class]]) {
            //点击更多聊天记录
            CoordinationSearchResultViewController *subVC = [CoordinationSearchResultViewController new];
            subVC.adapter.adapterArray = [@[@[],self.adapter.chatList] mutableCopy];
            subVC.adapter.searchText = self.adapter.searchText;
            [subVC setSearchType:searchType_onlySearchChat];
            [self.navigationController pushViewController:subVC animated:YES];
        }
        else {
            //点击聊天记录
            ChatSearchResultViewController *searchResultVC = [[ChatSearchResultViewController alloc] init];
            MessageBaseModel *model = (MessageBaseModel *)cellData;
            searchResultVC.IsGroup = [ContactDetailModel isGroupWithTarget:model._target];
            // if (self.isquerySearch) {
            [searchResultVC setStrUid:model._target];
            UserProfileModel *userModel = [[MessageManager share] queryContactProfileWithUid:model._target];
            // }
            //        else
            //        {
            //            [searchResultVC setStrUid:self.uidStr];
            //            self.userModel = [[MessageManager share] queryContactProfileWithUid:self.uidStr];
            //
            //
            //        }
            [searchResultVC setStrName:userModel.nickName];
            searchResultVC.sqlId = model._sqlId;
            searchResultVC.msgid = model._msgId;
            [self.navigationController pushViewController:searchResultVC animated:YES];
        }
       
    }
    else {
        if ([cellData isKindOfClass:[moreModel class]]) {
            //点击更多联系人
            [self.searchBar resignFirstResponder];
            CoordinationSearchResultViewController *subVC = [CoordinationSearchResultViewController new];
            [subVC setSearchType:self.searchType == searchType_searchPatientChatAndPatients ? searchType_searchPatients : searchType_onlySearchContact];
            subVC.adapter.adapterArray = [@[self.adapter.contactList,@[]] mutableCopy];
            subVC.adapter.contactList = self.adapter.contactList;
            subVC.adapter.searchText = self.adapter.searchText;
            [self.navigationController pushViewController:subVC animated:YES];
        }
        else {
            if (self.searchType == searchType_searchPatientChatAndPatients || self.searchType == searchType_searchPatients) {
                if ([cellData isKindOfClass:[NewPatientListInfoModel class]]) {
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        PatientInfo *JWModel = [cellData convertToPatientInfo];
                        
                        [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)JWModel.userId]];
                    }];
                }
            }
            else {
                //点击联系人
                MessageRelationInfoModel *model = (MessageRelationInfoModel *)cellData;
                ContactDetailModel *tempModel = [[ContactDetailModel alloc]init];
                tempModel._target = model.relationName;
                tempModel._nickName = model.nickName;
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    [[ATModuleInteractor sharedInstance] goSingleChatVCWith:tempModel chatType:IMChatTypeWorkGroup];
                }];
            }

        }
        
    }
}

#pragma mark - Override

#pragma mark - Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[ContactDoctorInfoTableViewCell class] forCellReuseIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defultCell"];
        [_tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:[PatientListTableViewCell at_identifier]];

    }
    return _tableView;
}

- (CoordinationSearchResultAdapter *)adapter {
    if (!_adapter) {
        _adapter = [CoordinationSearchResultAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.adapterArray = [@[@[],@[]] mutableCopy];
        if (self.searchType == searchType_searchPatients || self.searchType == searchType_searchPatientChatAndPatients) {
            _adapter.headerTitles = @[@"用户",@"聊天记录"];
        }
        else {
            _adapter.headerTitles = @[@"联系人",@"聊天记录"];
        }
    }
    return _adapter;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.placeholder = @"搜索";
        [_searchBar setDelegate:self];
        [_searchBar sizeToFit];
        [_searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];

    }
    return _searchBar;
}

- (NSMutableArray<NewPatientListInfoModel *> *)allPatients {
    if (!_allPatients) {
        _allPatients = [NSMutableArray array];
    }
    return _allPatients;
}
@end
@implementation moreModel
@end
