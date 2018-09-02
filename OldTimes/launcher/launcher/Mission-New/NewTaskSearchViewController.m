//
//  NewTaskSearchViewController.m
//  launcher
//
//  Created by TabLiu on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewTaskSearchViewController.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "NewGetTaskListRequest.h"
#import "NewMissionListTableViewCell.h"
#import "TaskListModel.h"
#import "NewDetailMissionViewController.h"

@interface NewTaskSearchViewController ()<UISearchBarDelegate,BaseRequestDelegate,UITableViewDataSource,UITableViewDelegate,NewMissionListTableViewCellDelegate>

@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) NSArray * nameDataArray;

@end

@implementation NewTaskSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitleView:self.searchBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];
    [self.searchBar becomeFirstResponder];
    [self.navigationItem hidesBackButton];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchRequest:searchBar.text];
}

- (void)searchRequest:(NSString *)text
{
    NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
    request.Type = @0;
    request.time = 0;
    request.projectId = @"";
    request.statusType = @"";
    request.searchKey = text;
    [request search];
    [self postLoading];
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewGetTaskListRequest class]]) {
        
        NewGetTaskListResponse * resp = (NewGetTaskListResponse *)response;
        self.dataArray = [NSArray arrayWithArray:resp.pastArray];
        self.nameDataArray = [NSArray arrayWithArray:resp.dataArray];
        [self.tableView reloadData];
    }
    [self hideLoading];
}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postLoading:errorMessage];
}


- (void)cellClickWithModel:(NSIndexPath *)indexPath
{
    TaskListModel * model;
    if (indexPath.section == 0) {
        model = [self.nameDataArray objectAtIndex:indexPath.row];
    }else {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    if (model.level == 1) {
        NewDetailMissionViewController *vc = [[NewDetailMissionViewController alloc] initWithMissionDetailModel:model];
        vc.isFirstVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NewDetailMissionViewController *vc = [[NewDetailMissionViewController alloc] initWithSubMission:model.showId];
        vc.isFirstVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma amrk - NewMissionListTableViewCellDelegate
- (void)NewMissionListTableViewCell_CompleteButtonClick:(NSIndexPath *)path
{
    [self cellClickWithModel:path];
}
- (void)NewMissionListTableViewCell_SwitchButtonClick:(NSIndexPath *)path
{
    [self cellClickWithModel:path];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    [self cellClickWithModel:indexPath];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nameDataArray.count;
    }else {
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    TaskListModel * model;
    if (indexPath.section == 0) {
        model = [self.nameDataArray objectAtIndex:indexPath.row];
    }else {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    NewMissionListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[NewMissionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setButtonDelegate:self];
    }
    [cell setNeedShowHeadImg:YES];
    [cell setPath:indexPath];
    [cell setCellData:model];
    [cell setSearchText:_searchBar.text];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 30;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor grayBackground];
    
    UILabel * label = [[UILabel alloc] init];
    NSString * searchStr = _searchBar.text;
    if (searchStr && ![searchStr isEqualToString:@""]) {
        NSString * str;
        if (section == 0) {
            str = [NSString stringWithFormat:LOCAL(NEWTASK_CONTANTWORDSINTASK), searchStr];
        }else {
            str = [NSString stringWithFormat:LOCAL(NEWTASK_CONTANTATTENDARINTASK),searchStr];
        }
        label.attributedText = [self text:str searchText:searchStr];
    }
    label.frame = CGRectMake(20, 0, IOS_SCREEN_WIDTH - 40, 30);
    [view addSubview:label];
    return view;
}
// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

#pragma mark - UI
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        [_searchBar setPlaceholder:@"                                                                          "];
        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_searchBar setDelegate:self];
        [_searchBar setBarTintColor:[UIColor blackColor]];
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSArray *)nameDataArray
{
    if (!_nameDataArray) {
        _nameDataArray = [NSArray array];
    }
    return _nameDataArray;
}

@end
