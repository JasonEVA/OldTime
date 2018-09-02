//
//  ChatSearchMoreViewController.m
//  launcher
//
//  Created by Lars Chen on 16/1/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatSearchMoreViewController.h"
#import <Masonry.h>
#import "ContactBookNameTableViewCell.h"
#import "ContactBookDeptTableViewCell.h"
#import "UIColor+Hex.h"
#import "ContactBookGetUserListRequest.h"
#import "MyDefine.h"
#import "ChatSingleViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import <MJRefresh.h>
#import "UIFont+Util.h"
#import "ContactBookDetailViewController.h"
#import "ContactBookGetDeptListRequest.h"
#import "ContactBookDeptmentViewController.h"

@interface ChatSearchMoreViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BaseRequestDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic) SearchResultType myType;

@end

@implementation ChatSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitleView:self.searchBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];
    
    if (self.tabbar) {
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44);
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }

    [self initComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithSearchType:(SearchResultType)type SearchText:(NSString *)searchText
{
    if (self = [super init])
    {
        self.myType = type;
        
        self.pageIndex = 1;
        
        self.searchBar.text = searchText;
        
        [self getContactList];
    }
    
    return self;
}

#pragma mark - Event Response
- (void)cancelClick
{
    [self.searchBar endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //   [self.searchTableView reloadData];
    [self.tableView reloadData];
}

- (void)initComponent
{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)getContactList
{
    switch (self.myType) {
        case SearchResultType_department:
        {
            //获取部门列表
            ContactBookGetDeptListRequest *request = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
            request.pageIndex = self.pageIndex;
            request.pageSize = 10;
            [request getCompanyDeptWithSearchKey:self.searchBar.text];
        }
            break;
        case searchResultType_contact:
        {
            //获取用户列表请求
            ContactBookGetUserListRequest *request = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
            request.pageIndex = self.pageIndex;
            request.pageSize = 10;
            [request getUserWithSearchKey:self.searchBar.text];
        }
            break;
        default:
            break;
    }
    }

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.arrData.count > 0)
    {
        return 30;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myType == SearchResultType_department) {
        return [ContactBookDeptTableViewCell height];
    } else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor whiteColor]];
    if (self.arrData.count > 0)
    {
        UILabel *lbHead = [UILabel new];
        [lbHead setBackgroundColor:[UIColor whiteColor]];
        [lbHead setTextColor:[UIColor themeGray]];
        [lbHead setFont:[UIFont mtc_font_26]];
        if (self.myType == searchResultType_contact) {
            [lbHead setText:LOCAL(SEARCH_CONTACT)];
        } else {
            [lbHead setText:LOCAL(SEARCH_DEPARTMENT)];
        }
        
        [view addSubview:lbHead];
        [lbHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0,14,0,0));
        }];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    id modelForShow = self.arrData[indexPath.row];
    switch (self.myType) {
        case searchResultType_contact:
        {
           cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
            [cell setDataWithModel:modelForShow selectMode:self.tabbar];
            [cell setSearchText:self.searchBar.text];
            if (self.tabbar) {
                [cell setIsMission:self.tabbar.isMission];
                BOOL selected = [self.tabbar.dictSelected objectForKey:[modelForShow show_id]];
                BOOL unableSelected = [self.tabbar.dictUnableSelected objectForKey:[modelForShow show_id]];
                [cell setSelect:selected unableSelect:unableSelected selfSelectable:self.selfSelectable];
            }

        }
            break;
        case SearchResultType_department:
        {
           cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookDeptTableViewCell identifier]];
            [cell setDataWithDeptModel:modelForShow];
            [cell setSearchText:self.searchBar.text];
        }
            break;
        default:
            break;
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.myType) {
        case searchResultType_contact:
        {
            ContactPersonDetailInformationModel *clickedModel = self.arrData[indexPath.row];
            if (self.tabbar) {
                [self.tabbar addOrDeletePerson:clickedModel];
                [self.tableView reloadData];

            } else {
                
                if (self.isShowPersonalInformation) {
                    ContactPersonDetailInformationModel *model = self.arrData[indexPath.row];
                    ContactBookDetailViewController *VC  = [[ContactBookDetailViewController alloc] initWithUserModel:model];
                    [self.navigationController pushViewController:VC animated:YES];
                } else {
                    ContactPersonDetailInformationModel *infoModel = self.arrData[indexPath.row];
                    
                    ContactDetailModel *model = [[ContactDetailModel alloc] init];
                    model._target   = infoModel.show_id;
                    model._nickName = infoModel.u_true_name;
                    
                    ChatSingleViewController *singleVC = [[ChatSingleViewController alloc] initWithDetailModel:model];
                    [self.navigationController pushViewController:singleVC animated:YES];
                }

            }
            
        }
            break;
        case SearchResultType_department:
        {
            
            // 点击部门
            ContactDepartmentImformationModel *clickedModel = self.arrData[indexPath.row];
            ContactBookDeptmentViewController *VC = [[ContactBookDeptmentViewController alloc] initWithCurrentDeptment:clickedModel tabbar:self.tabbar];
            [self.navigationController pushViewController:VC animated:YES];

            if (self.tabbar) {
                __weak typeof(self) weakSelf = self;
                [VC reloadData:^{
                    [weakSelf.tableView reloadData];
                }];
            }
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length != 0) {
        self.pageIndex = 1;
        
        self.tableView.footer.state = MJRefreshStateIdle;
        
        [self getContactList];

        [self postLoading];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[ContactBookGetUserListRequest class]]) {
        NSArray *arrContacts = ((ContactBookGetUserListResponce *)response).modelArr;
        if (self.pageIndex == 1)
        {
            self.arrData = [arrContacts mutableCopy];
        }
        else
        {
            [self.arrData addObjectsFromArray:arrContacts];
        }
        
        self.pageIndex ++;
        [self hideLoading];
        [self.tableView.footer endRefreshing];
        if (arrContacts.count == 0)
        {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
    } else if ([request isKindOfClass:[ContactBookGetDeptListRequest class]])
    {
        NSArray *arrContacts = ((ContactBookGetDeptListResponse *)response).arrResult;
        if (self.pageIndex == 1)
        {
            self.arrData = [arrContacts mutableCopy];
        }
        else
        {
            [self.arrData addObjectsFromArray:arrContacts];
        }
        
        self.pageIndex ++;
        [self hideLoading];
        [self.tableView.footer endRefreshing];
        if (arrContacts.count == 0)
        {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    [self.tableView.footer endRefreshing];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [_tabbar removeObserver:self forKeyPath:@"arraycount"];
}
#pragma mark - Init UI
- (UITableView *)tableView
{
    if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    [_tableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_tableView setTableFooterView: [[UIView alloc]init]];
    [_tableView setBackgroundColor:[UIColor grayBackground]];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getContactList)];
    _tableView.footer = footer;
    footer.stateLabel.hidden = YES;
}
    return _tableView;
    
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [UISearchBar new];
        [_searchBar setPlaceholder:@"                                                                          "];
        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_searchBar setDelegate:self];
        [_searchBar setBarTintColor:[UIColor blackColor]];
    }
    
    return _searchBar;
}

- (NSMutableArray *)arrData
{
    if (!_arrData)
    {
        _arrData = [NSMutableArray array];
    }
    
    return _arrData;
}

@end
