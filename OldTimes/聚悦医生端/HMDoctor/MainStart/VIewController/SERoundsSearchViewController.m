//
//  SERoundsSearchViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SERoundsSearchViewController.h"
#import "CoordinationSearchResultAdapter.h"
#import "NewPatientListInfoModel.h"
#import "PatientListTableViewCell.h"
#import "DAOFactory.h"
#import "SESomeOneAllRoundsViewController.h"

@interface SERoundsSearchViewController ()<ATTableViewAdapterDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UISearchBar  *searchBar;
@property (nonatomic, strong)  CoordinationSearchResultAdapter  *adapter; // <##>
@property (nonatomic, strong)  NSMutableArray<NewPatientListInfoModel *>  *allPatients; // <##>
@end

@implementation SERoundsSearchViewController

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
    
    // 请求病人列表
    [self.allPatients addObjectsFromArray:self.adapter.adapterArray.firstObject];
    [self requestPatientsList];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"f5f5f7"]];
    [self.navigationController.navigationBar setTitleTextAttributes:nil];
    self.navigationController.navigationBar.tintColor = [UIColor mainThemeColor];
    [self.navigationController.navigationBar setTranslucent:NO];

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
    [_DAO.patientInfoListDAO requestPatientListImmediately:NO CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
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
    // 搜索病人
    [self p_searchPatientsWithSearchText:searchText];
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
    NewPatientListInfoModel *model = self.adapter.adapterArray[0][indexPath.row];
    
    SESomeOneAllRoundsViewController *VC = [[SESomeOneAllRoundsViewController alloc] initWithUserName:model.userName userId:[NSString stringWithFormat:@"%ld",(long)model.userId]];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Override

#pragma mark - Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;

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
       
        _adapter.headerTitles = @[@"用户",@"聊天记录"];
        
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
