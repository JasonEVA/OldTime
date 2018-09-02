//
//  PatientSearchResultTableViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientSearchResultTableViewController.h"
#import "PatientInfo.h"
#import "NewPatientListInfoModel.h"

#import "PatientListTableViewCell.h"
#import "HMNewPatientSelectTableViewCell.h"
#import "SearchEmptyAdapter.h"

@interface PatientSearchResultTableViewController ()
@property (nonatomic, copy)  NSArray  *arraySourceData; // <##>

@property (nonatomic, copy)  NSArray  *arrayResultData; // <##>

@property (nonatomic, copy)  SearchResultClicked  resultClicked; // <##>

@property (nonatomic) BOOL isSelect;  //是否为选人模式

@property (nonatomic, strong)  SearchEmptyAdapter  *searchEmptyAdapter; // 无搜索结果adapter

@end

@implementation PatientSearchResultTableViewController

- (instancetype)initWithSelectPatientVC {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.isSelect = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self.tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
    [self.tableView registerClass:[HMNewPatientSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class])];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self.searchEmptyAdapter;
    self.tableView.emptyDataSetDelegate = self.searchEmptyAdapter;

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
#pragma mark - Interface Method

- (void)configWithSourceData:(NSArray *)arrayData {
    self.arraySourceData = arrayData;
}

- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked {
    self.resultClicked = clicked;
    if (!self.arraySourceData || keywords.length == 0) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userName CONTAINS[c] %@",keywords];
    self.arrayResultData = [self.arraySourceData filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
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
        return cell;

    }
    
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
        id info = self.arrayResultData[indexPath.row];
        self.resultClicked(info);
    }
    
}

- (SearchEmptyAdapter *)searchEmptyAdapter {
    if (!_searchEmptyAdapter) {
        _searchEmptyAdapter = [SearchEmptyAdapter new];
        _searchEmptyAdapter.displayEmptyView = YES;
    }
    return _searchEmptyAdapter;
}

@end
