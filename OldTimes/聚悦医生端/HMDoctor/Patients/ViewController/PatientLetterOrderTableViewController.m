//
//  PatientLetterOrderTableViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientLetterOrderTableViewController.h"
#import "PatientInfo.h"
#import "PatientListTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"

@interface PatientLetterOrderTableViewController ()

@property (nonatomic, strong)  NSMutableArray<NSArray *>  *arraySectionData; // <##>
@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayIndexTitles; // <##>

@end

@implementation PatientLetterOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self.tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
    self.tableView.rowHeight = 60;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

- (void)configPatientsData:(NSArray<PatientInfo *> *)patients {
    [self p_configOrderDataWithSourceData:patients];
}

#pragma mark - Private Method

- (void)p_configOrderDataWithSourceData:(NSArray<PatientInfo *> *)patients {
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
    [patients enumerateObjectsUsingBlock:^(PatientInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListTableViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setPatientInfo:self.arraySectionData[indexPath.section][indexPath.row]];
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

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont font_24];
    headerView.textLabel.textColor = [UIColor commonDarkGrayColor_666666];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self resignFirstResponder];
    PatientInfo *info = self.arraySectionData[indexPath.section][indexPath.row];
 [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)info.userId]];

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
@end
