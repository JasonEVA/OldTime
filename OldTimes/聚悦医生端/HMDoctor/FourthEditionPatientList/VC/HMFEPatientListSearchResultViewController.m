//
//  HMFEPatientListSearchResultViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFEPatientListSearchResultViewController.h"
#import "PatientInfo.h"
#import "NewPatientListInfoModel.h"

#import "PatientListTableViewCell.h"
#import "HMNewPatientSelectTableViewCell.h"
#import "SearchEmptyAdapter.h"
#import "DAOFactory.h"
#import "ATModuleInteractor+PatientChat.h"

@interface HMFEPatientListSearchResultViewController ()<UISearchBarDelegate>
@property (nonatomic, copy)  NSArray  *arraySourceData; // <##>

@property (nonatomic, copy)  NSArray  *arrayResultData; // <##>

@property (nonatomic, copy)  SearchResultClicked  resultClicked; // <##>

@property (nonatomic) BOOL isSelect;  //是否为选人模式

@property (nonatomic, strong)  SearchEmptyAdapter  *searchEmptyAdapter; // 无搜索结果adapter
@property (nonatomic, strong)  UISearchBar  *searchBar;

@end

@implementation HMFEPatientListSearchResultViewController

- (instancetype)initWithSelectPatientVC {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.isSelect = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setTitleView:self.searchBar];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clanceClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.searchBar becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self.tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
    [self.tableView registerClass:[HMNewPatientSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class])];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self.searchEmptyAdapter;
    self.tableView.emptyDataSetDelegate = self.searchEmptyAdapter;
    [self requestSinglePatientsListImmediately:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) patientIsSelected:(PatientInfo*) patient
{
    if (!self.selectedPatientArr)
    {
        return NO;
    }
    for (id selPatient in self.selectedPatientArr)
    {
        if ([selPatient userId] == patient.userId)
        {
            return YES;
        }
    }
    return NO;
}

// 请求全部患者(去重)
- (void)requestSinglePatientsListImmediately:(BOOL)immediately {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:immediately removeDuplicateWithId:@"userId" CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:errorMsg];
            return;
        }
        [strongSelf at_hideLoading];
        [strongSelf configWithSourceData:results];
    }];
}
- (void)clanceClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Interface Method

- (void)configWithSourceData:(NSArray *)arrayData {
    self.arraySourceData = arrayData;
}
//
- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked {
//    self.resultClicked = clicked;
//    if (!self.arraySourceData || keywords.length == 0) {
//        return;
//    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName CONTAINS[c] %@",keywords];
//    self.arrayResultData = [self.arraySourceData filteredArrayUsingPredicate:predicate];
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayResultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelect) {
        HMNewPatientSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class]) forIndexPath:indexPath];
        id patient = self.arrayResultData[indexPath.row];
        [cell setIsSelected:[self patientIsSelected:patient]];
        if ([patient isKindOfClass:[PatientInfo class]]) {
            [cell setPatientInfo:patient];
        }
        else if ([patient isKindOfClass:[NewPatientListInfoModel class]]) {
            [cell configCellDataWithNewPatientListInfoModel:patient];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    else {
        PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListTableViewCell class]) forIndexPath:indexPath];
        id patient = self.arrayResultData[indexPath.row];
        if ([patient isKindOfClass:[PatientInfo class]]) {
            [cell setPatientInfo:patient];
        }
        else if ([patient isKindOfClass:[NewPatientListInfoModel class]]) {
            [cell configCellDataWithNewPatientListInfoModel:patient];
        }
        // 搜索结果不显示金额
        [cell.orderMoney setHidden:YES];
        return cell;
        
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *keywords = searchText;
    
    if (!self.arraySourceData || keywords.length == 0) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName CONTAINS[c] %@",keywords];
    self.arrayResultData = [self.arraySourceData filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
    
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSelect) {
        
        PatientInfo * patient = self.arrayResultData[indexPath.row];
        if ([self patientIsSelected:patient])
        {
            __weak typeof(self) weakSelf = self;
            [self.selectedPatientArr enumerateObjectsUsingBlock:^(PatientInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (obj.userId == patient.userId) {
                    [strongSelf.selectedPatientArr removeObject:obj];
                    
                }
            }];
        }
        else
        {
            if (self.selectedPatientArr.count >= self.maxSelectedNum) {
                [self.view showAlertMessage:[NSString stringWithFormat:@"选择人数不可超过%ld人",self.maxSelectedNum]];
                return;
            }
            [self.selectedPatientArr addObject:patient];
        }
        
        [self.tableView reloadData];
        
        self.resultClicked(patient);
        
    }
    else {
        PatientInfo * patient = self.arrayResultData[indexPath.row];
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)patient.userId]];
        }];
        
    }
    
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

- (SearchEmptyAdapter *)searchEmptyAdapter {
    if (!_searchEmptyAdapter) {
        _searchEmptyAdapter = [SearchEmptyAdapter new];
        _searchEmptyAdapter.displayEmptyView = YES;
    }
    return _searchEmptyAdapter;
}

@end
