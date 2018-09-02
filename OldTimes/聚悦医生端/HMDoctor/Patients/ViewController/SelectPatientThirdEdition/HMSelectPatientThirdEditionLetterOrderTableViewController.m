//
//  HMSelectPatientThirdEditionLetterOrderTableViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientThirdEditionLetterOrderTableViewController.h"
#import "PatientInfo.h"
#import "HMNewPatientSelectTableViewCell.h"
#import "PatientSearchResultTableViewController.h"
#import "NewPatientListInfoModel.h"
@interface HMSelectPatientThirdEditionLetterOrderTableViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic, strong)  NSMutableArray<NSArray *>  *arraySectionData; // <##>
@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayIndexTitles; // <##>
@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  NSMutableArray *dataList;
@end

@implementation HMSelectPatientThirdEditionLetterOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _letterSelectedPatients = [NSMutableArray array];
    [self.tableView setTableHeaderView:self.searchVC.searchBar];

    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self.tableView registerClass:[HMNewPatientSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class])];
    self.tableView.rowHeight = 60;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

- (void)configPatientsData:(NSArray<NewPatientListInfoModel *> *)patients {
    [self p_configOrderDataWithSourceData:patients];
    self.dataList = [NSMutableArray arrayWithArray:patients];
}

- (void)reloadLetterVCWithArray:(NSMutableArray *)array {
    self.letterSelectedPatients = array;
    [self.tableView reloadData];
    self.resultVC.selectedPatientArr = array;
    [self.resultVC.tableView reloadData];
}

- (void)hideSearchVC {
    if (self.searchVC.active) {
        self.searchVC.active = NO;
    }
}
#pragma mark - Private Method

- (BOOL) patientIsSelected:(NewPatientListInfoModel*) patient
{
    if (!_letterSelectedPatients)
    {
        return NO;
    }
    for (NewPatientListInfoModel* selPatient in _letterSelectedPatients)
    {
        if (selPatient.userId == patient.userId)
        {
            return YES;
        }
    }
    return NO;
}

- (void)p_configOrderDataWithSourceData:(NSArray<NewPatientListInfoModel *> *)patients {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    // 得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    // 初始化一个数组newSectionsArray用来存放最终的数据
    NSMutableArray<NSMutableArray *> *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // 初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    // 将每个人按name分到某个section下
    [patients enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 获取name属性的值所在的位置
        NSInteger sectionNumber = [collation sectionForObject:obj collationStringSelector:@selector(userName)];
        // 把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:obj];
        
    }];
    // 对每个section中的数组按照name属性排序,得到有数据的section，和title
    __weak typeof(self) weakSelf = self;
    [newSectionsArray enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:obj collationStringSelector:@selector(userName)];
        if (sortedPersonArrayForSection.count > 0) {
            [strongSelf.arraySectionData addObject:sortedPersonArrayForSection];
            [strongSelf.arrayIndexTitles addObject:collation.sectionTitles[idx]];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arraySectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySectionData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMNewPatientSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class]) forIndexPath:indexPath];

    NewPatientListInfoModel* patient = self.arraySectionData[indexPath.section][indexPath.row];
    [cell setIsSelected:[self patientIsSelected:patient]];
    [cell configCellDataWithNewPatientListInfoModel:patient];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

// Index

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.arrayIndexTitles[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.arrayIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self.resultVC configWithSourceData:self.dataList];
    self.resultVC.maxSelectedNum = self.maxSelectedNum;
    self.resultVC.selectedPatientArr = self.letterSelectedPatients;
    
    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.resultVC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [searchController.searchBar resignFirstResponder];
            
            [strongSelf setLetterSelectedPatients:strongSelf.resultVC.selectedPatientArr];
            [strongSelf.tableView reloadData];
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged)])
            {
                [strongSelf.delegate HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged];
            }
            
            
        }];
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont font_24];
    headerView.textLabel.textColor = [UIColor commonDarkGrayColor_666666];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPatientListInfoModel* patient = self.arraySectionData[indexPath.section][indexPath.row];
    
    if ([self patientIsSelected:patient])
    {
        __weak typeof(self) weakSelf = self;
        [self.letterSelectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (obj.userId == patient.userId) {
                [strongSelf.letterSelectedPatients removeObject:obj];
            }
        }];

        
    }
    else
    {
        if (self.letterSelectedPatients.count >= self.maxSelectedNum) {
            [self.view showAlertMessage:[NSString stringWithFormat:@"选择人数不可超过%ld人",self.maxSelectedNum]];
            return;
        }

        [self.letterSelectedPatients addObject:patient];
    }
    
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged)])
    {
        [self.delegate HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged];
    }
}



#pragma mark - Init

- (NSMutableArray<NSArray *> *)arraySectionData {
    if (!_arraySectionData) {
        _arraySectionData = [NSMutableArray array];
    }
    return _arraySectionData;
}

- (NSMutableArray<NSString *> *)arrayIndexTitles {
    if (!_arrayIndexTitles) {
        _arrayIndexTitles = [NSMutableArray array];
    }
    return _arrayIndexTitles;
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
@end
