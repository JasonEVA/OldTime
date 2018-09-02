//
//  SearchUserViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SearchUserViewController.h"
#import <Masonry/Masonry.h>
#import <MintcodeIM/MintcodeIM.h>
#import "SearchListTableViewCell.h"
#import "FriendValidationViewController.h"
#import "ContactGetUserInformationRequest.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ContactPersonDetailInformationModel.h"
#import "SelectContactTabbarView.h"
@interface SearchUserViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate,SearchListTableViewCellDelegate,BaseRequestDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UISearchDisplayController * searchVC;


@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) ContactGetUserInformationRequest * request ;

@property (nonatomic, weak) SelectContactTabbarView *tabbar;

@end

@implementation SearchUserViewController

- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchTableView];
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.navigationItem setTitleView:self.searchBar];
    [self.searchBar becomeFirstResponder];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];
}

- (void)dealloc {
    [self.tabbar removeObserver:self forKeyPath:@"arraycount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self.searchTableView reloadData];
}

- (void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - SearchListTableViewCellDelegate
- (void)SearchListTableViewCell_SelectButtonClick:(NSIndexPath *)indexPath
{
    MessageRelationInfoModel * model = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                 model.relationName, personDetail_show_id,
                                 model.nickName, personDetail_u_true_name,
                                 model.relationAvatar, personDetail_headPic,
                                 nil];
    //搜索的数据是本地的，所以直接跳到聊天里面
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MessageRelationInfoModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [self getUserInforequestWithuserShowID:model.relationName];
}

- (void)getUserInforequestWithuserShowID:(NSString *)userShowID
{
    if (_request) {
        return;
    }
    _request = [[ContactGetUserInformationRequest alloc] initWithDelegate:self];
    [_request userShowID:userShowID];
    [self postLoading];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageRelationInfoModel * model = [self.dataArray objectAtIndex:indexPath.row];
    static NSString * str =@"cell";
    SearchListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[SearchListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.path = indexPath;
    [cell setCellData:model serchText:self.searchBar.text];;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60; };

#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString * str = searchBar.text;
//    if (str.length > 0) {
//        __weak typeof(self)weakSelf = self;
//        [[MessageManager share] searchRelationUserWithRelationValue:str completion:^(NSArray *array, BOOL success) {
//            weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
//            [weakSelf.searchTableView reloadData];
//        }];
//        
//    }
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString * str = searchBar.text;
    [self.dataArray removeAllObjects];
	
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[MessageManager share] queryRelationInfoWithNickName:str remark:str]];
    self.dataArray = array;
    [self.searchTableView reloadData];
}


#pragma mark- initUI
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        [_searchBar setPlaceholder:@"                                                                          "];
        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_searchBar setDelegate:self];
        [_searchBar setBarTintColor:[UIColor blackColor]];
    }
    return _searchBar;
}
- (UISearchDisplayController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchVC.delegate = self;
        _searchVC.searchResultsDataSource = self;
        _searchVC.searchResultsDelegate = self;
    }
    return _searchVC;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    return _searchTableView;
}
@end
