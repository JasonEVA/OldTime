//
//  NewPatientListViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewPatientListViewController.h"
#import "PatientListFilterHeaderView.h"
#import "PatientFilterTypeView.h"
#import "PatientListFilterConditionTableViewCell.h"
#import "PatientListFilterConditionAdapter.h"
#import "NewPatientListInfoModel.h"
#import "PatientListLetterOrderAdapter.h"
#import "PatientListTableViewCell.h"
#import "PatientFilterTypeFooterView.h"
#import "PatientListKeyOrderAdapter.h"
#import "PatientSearchResultTableViewController.h"
#import "ATModuleInteractor+PatientChat.h"
#import "ASDatePicker.h"
#import "DateUtil.h"
#import "SearchEmptyAdapter.h"
#import "DAOFactory.h"

typedef NS_ENUM(NSUInteger, PatientListFilterType) {
    PatientListFilterTypeService,
    PatientListFilterTypeTeam,
    PatientListFilterTypeDisease,
    PatientListFilterTypeFilter,
    PatientListFilterTypeMax
};

typedef NS_ENUM(NSUInteger, PatientListSortType) {
    PatientListSortTypeDefault,
    PatientListSortTypeTime,
    PatientListSortTypeFee,
    PatientListSortTypeAlertTimes,
    PatientListSortTypeAge
};

typedef NS_ENUM(NSUInteger, PatientJoinTimeRangeType) {
    PatientJoinTimeRangeTypeStart,
    PatientJoinTimeRangeTypeEnd,
};
static CGFloat const kDatePickerHeight = 260;

@interface NewPatientListViewController ()<ATTableViewAdapterDelegate,UISearchResultsUpdating,UIGestureRecognizerDelegate,PatientListLetterOrderAdapterDelegate,PatientListKeyOrderAdapterDelegate>
@property (nonatomic, strong)  PatientListFilterHeaderView  *filterHeaderView; // <##>
@property (nonatomic, strong)  UIView  *filterTableViewBG; // <##>
@property (nonatomic, strong)  UITableView  *filterTableView; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  PatientFilterTypeView  *filterTypeHeader; // <##>
@property (nonatomic, strong)  PatientFilterTypeFooterView  *filterTypeFooterView; // <##>
@property (nonatomic, strong)  PatientListFilterConditionAdapter  *filterConditionAdapter; // <##>
@property (nonatomic, strong)  PatientListLetterOrderAdapter  *letterOrderAdapter; // <##>
@property (nonatomic, strong)  PatientListKeyOrderAdapter  *keyOrderAdapter; // 关键字排序
@property (nonatomic, strong)  SearchEmptyAdapter  *searchEmptyAdapter; // 无搜索结果adapter
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>
@property (nonatomic, strong)  ASDatePicker  *datePicker; // <##>

@property (nonatomic, strong)  NSMutableDictionary<NSNumber * , NSArray *>  *dictFilterConditionTitles; // <##>
@property (nonatomic, strong)  NSMutableDictionary<NSNumber * , NSString *>  *dictFilterConditionKey; // <##>
@property (nonatomic, copy)  NSArray  *filterTypeViewTitles; // <##>
@property (nonatomic, copy)  NSArray  *sortRuleTitles; // 排序规则
@property (nonatomic, copy)  NSArray<NewPatientListInfoModel *>  *originPatientList; // <##>

@property (nonatomic)  PatientListFilterType  currentSelectedType; // <##>
@property (nonatomic)  PatientFilterTag  confirmPatientTag; // 确认选中的患者标签

@property (nonatomic)  PatientFilterTag  currentPatientTagTemp; // 当前选中的患者标签，可能被取消
@property (nonatomic, copy)  NSString  *currentSelectedSortRuleTemp; // 当前选中排序规则，可能被取消
@property (nonatomic)  PatientJoinTimeRangeType  timeRangeType; // <##>

@property (nonatomic, strong)  NSDate  *currentJoinStartDate; // 当前选中入组开始时间
@property (nonatomic, strong)  NSDate  *currentJoinEndDate; // 当前选中入组结束时间
@property (nonatomic, strong)  NSDate  *confirmJoinStartDate; // 确认入组开始时间
@property (nonatomic, strong)  NSDate  *confirmJoinEndDate; // 确认入组结束时间

@property (nonatomic, strong)  MASConstraint  *datePickerBottomConstraint; // <##>
@property (nonatomic, assign)  BOOL  datePickerDisplayed; // 时间控件是否显示
@property (nonatomic, strong)  UILabel *patientsCountLb;    //显示当前展示人数lb

@property (nonatomic, assign)  PatientFilterViewType  viewType; // 筛选type

@property (nonatomic, strong) UIButton *scrollToTopBtn;       // 滚到顶部按钮
@end

@implementation NewPatientListViewController

- (instancetype)initWithPatientFilterViewType:(PatientFilterViewType)type
{
    self = [super init];
    if (self) {
        _viewType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(p_searchClickedAction)];
    [self.navigationItem setRightBarButtonItem:searchItem];
    [self p_configElements];
//    [self p_requestPatientsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchVC.active) {
        self.searchVC.active = NO;
        [self.searchVC.searchBar removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestPatientsListImmediately:NO];
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)p_configElements {
    // 设置数据
    [self p_configData];
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    self.confirmPatientTag = PatientFilterTagNone;
    self.currentPatientTagTemp = PatientFilterTagNone;
    self.filterTypeViewTitles = @[@"服务",@"团队", @"疾病", @"筛选"];
    switch (self.viewType) {
        case PatientFilterViewTypeAll:
            self.title = @"用户列表";
            self.sortRuleTitles = @[@"按入组时间先后顺序", @"按服务费用从高到低", @"按预警次数从多到少", @"按年龄从高到底"];
            self.confirmPatientTag = PatientFilterTagNone;
            self.currentPatientTagTemp = PatientFilterTagNone;
            break;
        case PatientFilterViewTypeFree:
            self.title = @"随访用户";
            self.sortRuleTitles = @[@"按入组时间先后顺序", @"按预警次数从多到少", @"按年龄从高到底"];
            self.confirmPatientTag = PatientFilterTagFree;
            self.currentPatientTagTemp = PatientFilterTagFree;
            break;
        case PatientFilterViewTypeCharge:
            self.title = @"收费用户";
            self.sortRuleTitles = @[@"按入组时间先后顺序", @"按服务费用从高到低", @"按预警次数从多到少", @"按年龄从高到底"];
            self.confirmPatientTag = PatientFilterTagPackage;
            self.currentPatientTagTemp = PatientFilterTagPackage;
            break;
    }
    __weak typeof(self) weakSelf = self;
    [self.filterHeaderView addNotyficationForItemClicked:^(UIButton *item) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf p_showDatePicker:NO];
        strongSelf.filterTableViewBG.hidden = !item.selected;
        strongSelf.currentJoinStartDate = strongSelf.confirmJoinStartDate;
        strongSelf.currentJoinEndDate = strongSelf.confirmJoinEndDate;
        if (strongSelf.filterTableViewBG.hidden) {
            return;
        }
        strongSelf.currentSelectedType = item.tag;
        if (item.tag == PatientListFilterTypeFilter) {
            [strongSelf.filterTypeHeader resetPatientTag:strongSelf.confirmPatientTag];
            strongSelf.filterTableView.tableHeaderView = strongSelf.filterTypeHeader;
//            strongSelf.filterTableView.tableFooterView = strongSelf.filterTypeFooterView;
            [strongSelf.filterTypeHeader configTimeRangeTime:strongSelf.confirmJoinStartDate index:PatientJoinTimeRangeTypeStart];
            [strongSelf.filterTypeHeader configTimeRangeTime:strongSelf.confirmJoinEndDate index:PatientJoinTimeRangeTypeEnd];

        }
        else {
            strongSelf.filterTableView.tableHeaderView = [UIView new];
//            strongSelf.filterTableView.tableFooterView = [UIView new];
        }
        [strongSelf.filterConditionAdapter reloadData:strongSelf.dictFilterConditionTitles[@(item.tag)] selectedTitle:strongSelf.dictFilterConditionKey[@(item.tag)] footerView:item.tag == PatientListFilterTypeFilter ? strongSelf.filterTypeFooterView : nil];
    }];
    // 用户筛选footer按钮
    [self.filterTypeFooterView addNotiForFilterTypeFooterButtonClicked:^(UIButton *button) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (button.tag == 0) {
            // 重置
            switch (strongSelf.viewType) {
                case PatientFilterViewTypeAll:
                    strongSelf.currentPatientTagTemp = PatientFilterTagNone;
                    break;
                case PatientFilterViewTypeFree:
                    strongSelf.currentPatientTagTemp = PatientFilterTagFree;
                    break;
                case PatientFilterViewTypeCharge:
                    strongSelf.currentPatientTagTemp = PatientFilterTagPackage;
                    break;
            }
            strongSelf.currentSelectedSortRuleTemp = nil;
            [strongSelf.filterTypeHeader resetPatientTag:strongSelf.currentPatientTagTemp];
            [strongSelf.filterConditionAdapter reloadData:strongSelf.dictFilterConditionTitles[@(PatientListFilterTypeFilter)] selectedTitle:nil footerView:strongSelf.filterTypeFooterView];
            [strongSelf.filterTypeHeader resetTimeRange];
            strongSelf.currentJoinStartDate = nil;
            strongSelf.currentJoinEndDate = nil;
            strongSelf.confirmJoinStartDate = nil;
            strongSelf.confirmJoinEndDate = nil;
        }
        else {
            // 确定
            strongSelf.confirmJoinStartDate = strongSelf.currentJoinStartDate;
            strongSelf.confirmJoinEndDate = strongSelf.currentJoinEndDate;
            [strongSelf.filterHeaderView refreshTitleStateWithTitle:nil];
        }
        strongSelf.confirmPatientTag = strongSelf.currentPatientTagTemp;
        strongSelf.dictFilterConditionKey[@(PatientListFilterTypeFilter)] = strongSelf.currentSelectedSortRuleTemp;

        [strongSelf p_filterPatientsAction];
        BOOL filterButtonSelected = strongSelf.confirmPatientTag != PatientFilterTagNone || strongSelf.dictFilterConditionKey[@(PatientListFilterTypeFilter)] || self.confirmJoinStartDate || self.confirmJoinEndDate;
        [strongSelf.filterHeaderView lockFilterButtonSelected:filterButtonSelected];
    }];
    
    [self.datePicker addDatePickerCompletionNoti:^(BOOL confirm, NSDate *date) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf p_showDatePicker:NO];
        if (confirm) {
            if (strongSelf.timeRangeType == PatientJoinTimeRangeTypeStart) {
                [strongSelf.filterTypeHeader configTimeRangeTime:date index:PatientJoinTimeRangeTypeStart];
                strongSelf.currentJoinStartDate = date;
            }
            else {
                strongSelf.currentJoinEndDate = date;
                [strongSelf.filterTypeHeader configTimeRangeTime:date index:PatientJoinTimeRangeTypeEnd];
            }

        }
    }];
    // 用户标签
    [self.filterTypeHeader addNotiForPatientTag:^(UIButton *item) {
        if (item.selected) {
            weakSelf.currentPatientTagTemp = item.tag;
        }
        else {
            weakSelf.currentPatientTagTemp = PatientFilterTagNone;
        }
        weakSelf.letterOrderAdapter.filterFollow = weakSelf.currentPatientTagTemp == PatientFilterTagFocus ? YES : NO;
        weakSelf.keyOrderAdapter.filterFollow = weakSelf.currentPatientTagTemp == PatientFilterTagFocus ? YES : NO;

    }];

    [self.filterTypeHeader addNotiForTimeRangeButton:^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (index == PatientJoinTimeRangeTypeStart) {
            if (strongSelf.currentJoinStartDate) {
                strongSelf.datePicker.minimumDate = nil;
                [strongSelf.datePicker setDate:strongSelf.currentJoinStartDate animated:YES];
            }
            if (strongSelf.currentJoinEndDate) {
                strongSelf.datePicker.maximumDate = strongSelf.currentJoinEndDate;
            }
            else {
                strongSelf.datePicker.maximumDate = [NSDate date];
            }
        }
        else if (index == PatientJoinTimeRangeTypeEnd) {
            if (strongSelf.currentJoinEndDate) {
                strongSelf.datePicker.maximumDate = [NSDate date];
                [strongSelf.datePicker setDate:strongSelf.currentJoinEndDate animated:YES];
            }
            if (strongSelf.currentJoinStartDate) {
                strongSelf.datePicker.minimumDate = strongSelf.currentJoinStartDate;
            }
        }
        strongSelf.timeRangeType = index;
        [strongSelf p_showDatePicker:YES];
    }];
}

// 显示时间选择控件
- (void)p_showDatePicker:(BOOL)show {
    if (self.datePickerDisplayed == show) {
        return;
    }
    self.datePickerBottomConstraint.offset = show ? 0 : kDatePickerHeight;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.24 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view layoutIfNeeded];
    }];
    self.datePickerDisplayed = show;
}

// 设置约束
- (void)p_configConstraints {
    [self.view addSubview:self.filterHeaderView];
    [self.filterHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.filterHeaderView.mas_bottom);
    }];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view).offset(-15);
//        make.height.width.equalTo(@45);
    }];
    
    [self.view addSubview:self.patientsCountLb];
    [self.patientsCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(10);
        make.top.equalTo(self.filterHeaderView.mas_bottom).offset(1);
        make.height.equalTo(@25);
    }];
    
    [self.view addSubview:self.filterTableViewBG];
    [self.filterTableViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    
    // 时间筛选
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kDatePickerHeight);
        self.datePickerBottomConstraint = make.bottom.equalTo(self.view).offset(kDatePickerHeight);
    }];
}


// 请求全部患者
- (void)requestPatientsListImmediately:(BOOL)immediately {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:immediately CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:errorMsg];
            return;
        }
        NSString *predicateString;
        switch (strongSelf.viewType) {
            case PatientFilterViewTypeAll:
                break;
            case PatientFilterViewTypeFree:
                predicateString = @"SELF.paymentType = 1";
                break;
            case PatientFilterViewTypeCharge:
                predicateString = @"SELF.paymentType = 2";
                break;
        }
        if (predicateString) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            strongSelf.originPatientList = [results filteredArrayUsingPredicate:predicate];
        }
        else {
            strongSelf.originPatientList = results;
        }
        [strongSelf p_configFilterKeysWithSourceData:strongSelf.originPatientList];
        [strongSelf.resultVC configWithSourceData:strongSelf.originPatientList];
        [strongSelf p_filterPatientsAction];
    }];
}

// 提取筛选条件helper
- (void)p_configFilterKeysWithSourceData:(NSArray<NewPatientListInfoModel *> *)patients {
    // 服务
    self.dictFilterConditionTitles[@(PatientListFilterTypeService)] = [self p_getFilterKeyListFromSourceData:patients key:@"productName"];
    // 团队
    self.dictFilterConditionTitles[@(PatientListFilterTypeTeam)] = [self p_getFilterKeyListFromSourceData:patients key:@"teamName"];

    // 疾病
    self.dictFilterConditionTitles[@(PatientListFilterTypeDisease)] = [self p_getFilterKeyListFromSourceData:patients key:@"diseaseTitle"];
    // 排序方式
    self.dictFilterConditionTitles[@(PatientListFilterTypeFilter)] = self.sortRuleTitles;
}

// 提取筛选条件helper
- (NSArray *)p_getFilterKeyListFromSourceData:(NSArray<NewPatientListInfoModel *> *)patients key:(NSString *)key {
    NSArray *keyArray = [patients valueForKey:key];
    NSSet *keySet = [NSSet setWithArray:keyArray];
    NSMutableArray *keyList = [NSMutableArray arrayWithObject:@"全部"];
    [keyList addObjectsFromArray:keySet.allObjects];
    [keyList removeObject:@""];
    return keyList;
}

// 排序筛选操作
- (void)p_filterPatientsAction {
    self.searchEmptyAdapter.displayEmptyView = YES;
    PatientListSortType sortType = [self p_sortTypeForSortTitle];
    NSArray *arrayResult;
    NSString *predicateString = [self p_formatPredicateSting];
    if (predicateString.length == 0) {
        arrayResult = self.originPatientList;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        arrayResult = [self.originPatientList filteredArrayUsingPredicate:predicate];
    }
    
    // 去重
    __block NSMutableArray *tempArr = [NSMutableArray array];
    __block NSMutableArray *tempUserIdArr = [NSMutableArray array];
    
    [arrayResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NewPatientListInfoModel *tempModel = (NewPatientListInfoModel *)obj;
        if (![tempUserIdArr containsObject:@(tempModel.userId)]) {
            [tempUserIdArr addObject:@(tempModel.userId)];
            [tempArr addObject:obj];
        }
    }];
    
    
    arrayResult = tempArr;
    if (sortType == PatientListSortTypeDefault) {
        // 默认排序
        self.tableView.delegate = self.letterOrderAdapter;
        self.tableView.dataSource = self.letterOrderAdapter;
        [self.patientsCountLb setText:[NSString stringWithFormat:@"  共%ld人   ",arrayResult.count]];
        __weak typeof(self) weakSelf = self;
        [self.letterOrderAdapter reloadTableViewWithOriginData:arrayResult completion:^{
            [weakSelf at_hideLoading];
        }];
    }
    else {
        NSString *sortKey = [self p_sortKeyWithSortType:sortType];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:sortType == PatientListSortTypeTime ? YES : NO];
        NSArray *sortedArray = [arrayResult sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.tableView.delegate = self.keyOrderAdapter;
        self.tableView.dataSource = self.keyOrderAdapter;
        [self.patientsCountLb setText:[NSString stringWithFormat:@"  共%ld人   ",sortedArray.count]];
        [self.keyOrderAdapter reloadTableViewWithOriginData:sortedArray];
        [self at_hideLoading];
    }
    
}

// 根据排序类型返回排序key
- (NSString *)p_sortKeyWithSortType:(PatientListSortType)sortType {
    NSString *sortKey;
    switch (sortType) {
        case PatientListSortTypeTime: {
            sortKey = @"joinDate";
            break;
        }
        case PatientListSortTypeFee: {
            sortKey = @"orderMoney";
            break;
        }
        case PatientListSortTypeAlertTimes: {
            sortKey = @"alertCount";
            break;
        }
        case PatientListSortTypeAge: {
            sortKey = @"age";
            break;
        }
        default:
            break;
    }
    return sortKey;
}

// 格式化谓词条件
- (NSString *)p_formatPredicateSting {
    __block NSMutableString *predicateString = [NSMutableString string];
    // 普通筛选条件
    [self.dictFilterConditionKey enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (key.integerValue != PatientListFilterTypeFilter) {
            if (![obj isEqualToString:@"全部"]) {
                switch (key.integerValue) {
                    case PatientListFilterTypeService:
                        if (predicateString.length >0) {
                            [predicateString appendString:[NSString stringWithFormat:@" AND SELF.productName = '%@'",obj]];
                        }
                        else {
                            [predicateString appendString:[NSString stringWithFormat:@"SELF.productName = '%@'",obj]];
                        }
                        break;
                        
                    case PatientListFilterTypeTeam:
                        if (predicateString.length >0) {
                            [predicateString appendString:[NSString stringWithFormat:@" AND SELF.teamName = '%@'",obj]];
                        }
                        else {
                            [predicateString appendString:[NSString stringWithFormat:@"SELF.teamName = '%@'",obj]];
                        }
                        break;
                        
                    case PatientListFilterTypeDisease:
                        if (predicateString.length >0) {
                            [predicateString appendString:[NSString stringWithFormat:@" AND SELF.diseaseTitle = '%@'",obj]];
                        }
                        else {
                            [predicateString appendString:[NSString stringWithFormat:@"SELF.diseaseTitle = '%@'",obj]];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }];
    // 标签筛选
    switch (self.confirmPatientTag) {
        case PatientFilterTagNone: {
            break;
        }
        case PatientFilterTagPackage: {
            if (predicateString.length >0) {
                [predicateString appendString:[NSString stringWithFormat:@" AND SELF.classify IN {2,4} AND rootTypeCode <> 'JTTC'"]];
            }
            else {
                [predicateString appendString:[NSString stringWithFormat:@"SELF.classify IN {2,4} AND rootTypeCode <> 'JTTC'"]];
            }
            
            break;
        }
        case PatientFilterTagFree: {
            if (predicateString.length >0) {
                [predicateString appendString:[NSString stringWithFormat:@" AND SELF.classify = 3 AND rootTypeCode <> 'JTTC'"]];
            }
            else {
                [predicateString appendString:[NSString stringWithFormat:@"SELF.classify = 3 AND rootTypeCode <> 'JTTC'"]];
            }
            break;
        }
        case PatientFilterTagGroup: {
            if (predicateString.length >0) {
                [predicateString appendString:[NSString stringWithFormat:@" AND SELF.blocId != 0 AND classify IN {2,3,4} AND rootTypeCode = 'JTTC'"]];
            }
            else {
                [predicateString appendString:[NSString stringWithFormat:@"SELF.blocId != 0 AND classify IN {2,3,4} AND rootTypeCode = 'JTTC'"]];
            }
            
            break;
        }
        case PatientFilterTagSingle: {
            if (predicateString.length >0) {
                [predicateString appendString:[NSString stringWithFormat:@" AND SELF.classify = 5"]];
            }
            else {
                [predicateString appendString:[NSString stringWithFormat:@"SELF.classify = 5"]];
            }
            
            break;
        }
        case PatientFilterTagFocus: {
            if (predicateString.length >0) {
                [predicateString appendString:[NSString stringWithFormat:@" AND SELF.attentionStatus = 1"]];
            }
            else {
                [predicateString appendString:[NSString stringWithFormat:@"SELF.attentionStatus = 1"]];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    // 入组时间筛选
    if (self.confirmJoinStartDate) {
        if (predicateString.length >0) {
            [predicateString appendString:[NSString stringWithFormat:@" AND SELF.joinDate >= '%@'", [DateUtil stringDateFormatedDate:self.confirmJoinStartDate]]];
        }
        else {
            [predicateString appendString:[NSString stringWithFormat:@"SELF.joinDate >= '%@'",[DateUtil stringDateFormatedDate:self.confirmJoinStartDate]]];
        }
        
    }
    if (self.confirmJoinEndDate) {
        if (predicateString.length >0) {
            [predicateString appendString:[NSString stringWithFormat:@" AND SELF.joinDate <= '%@'",[DateUtil stringDateFormatedDate:self.confirmJoinEndDate]]];
        }
        else {
            [predicateString appendString:[NSString stringWithFormat:@"SELF.joinDate <= '%@'",[DateUtil stringDateFormatedDate:self.confirmJoinEndDate]]];
        }
        
    }
    return predicateString;
}

// 根据选择的排序title返回排序类型
- (PatientListSortType)p_sortTypeForSortTitle {
    NSString *title = self.dictFilterConditionKey[@(PatientListFilterTypeFilter)];
    PatientListSortType type = PatientListSortTypeDefault;
    if ([title isEqualToString:@"按入组时间先后顺序"]) {
        type = PatientListSortTypeTime;
    }
    else if ([title isEqualToString:@"按服务费用从高到低"]) {
        type = PatientListSortTypeFee;
    }
    else if ([title isEqualToString:@"按预警次数从多到少"]) {
        type = PatientListSortTypeAlertTimes;
    }
    else if ([title isEqualToString:@"按年龄从高到底"]) {
        type = PatientListSortTypeAge;
    }
    else {
        type = PatientListSortTypeDefault;
    }
    return type;
}

- (void)p_resetCurrentFilterAction {
    self.currentPatientTagTemp = self.confirmPatientTag;
    self.currentSelectedSortRuleTemp = self.dictFilterConditionKey[@(PatientListFilterTypeFilter)];
}
    
- (void)p_showFollowStatus:(BOOL)follow {
    [self at_postSuccess:follow ? @"关注成功" : @"取消关注成功"];
    [self updatePatientsCountLb];
}

// 更新人数标签
- (void)updatePatientsCountLb {
    
    NSArray *arrayResult;
    NSString *predicateString = [self p_formatPredicateSting];
    if (predicateString.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        arrayResult = [self.originPatientList filteredArrayUsingPredicate:predicate];
        [self.patientsCountLb setText:[NSString stringWithFormat:@"  共%ld人   ",arrayResult.count]];
    }
}
// 滚到顶部
- (void)scrollToTopClick {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - Event Response

- (void)p_searchClickedAction {
    [self.filterHeaderView refreshTitleStateWithTitle:nil];
    [self presentViewController:self.searchVC animated:YES completion:nil];
}

- (void)p_closeConditionTableView:(UITapGestureRecognizer *)gesture {
    [self.filterHeaderView refreshTitleStateWithTitle:nil];
    [self p_resetCurrentFilterAction];
}
#pragma mark - Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.filterTableView || touch.view == self.filterTableViewBG) {
        return YES;
    }
    return NO;
}
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        PatientSearchResultTableViewController *VC = (PatientSearchResultTableViewController *)searchController.searchResultsController;
        [VC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            PatientInfo *info;
            if ([resultData isKindOfClass:[PatientInfo class]]) {
                info = resultData;
            }
            else if ([resultData isKindOfClass:[NewPatientListInfoModel class]]) {
                info = [resultData convertToPatientInfo];
            }
            [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)info.userId]];

        }];
    }
}

#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if ([cellData isKindOfClass:[NSString class]]) {
        // title
        if (self.currentSelectedType != PatientListFilterTypeFilter) {
            self.dictFilterConditionKey[@(self.currentSelectedType)] = cellData;
            [self.filterHeaderView refreshTitleStateWithTitle:[cellData isEqualToString:@"全部"] ? self.filterTypeViewTitles[self.currentSelectedType] : cellData];
            [self p_filterPatientsAction];
        }
        else {
            if ([self.currentSelectedSortRuleTemp isEqualToString:cellData]) {
                self.currentSelectedSortRuleTemp = nil;
            }
            else {
                self.currentSelectedSortRuleTemp = cellData;
            }
            [self.filterConditionAdapter reloadData:self.dictFilterConditionTitles[@(PatientListFilterTypeFilter)] selectedTitle:self.currentSelectedSortRuleTemp footerView:self.filterTypeFooterView];
        }
    }
    else if ([cellData isKindOfClass:[NewPatientListInfoModel class]]) {
        // 患者cell点击
        NewPatientListInfoModel *model = (NewPatientListInfoModel *)cellData;
        
        PatientInfo *info = [model convertToPatientInfo];
        [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)info.userId]];
    }
}

// 关注筛选下更新列表
- (void)patientListLetterOrderAdapterDelegateNeedReloadData {
    [self p_filterPatientsAction];
}

- (void)patientListKeyOrderAdapterDelegateCallBack_followStatus:(BOOL)follow {
    [self p_showFollowStatus:follow];
}

- (void)patientListLetterOrderAdapterDelegateCallBack_followStatus:(BOOL)follow {
    [self p_showFollowStatus:follow];
}

- (void)patientListLetterOrderAdapterDelegateCallBack_scrollViewDidScroll:(CGFloat)offsetY {
    [self.scrollToTopBtn setHidden:offsetY <= 0];
}

- (void)patientListKeyOrderAdapterDelegateCallBack_scrollViewDidScroll:(CGFloat)offsetY {
    [self.scrollToTopBtn setHidden:offsetY <= 0];
}
#pragma mark - Override

#pragma mark - Init

- (PatientListFilterHeaderView *)filterHeaderView {
    if (!_filterHeaderView) {
        _filterHeaderView = [[PatientListFilterHeaderView alloc] initWithTitles:self.filterTypeViewTitles tags:@[@(PatientListFilterTypeService),@(PatientListFilterTypeTeam),@(PatientListFilterTypeDisease),@(PatientListFilterTypeFilter)]];
        _filterHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _filterHeaderView;
}

- (UITableView *)filterTableView {
    if (!_filterTableView) {
        _filterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _filterTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage at_imageWithColor:[UIColor clearColor] size:CGSizeMake(2, 2)]];
        _filterTableView.delegate = self.filterConditionAdapter;
        _filterTableView.dataSource = self.filterConditionAdapter;
        _filterTableView.bounces = NO;
        [_filterTableView registerClass:[PatientListFilterConditionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListFilterConditionTableViewCell class])];
        _filterTableView.rowHeight = 45;
        _filterTableView.tableFooterView = [UIView new];
        
    }
    return _filterTableView;
}

- (UIView *)filterTableViewBG {
    if (!_filterTableViewBG) {
        _filterTableViewBG = [UIView new];
        _filterTableViewBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage at_imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] size:CGSizeMake(2, 2)]];
        [_filterTableViewBG addSubview:self.filterTableView];
        [self.filterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_filterTableViewBG).insets(UIEdgeInsetsMake(0, 0, 60, 0));
        }];
        _filterTableViewBG.hidden = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_closeConditionTableView:)];
        gesture.delegate = self;
        [_filterTableViewBG addGestureRecognizer:gesture];
    }
    return _filterTableViewBG;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchVC.searchResultsUpdater = self;
        [_searchVC.searchBar setBarTintColor: [UIColor colorWithHexString:@"f0f0f0"]];
        [_searchVC.searchBar sizeToFit];
        _searchVC.view.backgroundColor = [UIColor commonBackgroundColor];
        self.definesPresentationContext = YES;
    }
    return _searchVC;
}

- (PatientSearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[PatientSearchResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _resultVC;
}

- (PatientFilterTypeView *)filterTypeHeader {
    if (!_filterTypeHeader) {
        _filterTypeHeader = [[PatientFilterTypeView alloc] initWithPatientFilterViewType:self.viewType];
        _filterTypeHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    }
    return _filterTypeHeader;
}
- (PatientFilterTypeFooterView *)filterTypeFooterView {
    if (!_filterTypeFooterView) {
        _filterTypeFooterView = [[PatientFilterTypeFooterView alloc] init];
        _filterTypeFooterView.frame = CGRectMake(0, 0, self.view.frame.size.width, 45);
    }
    return _filterTypeFooterView;

}

- (PatientListFilterConditionAdapter *)filterConditionAdapter {
    if (!_filterConditionAdapter) {
        _filterConditionAdapter = [PatientListFilterConditionAdapter new];
        _filterConditionAdapter.adapterArray = [@[@"全部"] mutableCopy];
        _filterConditionAdapter.adapterDelegate = self;
        _filterConditionAdapter.tableView = self.filterTableView;
    }
    return _filterConditionAdapter;
}

- (PatientListLetterOrderAdapter *)letterOrderAdapter {
    if (!_letterOrderAdapter) {
        _letterOrderAdapter = [PatientListLetterOrderAdapter new];
        _letterOrderAdapter.adapterDelegate = self;
        _letterOrderAdapter.tableView = self.tableView;
        _letterOrderAdapter.customDelegate = self;
    }
    return _letterOrderAdapter;
}

- (PatientListKeyOrderAdapter *)keyOrderAdapter {
    if (!_keyOrderAdapter) {
        _keyOrderAdapter = [PatientListKeyOrderAdapter new];
        _keyOrderAdapter.adapterDelegate = self;
        _keyOrderAdapter.tableView = self.tableView;
        _keyOrderAdapter.customDelegate = self;
    }
    return _keyOrderAdapter;
}

- (SearchEmptyAdapter *)searchEmptyAdapter {
    if (!_searchEmptyAdapter) {
        _searchEmptyAdapter = [SearchEmptyAdapter new];
        _searchEmptyAdapter.title = @"无相关用户";
        _searchEmptyAdapter.displayEmptyView = NO;
    }
    return _searchEmptyAdapter;
}
- (NSMutableDictionary<NSNumber *,NSString *> *)dictFilterConditionKey {
    if (!_dictFilterConditionKey) {
        _dictFilterConditionKey = [NSMutableDictionary dictionaryWithCapacity:PatientListFilterTypeMax];
        for (NSInteger i = 0; i < PatientListFilterTypeMax; i ++) {
            if (i == PatientListFilterTypeFilter) {
                self.currentSelectedSortRuleTemp = nil;
                _dictFilterConditionKey[@(i)] = self.currentSelectedSortRuleTemp;
            }
            else {
                _dictFilterConditionKey[@(i)] = @"全部";
            }
        }
    }
    return _dictFilterConditionKey;
}

- (NSMutableDictionary<NSNumber *,NSArray *> *)dictFilterConditionTitles {
    if (!_dictFilterConditionTitles) {
        _dictFilterConditionTitles = [NSMutableDictionary dictionaryWithCapacity:PatientListFilterTypeMax];
        for (NSInteger i = 0; i < PatientListFilterTypeMax; i ++) {
            if (i == PatientListFilterTypeFilter) {
                _dictFilterConditionTitles[@(i)] = nil;
            }
            else {
                _dictFilterConditionTitles[@(i)] = @[@"全部"];
            }
        }
    }
    return _dictFilterConditionTitles;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        _tableView.delegate = self.letterOrderAdapter;
        _tableView.dataSource = self.letterOrderAdapter;
        [_tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = [UIColor mainThemeColor];
        _tableView.emptyDataSetSource = self.searchEmptyAdapter;
        _tableView.emptyDataSetDelegate = self.searchEmptyAdapter;
        
    }
    return _tableView;

}

- (ASDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[ASDatePicker alloc] initWithToolbar:YES];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.maximumDate = [NSDate date];
    }
    return _datePicker;
}

- (UILabel *)patientsCountLb {
    if (!_patientsCountLb) {
        _patientsCountLb = [UILabel new];
        [_patientsCountLb setBackgroundColor:[UIColor colorWithHexString:@"0099ff"]];
        [_patientsCountLb setAlpha:0.7];
        [_patientsCountLb setFont:[UIFont systemFontOfSize:14]];
        [_patientsCountLb setText:@"  共0人   "];
        [_patientsCountLb.layer setCornerRadius:12.5];
        [_patientsCountLb setClipsToBounds:YES];
        [_patientsCountLb setTextColor:[UIColor whiteColor]];
    }
    return _patientsCountLb;
}

- (UIButton *)scrollToTopBtn {
    if (!_scrollToTopBtn) {
        _scrollToTopBtn = [UIButton new];
        [_scrollToTopBtn setImage:[UIImage imageNamed:@"im_top"] forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self action:@selector(scrollToTopClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollToTopBtn setHidden:YES];
    }
    return _scrollToTopBtn;
}
@end
