//
//  HMNewPatientSelectViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMNewPatientSelectViewController.h"
#import "HMNewPatientSelectTableViewCell.h"
#import "PatientSearchResultTableViewController.h"

@interface HMNewPatientSelectViewController ()<UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@end
@implementation HMNewPatientSelectViewController
- (void)viewDidLoad {
    _selectedPatients = [NSMutableArray array];
    [self.tableView setTableHeaderView:self.searchVC.searchBar];
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写父类数据源刷新方法，筛选掉历史分组
- (void)patientGroupLoaded:(NSArray *)groups {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:@[]];
    [self.groupArr enumerateObjectsUsingBlock:^(PatientGroupInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.teamId == 0) {
            [tempArr addObject:obj];
        }
    }];
    [self.groupArr removeObjectsInArray:tempArr];
    [super patientGroupLoaded:self.groupArr];
}
#pragma mark - Table view data source
- (NSString*) cellClassName
{
    NSString* classname = @"HMNewPatientSelectTableViewCell";
    return classname;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMNewPatientSelectTableViewCell* cell = (HMNewPatientSelectTableViewCell*) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    PatientInfo* patient = [self patientInfoWithIndex:indexPath];
    [cell setIsSelected:[self patientIsSelected:patient]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientInfo* patient = [self patientInfoWithIndex:indexPath];
    if ([self patientIsSelected:patient])
    {
        [_selectedPatients removeObject:patient];
    }
    else
    {
        [_selectedPatients addObject:patient];
    }
    
    [self.tableView reloadData];
    
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(HMNewPatientSelectViewControllerDelegateCallBack_selectedPatientChanged)])
    {
        [_selectDelegate HMNewPatientSelectViewControllerDelegateCallBack_selectedPatientChanged];
    }
}

- (BOOL) patientIsSelected:(PatientInfo*) patient
{
    if (!_selectedPatients)
    {
        return NO;
    }
    for (PatientInfo* selPatient in _selectedPatients)
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
    [self.groupArr enumerateObjectsUsingBlock:^(PatientGroupInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //筛选掉历史分组
        if (obj.teamId != 0) {
            [array addObjectsFromArray:obj.users];
        }
    }];
    [self.resultVC configWithSourceData:array];
    self.resultVC.selectedPatientArr = self.selectedPatients;

    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        __weak typeof(self) weakSelf = self;

        [self.resultVC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            [searchController.searchBar resignFirstResponder];
            
            [strongSelf setSelectedPatients:strongSelf.resultVC.selectedPatientArr];
            
            [strongSelf.tableView reloadData];
            
            if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(HMNewPatientSelectViewControllerDelegateCallBack_selectedPatientChanged)])
            {
                [_selectDelegate HMNewPatientSelectViewControllerDelegateCallBack_selectedPatientChanged];
            }


        }];
    }
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

- (PatientSearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[PatientSearchResultTableViewController alloc] initWithSelectPatientVC];
    }
    return _resultVC;
}


@end
