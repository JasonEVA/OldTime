//
//  HMSelectPatientThirdEditionWithTeamViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientThirdEditionWithTeamViewController.h"
#import "HMNewPatientSelectTableViewCell.h"
#import "HMSelectPatientGroupHeaderView.h"
#import "PatientSearchResultTableViewController.h"
#import "NewPatientListInfoModel.h"
#import "NewPatientGroupListInfoModel.h"

@interface HMSelectPatientThirdEditionWithTeamViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>

@end

@implementation HMSelectPatientThirdEditionWithTeamViewController

- (void)viewDidLoad {
//    _selectedPatients = [NSMutableArray array];
    [super viewDidLoad];
    [self.tableView setTableHeaderView:self.searchVC.searchBar];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置数据源
- (void)fillDataWithArray:(NSArray *)groups {
    self.patientGroups = [NSMutableArray arrayWithArray:groups];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:@[]];
    [groups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.teamId == 0) {
            [tempArr addObject:obj];
        }
    }];
    [self.patientGroups removeObjectsInArray:tempArr];
}

- (void)reloadTeamVCWithArray:(NSMutableArray *)array {
    self.selectedPatients = array;
    [self.tableView reloadData];
    self.resultVC.selectedPatientArr = array;
    [self.resultVC.tableView reloadData];
}

- (void)hideSearchVC {
    if (self.searchVC.active) {
        self.searchVC.active = NO;
    }
}

- (NewPatientListInfoModel*) patientInfoWithIndex:(NSIndexPath *)indexPath
{
    NewPatientGroupListInfoModel* group = self.patientGroups[indexPath.section];
    NSArray* patientItems = group.users;
    NewPatientListInfoModel* patientInfo = [patientItems objectAtIndex:indexPath.row];
    return patientInfo;
}

- (NSMutableArray *)acquireUserIdArrWithArr:(NSArray<NewPatientListInfoModel *> *)array {
    NSMutableArray *tempGroup = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempGroup addObject:@(obj.userId)];
    }];
    return tempGroup;
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.patientGroups)
    {
        return self.patientGroups.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NewPatientGroupListInfoModel* group = self.patientGroups[section];
    if (!group.isExpanded)
    {
        return 0;
    }
    
    NSArray* patientItems = group.users;
    if (patientItems)
    {
        return patientItems.count;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [footerview setBackgroundColor:[UIColor commonControlBorderColor]];
    return footerview;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSString*) cellClassName
{
    NSString* classname = @"HMNewPatientSelectTableViewCell";
    return classname;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellClassName = [self cellClassName];
    HMNewPatientSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NewPatientGroupListInfoModel* group = self.patientGroups[indexPath.section];
    
    NSArray* patientItems = group.users;
    [cell configCellDataWithNewPatientListInfoModel:[patientItems objectAtIndex:indexPath.row]];
    
    NewPatientListInfoModel* patient = [self patientInfoWithIndex:indexPath];
    [cell setIsSelected:[self patientIsSelected:patient]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NewPatientListInfoModel* patient = [self patientInfoWithIndex:indexPath];
    NewPatientGroupListInfoModel* group = self.patientGroups[indexPath.section];
    if ([self patientIsSelected:patient])
    {
        [self.selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.userId == patient.userId) {
                [_selectedPatients removeObject:obj];
            }
        }];
        group.isAllSelected = NO;
    }
    else
    {
        if (self.selectedPatients.count >= self.maxSelectedNum) {
            [self.view showAlertMessage:[NSString stringWithFormat:@"选择人数不可超过%ld人",self.maxSelectedNum]];
            return;
        }
        
        [_selectedPatients addObject:patient];
        
        NSSet *selectedSet = [NSSet setWithArray:[self acquireUserIdArrWithArr:_selectedPatients]];
        NSSet *groupSet = [NSSet setWithArray:[self acquireUserIdArrWithArr:group.users]];
        if ([groupSet isSubsetOfSet:selectedSet]) {
            group.isAllSelected = YES;
        }

    }
    
    [self.tableView reloadData];
    
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged)])
    {
        [_selectDelegate HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged];
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HMSelectPatientGroupHeaderView* headerview = [[HMSelectPatientGroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];
    
    
    NewPatientGroupListInfoModel* group = self.patientGroups[section];
    [headerview setGroupName:group.teamName];
    [headerview fillCount:[NSString stringWithFormat:@"%ld",group.users.count]];
    [headerview setTag:section];
    [headerview setIsExpanded:group.isExpanded];
    [headerview setIsSelected:group.isAllSelected];
    [headerview addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    //全选点击回调
    __weak typeof(self) weakSelf = self;

    [headerview allSelectBottonClick:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        group.isAllSelected = !group.isAllSelected;
        [group.users enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (group.isAllSelected) {
                NSMutableArray *tempArr = [NSMutableArray array];
                [_selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *Patientobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tempArr addObject:@(Patientobj.userId)];
                }];

                if (![tempArr containsObject:@(obj.userId)]) {
                    [_selectedPatients addObject:obj];
                }
            }
            else {
                [strongSelf.selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *Patientobjs, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (Patientobjs.userId == obj.userId) {
                        [strongSelf.selectedPatients removeObject:Patientobjs];
                    }
                }];

            }
            
        }];
        [strongSelf.tableView reloadData];
        
        if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged)])
        {
            [_selectDelegate HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged];
        }

    }];
    return headerview;
}

- (void)headerViewClick:(id) sender
{
    if (![sender isKindOfClass:[HMSelectPatientGroupHeaderView class]])
    {
        return;
    }
    HMSelectPatientGroupHeaderView* headerview = (HMSelectPatientGroupHeaderView*)sender;
    NSInteger section = (headerview.tag);
    NewPatientGroupListInfoModel* group = self.patientGroups[section];
    group.isExpanded = !group.isExpanded;
    [self.tableView reloadData];
}




- (BOOL) patientIsSelected:(NewPatientListInfoModel*) patient
{
    if (!_selectedPatients)
    {
        return NO;
    }
    for (NewPatientListInfoModel* selPatient in _selectedPatients)
    {
        if (selPatient.userId == patient.userId)
        {
            return YES;
        }
    }
    return NO;
}
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
        NSMutableArray *array = [NSMutableArray array];
        [self.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //筛选掉历史分组
            if (obj.teamId != 0) {
                [array addObjectsFromArray:obj.users];
            }
        }];
        [self.resultVC configWithSourceData:array];
        self.resultVC.maxSelectedNum = self.maxSelectedNum;
        self.resultVC.selectedPatientArr = self.selectedPatients;
    
        NSLog(@"-------------->%@",[NSThread currentThread]);
        if (searchController.searchBar.text.length > 0) {
    __weak typeof(self) weakSelf = self;
            [self.resultVC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [searchController.searchBar resignFirstResponder];
    
                [strongSelf setSelectedPatients:strongSelf.resultVC.selectedPatientArr];
                [strongSelf.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSSet *groupSet = [NSSet setWithArray:[strongSelf acquireUserIdArrWithArr:obj.users]];
                    NSSet *allSet = [NSSet setWithArray:[strongSelf acquireUserIdArrWithArr:strongSelf.selectedPatients]];
                    obj.isAllSelected = [groupSet isSubsetOfSet:allSet];
                }];

    
                [self.tableView reloadData];
    
                if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged)])
                {
                    [_selectDelegate HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged];
                }
                
                
            }];
        }
}

- (PatientSearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[PatientSearchResultTableViewController alloc] initWithSelectPatientVC];
    }
    return _resultVC;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.searchBar.placeholder = @"输入姓名搜索";
        [_searchVC.searchBar sizeToFit];
        [_searchVC.searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        self.definesPresentationContext = YES;
    }
    return _searchVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
