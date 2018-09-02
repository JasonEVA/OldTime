//
//  ContactBookSearchViewController.m
//  launcher
//
//  Created by williamzhang on 15/10/15.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookSearchViewController.h"
#import "ContactBookDeptmentViewController.h"
#import "ContactBookDetailViewController.h"
#import "ContactBookGetDeptListRequest.h"
#import "ContactBookDeptTableViewCell.h"
#import "ContactBookNameTableViewCell.h"

#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ContactBookGetUserListRequest.h"
#import "UIFont+Util.h"
#import "ChatSearchMoreViewController.h"

static NSInteger myPageSize = 10;
@interface ContactBookSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, BaseRequestDelegate>

/** 搜索时的背景 */
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, strong) UIView *placeholderView;

@property (nonatomic, assign) BOOL isSearching;

/** 所有人 */
@property (nonatomic, strong) NSArray *arrayContacts;
@property (nonatomic, readonly) NSArray *arrayDepartments
;

@property (nonatomic, strong) NSMutableArray *arrayDataForShow;

@property (nonatomic, strong) ContactBookGetDeptListRequest *getDepartRequest;
@property (nonatomic, strong) ContactBookGetUserListRequest *getUserListRequest;
@property (nonatomic, copy) NSString *mySearchText;
@property (nonatomic) NSInteger totalCount;
@end

@implementation ContactBookSearchViewController

- (instancetype)init {
    return [self initWithSelectedPeople:nil];
}

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople {
    return [self initWithSelectedPeople:selectedPeople unableSelectPeople:nil];
}

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople unableSelectPeople:(NSArray *)unableSelectPeople {
    self = [super init];
    if (self) {
        [self.getDepartRequest requestData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tabbar)
    {
        [self.tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToSearch)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.isSearching animated:animated];
    [self.searchVC.searchResultsTableView reloadData];
}

-(void)dealloc
{
    if (self.tabbar)
    {
        [self.tabbar removeObserver:self forKeyPath:@"arraycount"];
    }
}

#pragma mark - Private Method
- (void)setCountForModel:(ContactDepartmentImformationModel *)deptModel {
    
    NSInteger count = 0;
    for (ContactDepartmentImformationModel *model in self.arrayDepartments) {
        if ([model.D_PARENTID_SHOW_ID isEqualToString:deptModel.ShowID])
        {
            count ++;
        }
    }
    
    NSMutableDictionary *dictRelateContacts = [NSMutableDictionary dictionary];
    for (ContactPersonDetailInformationModel *userModel in self.arrayContacts) {
        if ([userModel.u_dept_id containsObject:deptModel.ShowID]) {
            count ++;
        }
        
        if ([userModel.d_path_name containsObject:deptModel.D_NAME]) {
            [dictRelateContacts setObject:@1 forKey:userModel.show_id];
        }
    }
    
    deptModel.dictRelateContacts = dictRelateContacts;
    deptModel.subObjCount = count;
}

- (void)handleSearchPlaceholderViewShow:(BOOL)show {
    if (show) {
        [self.view addSubview:self.placeholderView];
        [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(44);
        }];
        return;
    }
    
    [self.placeholderView removeFromSuperview];
    self.placeholderView = nil;
}

/** 搜索结果无数据 */
- (BOOL)noData {
    for (NSArray *array in self.arrayDataForShow) {
        if ([array count]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Interface Method
- (void)reloadData {}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self.searchVC.searchResultsTableView reloadData];
}

#pragma mark - Button Click
- (void)defenseClick {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)clickToSearch
{
    //按钮暴力点击防御
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self performSelector:@selector(defenseClick) withObject:nil afterDelay:0.5];
    [self.view insertSubview:self.searchTableView atIndex:0];

    
    
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(self.tabbar ? -50 : 0);
    }];
    
    [UIView performWithoutAnimation:^{
        self.searchBar.hidden = NO;
        [self.searchVC.searchBar becomeFirstResponder];
    }];
    
    [self handleSearchPlaceholderViewShow:YES];
    self.isSearching = YES;
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isSearching) {
        return 0;
    }
    
    if (tableView == self.searchTableView) {
        return 0;
    }
    
    if ([self noData]) {
        return 0;
    }
    
    return [self.arrayDataForShow count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isSearching) {
        return 0;
    }
    
    NSArray *array = self.arrayDataForShow[section];
    if (array.count < myPageSize) {
        return [array count];
    } else {
        return [array count] + 1;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *showContArr = self.arrayDataForShow[indexPath.section];
    if (indexPath.row == showContArr.count) {
         return 45;
     } else {
         if (!indexPath.section) {
             return [ContactBookNameTableViewCell height];
         }
         return [ContactBookDeptTableViewCell height];
     }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.view.frame) - 15, 44)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@",LOCAL(CONTACTBOOK_INCLUDE), self.searchBar.text, (section ? LOCAL(CONTACTBOOK_DEPARTWORLDS) : LOCAL(CONTACTBOOK_USERNAMEWORLDS))];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
    NSForegroundColorAttributeName:[UIColor colorWithWhite:172.0 / 255.0 alpha:1.0]}];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([LOCAL(CONTACTBOOK_INCLUDE) length] + 1, [self.searchBar text].length)];
    
    [titleLabel setAttributedText:attributeString];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor mtc_colorWithR:227 g:227 b:229]];
    [headerView addSubview:titleLabel];
    [headerView addSubview:line];
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    
    NSInteger row     = indexPath.row;
    NSInteger section = indexPath.section;
	NSArray *showContArr =  self.arrayDataForShow[indexPath.section];
	
    if (row == showContArr.count) {
        
            static NSString *ID = @"lookMoreCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setFont:[UIFont mtc_font_26]];
                [cell.textLabel setTextColor:[UIColor themeBlue]];
            }
            
            NSString *title;
            if (indexPath.section == 0)
            {
                title = @"查看更多联系人";
            } else if (indexPath.section == 1)
            {
                title = @"查看更多部门";
            }
            [cell.textLabel setText:title];
        return cell;
    }
	
	id modelForShow = nil;
	@try {
		modelForShow = [self.arrayDataForShow[section] objectAtIndex:row];
	} @catch (NSException *exception) {
		NSLog(@"%@", exception.name);
		if ([exception.name isEqualToString:@"NSRangeException"]) {
			cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
			return cell;
		}
		
	} @finally {
		
	}
	
   // ContactPersonDetailInformationModel *modelForShow = showContArr[row];
    if (!section) {
        // 人员
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookNameTableViewCell identifier]];
        [cell setDataWithModel:modelForShow selectMode:(self.tabbar != nil)];
        [cell setSearchText:self.searchBar.text];
        if (self.tabbar) {
            [cell setIsMission:self.tabbar.isMission];
            BOOL selected = ([self.tabbar.dictSelected objectForKey:[modelForShow show_id]] != nil);
            BOOL unableSelected = ([self.tabbar.dictUnableSelected objectForKey:[modelForShow show_id]] != nil);
            [cell setSelect:selected unableSelect:unableSelected selfSelectable:self.selfSelectable];
        }
    }
    
    else {
        // 部门
        cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookDeptTableViewCell identifier]];
        
        if (self.tabbar) {
//            // 判断该部门下是否都选中
//            BOOL allSelect = YES;
//            NSArray *arraySelect = [[modelForShow dictRelateContacts] allKeys];
//            if (![arraySelect count] && ![modelForShow isSelect]) {
//                allSelect = NO;
//            }
//            
//            for (NSString *selectedShowId in arraySelect) {
//                if (![self.tabbar.dictSelected valueForKey:selectedShowId]) {
//                    allSelect = NO;
//                    break;
//                }
//            }
//            
//            [modelForShow setIsSelect:allSelect];
        }
        
        [cell setDataWithDeptModel:modelForShow selectMode:NO];
        [cell setSearchText:self.searchBar.text];
        if (self.singleSelectable) {
            [cell isSingleMode];
        }
        
        __weak typeof(self) weakSelf = self;
        [cell clickToSelect:^(id cell) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSIndexPath *clickIndexPath = [strongSelf.searchVC.searchResultsTableView indexPathForCell:cell];
            ContactDepartmentImformationModel *departModel = [strongSelf.arrayDataForShow[clickIndexPath.section] objectAtIndex:clickIndexPath.row];
            departModel.isSelect ^= 1;
            
            //[self.tabbar addOrDeleteDepartment:departModel];
            [strongSelf.searchVC.searchResultsTableView reloadData];
        }];
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        //点击更多部门
        NSArray *array = self.arrayDataForShow[indexPath.section];
        if (array.count == indexPath.row) {
            ChatSearchMoreViewController *VC = [[ChatSearchMoreViewController alloc] initWithSearchType:SearchResultType_department SearchText:self.searchBar.text];
            VC.tabbar = self.tabbar;
            VC.selfSelectable = self.selfSelectable;
            VC.singleSelectable = self.singleSelectable;
            [VC hidesBottomBarWhenPushed];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            // 点击部门
            ContactDepartmentImformationModel *clickedModel = [self.arrayDataForShow[indexPath.section] objectAtIndex:indexPath.row];
            ContactBookDeptmentViewController *VC = [[ContactBookDeptmentViewController alloc] initWithCurrentDeptment:clickedModel tabbar:self.tabbar];
            
            if (self.tabbar) {
                __weak typeof(self) weakSelf = self;
                [VC reloadData:^{
                    [weakSelf.searchVC.searchResultsTableView reloadData];
                }];
            }
            
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];

        }
    }
    
    else {
        //点击更多用户
        NSArray *array = self.arrayDataForShow[indexPath.section];
        if (array.count == indexPath.row) {
            ChatSearchMoreViewController *VC = [[ChatSearchMoreViewController alloc] initWithSearchType:searchResultType_contact SearchText:self.searchBar.text];
            VC.isShowPersonalInformation = YES;
            VC.tabbar = self.tabbar;
            VC.selfSelectable = self.selfSelectable;
            VC.singleSelectable = self.singleSelectable;
            [VC hidesBottomBarWhenPushed];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            // 点击人员
            ContactPersonDetailInformationModel *clickedModel = [self.arrayDataForShow[indexPath.section] objectAtIndex:indexPath.row];
            if (!self.tabbar) {
                ContactBookDetailViewController *VC = [[ContactBookDetailViewController alloc] initWithUserModel:clickedModel];
                
                [VC notifyStartChat:^{
                    // TODO:通讯录跳转到聊天去了处理，能力不足，加事件各种bug BY WILLIAM，看微信是直接在当前VC push出聊天，不是跳转到第一个TabBar
                }];
                
                [VC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:VC animated:NO];
                return;
            }
            
            [self.tabbar addOrDeletePerson:clickedModel];
            
            [self reloadData];
            [self.searchVC.searchResultsTableView reloadData];
            
        }
        
    }
}


#pragma mark - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;

    [UIView performWithoutAnimation:^{
        [self.searchBar resignFirstResponder];
        self.searchBar.hidden = YES;
    }];
    
    [self.arrayDataForShow removeAllObjects];
    [self.searchTableView reloadData];
    [self.searchTableView removeFromSuperview];
    
    [self handleSearchPlaceholderViewShow:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        self.getUserListRequest.pageSize = myPageSize;
        self.getUserListRequest.pageIndex = 1;
        [self.getUserListRequest getUserWithSearchKey:searchText];
        self.mySearchText = searchText;
        [self postLoading];
    }
    [self handleSearchPlaceholderViewShow:![searchText length]];
}

#pragma mark - UISearchDisplayController Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self searchBarCancelButtonClicked:self.searchBar];
}

#pragma mark - BaseRequest Delegate

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self hideLoading];
    [self postError:errorMessage];
}
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    if ([request isKindOfClass:[ContactBookGetDeptListRequest class]]) {
        _arrayDepartments = [(id)response arrResult];
        [self.arrayDataForShow addObject:_arrayDepartments];
        [self.searchVC.searchResultsTableView reloadData];
    } else if ([request isKindOfClass:[ContactBookGetUserListRequest class]]) {
        _arrayContacts = [(id)response modelArr];
        self.getDepartRequest.pageSize = myPageSize;
        self.getDepartRequest.pageIndex = 1;
        [self.getDepartRequest getCompanyDeptWithSearchKey:self.searchBar.text];
        
        [self postLoading];

        self.arrayDataForShow = [NSMutableArray arrayWithObject:_arrayContacts];
        
        
    }
}

#pragma mark - Initializer
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_searchTableView setTableHeaderView:self.searchBar];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        
        [_searchTableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
        [_searchTableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    }
    return _searchTableView;
}

- (UISearchDisplayController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchVC.delegate = self;
        _searchVC.searchResultsDataSource = self;
        _searchVC.searchResultsDelegate = self;
        [_searchVC.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_searchVC.searchResultsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchVC.searchResultsTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_searchVC.searchResultsTableView registerClass:[ContactBookDeptTableViewCell class] forCellReuseIdentifier:[ContactBookDeptTableViewCell identifier]];
        [_searchVC.searchResultsTableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
    }
    return _searchVC;
}

@synthesize arrayDepartments = _arrayDepartments;
- (NSArray *)arrayDepartments {
    if ([self.tabbar.arrayDepartments count]) {
        return self.tabbar.arrayDepartments;
    }
    
    if (![_arrayDepartments count]) {
        _arrayDepartments = @[];
        [self.getDepartRequest requestData];
    }
    
    return _arrayDepartments;
}

- (ContactBookGetDeptListRequest *)getDepartRequest {
    if (!_getDepartRequest) {
        _getDepartRequest = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
    }
    return _getDepartRequest;
}
- (ContactBookGetUserListRequest *)getUserListRequest
{
    if (!_getUserListRequest) {
        _getUserListRequest = [[ContactBookGetUserListRequest alloc] initWithDelegate:self];
    }
    return _getUserListRequest;
}

- (UIView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [UIView new];
        _placeholderView.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
        _placeholderView.userInteractionEnabled = NO;
        
        UILabel *placeholderLabel = [UILabel new];
        placeholderLabel.font = [UIFont systemFontOfSize:20];
        placeholderLabel.textColor = [UIColor mtc_colorWithHex:0x999999];
        placeholderLabel.text = LOCAL(CONTACT_SEARCHTITLE);
        [_placeholderView addSubview:placeholderLabel];
        
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_placeholderView);
            make.centerY.equalTo(_placeholderView).offset(-30);
        }];
        
        UIView *view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor mtc_colorWithR:0 g:0 b:0 alpha:0.3]];
        [_placeholderView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_placeholderView);
        }];
    }
    return _placeholderView;
}

- (NSString *)mySearchText
{
    if (!_mySearchText) {
        _mySearchText = [[NSString alloc]init];
    }
    return _mySearchText;
}
@end
