//
//  NewApplySearchV2ViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplySearchV2ViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "Images.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "ApplyDetailInformationModel.h"
#import "ApplyGetReceiveListModel.h"
#import "NewApplyGetApproveListV2Request.h"
#import "NewApplyAllEventTableViewCell.h"
#import "ApplyGetReceiveListModel.h"
#import "NewApplyDetailV2ViewController.h"
#import "NSString+HandleEmoji.h"
typedef NS_ENUM(NSUInteger, DisplaySectionType) {
	DisplaySectionTitleType						= 0,
	DisplaySectionNameType						= 1,
};

@interface NewApplySearchV2ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSArray *containTitleModels;
@property (nonatomic, strong) NSArray *containNameModels;

@end

@implementation NewApplySearchV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    [self.navigationItem setTitleView:self.mySearchBar];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [cancel setTintColor:[UIColor themeBlue]];
    [self.navigationItem setRightBarButtonItem:cancel];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfiladChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.mySearchBar becomeFirstResponder];
    
    [self initConstraints];
}






- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	if (self.mySearchBar.text.length) {
		[self fetchApplyModelsWithSearchText:self.mySearchBar.text];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mySearchBar endEditing:YES];
}

#pragma mark - Private Method
- (void)fetchApplyModelsWithSearchText:(NSString *)key {
	NewApplyGetApproveListV2Request *request = [[NewApplyGetApproveListV2Request alloc] initWithDelegate:self];
	[request listWithKeyword:key];
	[self postLoading];
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
    
    if ([searchText isIncludingEmoji]) {
        
        //禁用emoji
		searchBar.text = [searchBar.text stringByRemovingEmoji];
        return ;
    }
    
    if (searchBar.text.length != 0) {
		[self fetchApplyModelsWithSearchText:searchText];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length != 0) {
        NewApplyGetApproveListV2Request *request = [[NewApplyGetApproveListV2Request alloc] initWithDelegate:self];
        [request listWithKeyword:searchBar.text];
        
        [self postLoading];
    }
    [self.mySearchBar resignFirstResponder];
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * str = [[UIApplication sharedApplication].delegate.window.textInputMode primaryLanguage];
    if (!str) {
        return NO;
    }
    
    return YES;
}



#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewApplyGetApproveListV2Request class]]) {
        self.arrData = [(id)response modelLists];
		NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"SELF.A_TITLE contains[c] %@", self.mySearchBar.text];
		self.containTitleModels = [self.arrData filteredArrayUsingPredicate:titlePredicate];
		
		NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.A_APPROVE_NAME contains[c] %@", self.mySearchBar.text];
		self.containNameModels = [self.arrData filteredArrayUsingPredicate:namePredicate];
    }
    
    [self hideLoading];
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
	switch (section) {
		case DisplaySectionTitleType:
			return self.containTitleModels.count;
		case DisplaySectionNameType:
			return self.containNameModels.count;
		default:
			return self.arrData.count;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	if (self.mySearchBar.text.length == 0) {
		return nil;
	}
	
	UIView *headerView = [UIView new];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
	titleLabel.font = [UIFont mtc_font_24];
	titleLabel.textColor = [UIColor mtc_colorWithHex:0x666666];
	
	NSString *headerTitle = section == 0 ? [NSString stringWithFormat:LOCAL(APPLY_SEARCH_CONTAIN_TITLE), self.mySearchBar.text] : [NSString stringWithFormat:LOCAL(APPLY_SEARCH_CONTAIN_NAME), self.mySearchBar.text];
	titleLabel.text = headerTitle;
	[headerView addSubview:titleLabel];
	headerView.backgroundColor = [UIColor whiteColor];	
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return self.mySearchBar.text.length == 0 ? 0.01 : 30;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger section = indexPath.section;
	NSUInteger row = indexPath.row;
	
    static NSString* ApplyAcceptTableViewCellUndealID = @"NewApplyAllEventTableViewCellID";
	
    NewApplyAllEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellUndealID];
    if (!cell)
    {
        cell = [[NewApplyAllEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellUndealID];
    }
	
	ApplyGetReceiveListModel *model = nil;
	switch (section) {
		case DisplaySectionTitleType:
			model = self.containTitleModels[row];
			break;
		case DisplaySectionNameType:
			model = self.containNameModels[row];
			break;
	}
	
	[cell setmodel:model];
	
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger section = indexPath.section;
	NSUInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ApplyGetReceiveListModel *model = nil;
	switch (section) {
		case DisplaySectionTitleType:
			model = self.containTitleModels[row];
			break;
		case DisplaySectionNameType:
			model = self.containNameModels[row];
			break;
	}
	
    NewApplyDetailV2ViewController *vc = [[NewApplyDetailV2ViewController alloc] initWithShowID:model.SHOW_ID];
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

- (NSArray *)arrData {
    if (!_arrData) _arrData = [NSArray array];
    return _arrData;
}
@end
