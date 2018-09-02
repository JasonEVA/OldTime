//
//  NewApplySearchViewController.m
//  launcher
//
//  Created by conanma on 16/1/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplySearchViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "Images.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "ApplyDetailInformationModel.h"
#import "ApplyGetReceiveListModel.h"
#import "ApplySearchRequest.h"
#import "NewApplyAllEventTableViewCell.h"
#import "ApplyGetReceiveListModel.h"
#import "NewApplyDetailViewController.h"
#warning "The File Code is never used , Please use NewApplySearchV2ViewController instead"
@interface NewApplySearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) NSMutableArray *arrData;
@end

@implementation NewApplySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    [self.navigationItem setTitleView:self.mySearchBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];

    [self.mySearchBar becomeFirstResponder];
    
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mySearchBar endEditing:YES];
}

#pragma mark - Event Response
- (void)cancelClick
{
    [self.mySearchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.mySearchBar endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initConstraints
{
    [self.myTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length != 0) {
        ApplySearchRequest *request = [[ApplySearchRequest alloc] initWithDelegate:self];
        [request GetKeyWord:searchBar.text];
        
        [self postLoading];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length != 0) {
        ApplySearchRequest *request = [[ApplySearchRequest alloc] initWithDelegate:self];
        [request GetKeyWord:searchBar.text];
        
        [self postLoading];
    }
    [self.mySearchBar resignFirstResponder];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self.arrData removeAllObjects];
    
    if ([response isKindOfClass:[ApplySearchResponse class]])
    {
        for (NSInteger i = 0; i<((ApplySearchResponse *)response).arrResultApproveList.count; i++)
        {
            ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:[((ApplySearchResponse *)response).arrResultApproveList objectAtIndex:i]];
            [self.arrData addObject:model];
        }
    }
    [self postSuccess];
    [self.myTableView reloadData];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}



#pragma mark - UIScrollViewDelegate
//当有搜索内容的时候滚动视图隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.arrData.count > 0) {
        [self.mySearchBar resignFirstResponder];
    }
}

#pragma mark - tableViewDeledgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ApplyAcceptTableViewCellUndealID = @"NewApplyAllEventTableViewCellID";
    
    ApplyGetReceiveListModel *model = [self.arrData objectAtIndex:indexPath.row];
    
    NewApplyAllEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellUndealID];
    if (!cell)
    {
        cell = [[NewApplyAllEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellUndealID];
    }
    [cell setmodel:model];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplyGetReceiveListModel *model = [self.arrData objectAtIndex:indexPath.row];
    NewApplyDetailViewController *vc = [[NewApplyDetailViewController alloc] initWithShowID:model.SHOW_ID];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - InIt UI
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_myTableView setDataSource:self];
        [_myTableView setDelegate:self];
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
//        [_myTableView registerClass:[ContactBookNameTableViewCell class] forCellReuseIdentifier:[ContactBookNameTableViewCell identifier]];
        if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_myTableView setTableFooterView: [[UIView alloc]init]];
        [_myTableView setBackgroundColor:[UIColor grayBackground]];
    }
    return _myTableView;
}

- (UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        [_mySearchBar setPlaceholder:@""];
        [_mySearchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_mySearchBar setDelegate:self];
        [_mySearchBar setBarTintColor:[UIColor blackColor]];
        
        
    }
    return _mySearchBar;
}

- (NSMutableArray *)arrData
{
    if (!_arrData)
    {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}
@end
