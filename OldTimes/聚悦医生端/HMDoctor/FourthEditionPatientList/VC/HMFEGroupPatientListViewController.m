//
//  HMFEGroupPatientListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFEGroupPatientListViewController.h"
#import "DAOFactory.h"
#import "HMPatientListGroupModel.h"
#import "HMFEPatientListGroupTableViewCell.h"
#import "PatientListTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMSelectPatientGroupHeaderView.h"
#import "HMPstientListGroupRankModel.h"
#import "HMFEPatientListEnum.h"
#import "HMHistoryPatientListViewController.h"
#import "HMFEAllPatientListViewController.h"

@interface HMFEGroupPatientListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, copy) NSArray *allGroupPatoentsArr;  // 所有集团用户

@property (nonatomic, strong) NSMutableArray <HMPatientListGroupModel *> *groupModelArr;    // 集团Model数组

@property (nonatomic, strong) NSMutableArray *patientsArr;          // 单个集团用户数组
@property (nonatomic) NSInteger selectedGroupId;           // 选中集团Id
@property (nonatomic, strong) UIView *emptyView;           // 空白页
@end

@implementation HMFEGroupPatientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"集团用户"];
    
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_oldgroup"] style:UIBarButtonItemStylePlain target:self action:@selector(historyClick)];
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];

    [self.navigationItem setRightBarButtonItems:@[search,history]];
    
    
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.view);
        make.width.equalTo(@125);
    }];
    
    [self.view addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.bottom.right.equalTo(self.view);
    }];
    
    UIView *line = [UIView new];
    [line setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.rightTableView);
        make.width.equalTo(@0.5);
    }];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestPatientsListImmediately:NO];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
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
        // 从数据库所有用户中筛选出所有集团用户
        predicateString = @"SELF.blocId != 0 AND classify IN {2,3,4} AND rootTypeCode = 'JTTC'";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        strongSelf.allGroupPatoentsArr = [results filteredArrayUsingPredicate:predicate];
        // 控制空白页隐藏
        [strongSelf.emptyView setHidden:strongSelf.allGroupPatoentsArr.count];

        // 筛选出所有集团id
         NSArray *groupIdArr = [strongSelf p_getFilterKeyListFromSourceData:strongSelf.allGroupPatoentsArr key:@"blocId"];

        // 默认设置选中第一个集团
        strongSelf.selectedGroupId = [groupIdArr.firstObject integerValue];
        __block NSMutableArray *arrBlocName = [NSMutableArray array];
        
        // 遍历集团id数组，封装成集团model数组（包含id和name方便数据处理）
        [groupIdArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *predicateStringBloc = [NSString stringWithFormat:@"SELF.blocId = %ld",(long)[obj integerValue]];
            NSPredicate *predicateBloc = [NSPredicate predicateWithFormat:predicateStringBloc];
            NewPatientListInfoModel *tempModel = [strongSelf.allGroupPatoentsArr filteredArrayUsingPredicate:predicateBloc].firstObject;
            HMPatientListGroupModel *model = [HMPatientListGroupModel new];
            model.blocName = tempModel.blocName;
            model.blocId = [obj integerValue];
            [arrBlocName addObject:model];
        }];
        
        strongSelf.groupModelArr = arrBlocName;
        // 刷新左侧tabldeview
        [self.leftTableView reloadData];
        // 处理右侧tableview数据
        [strongSelf dealWithData];
        [strongSelf at_hideLoading];
    }];
}

- (void)dealWithData {
    if (!self.allGroupPatoentsArr || !self.allGroupPatoentsArr.count) {
        return;
    }
    
    NSString *predicateStringVIP = [NSString stringWithFormat:@"SELF.blocId = %ld AND blocRank = 3",(long)self.selectedGroupId];
    NSString *predicateStringMiddle = [NSString stringWithFormat:@"SELF.blocId = %ld AND blocRank = 2",(long)self.selectedGroupId];
    NSString *predicateStringComment = [NSString stringWithFormat:@"SELF.blocId = %ld AND blocRank = 1",(long)self.selectedGroupId];

    NSPredicate *predicateVIP = [NSPredicate predicateWithFormat:predicateStringVIP];
    NSPredicate *predicateMiddle = [NSPredicate predicateWithFormat:predicateStringMiddle];
    NSPredicate *predicateComment = [NSPredicate predicateWithFormat:predicateStringComment];

    [self.patientsArr removeAllObjects];
    
    // 封装集团层级model数据
    HMPstientListGroupRankModel *modelVIP = [HMPstientListGroupRankModel new];
    modelVIP.rankName = @"VIP";
    modelVIP.patientsArr = [self.allGroupPatoentsArr filteredArrayUsingPredicate:predicateVIP];
    [self.patientsArr addObject:modelVIP];
    
    HMPstientListGroupRankModel *modelMiddle = [HMPstientListGroupRankModel new];
    modelMiddle.rankName = @"中层";
    modelMiddle.patientsArr = [self.allGroupPatoentsArr filteredArrayUsingPredicate:predicateMiddle];
    [self.patientsArr addObject:modelMiddle];

    
    HMPstientListGroupRankModel *modelComment = [HMPstientListGroupRankModel new];
    modelComment.rankName = @"普通";
    modelComment.patientsArr = [self.allGroupPatoentsArr filteredArrayUsingPredicate:predicateComment];
    [self.patientsArr addObject:modelComment];
    
   // 默认第一个层级展开
    HMPstientListGroupRankModel *firstModel = self.patientsArr.firstObject;
    firstModel.isExpanded = YES;
    
    [self.rightTableView reloadData];
}

// 提取筛选条件helper
- (NSArray *)p_getFilterKeyListFromSourceData:(NSArray<NewPatientListInfoModel *> *)patients key:(NSString *)key {
    NSArray *keyArray = [patients valueForKey:key];
    NSSet *keySet = [NSSet setWithArray:keyArray];
    NSMutableArray *keyList = [NSMutableArray array];
    [keyList addObjectsFromArray:keySet.allObjects];
    [keyList removeObject:@""];
    return keyList;
}

#pragma mark - event Response
- (void)historyClick {
    HMHistoryPatientListViewController *VC = [[HMHistoryPatientListViewController alloc] initWithType:HMFEPatientListViewType_Group];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)searchClick {
    HMFEAllPatientListViewController *VC = [HMFEAllPatientListViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)headerViewClick:(id) sender
{
    if (![sender isKindOfClass:[HMSelectPatientGroupHeaderView class]])
    {
        return;
    }
    HMSelectPatientGroupHeaderView* headerview = (HMSelectPatientGroupHeaderView*)sender;
    NSInteger section = (headerview.tag);
    HMPstientListGroupRankModel* group = self.patientsArr[section];
    group.isExpanded = !group.isExpanded;
    [self.rightTableView reloadData];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return self.groupModelArr.count;
    }
    else {
        HMPstientListGroupRankModel* group = self.patientsArr[section];
        if (!group.isExpanded)
        {
            return 0;
        }
        NSArray* patientItems = group.patientsArr;
        if (patientItems)
        {
            return patientItems.count;
        }
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.leftTableView]) {
        return 1;
    }
    else {
        return self.patientsArr.count;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    }
    else {
        HMSelectPatientGroupHeaderView* headerview = [[HMSelectPatientGroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.rightTableView.width, 35)];
        
        
        HMPstientListGroupRankModel* group = self.patientsArr[section];
        
        [headerview setGroupName:group.rankName];
        [headerview fillCount:[NSString stringWithFormat:@"%ld",group.patientsArr.count]];
        [headerview setTag:section];
        [headerview setIsExpanded:group.isExpanded];
        [headerview addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerview;
    }
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return 0.1;
    }
    else {
        return 35;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.00001)];
    [footerview setBackgroundColor:[UIColor commonControlBorderColor]];
    return footerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableView]) {
        HMPatientListGroupModel *model = self.groupModelArr[indexPath.row];
        HMFEPatientListGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMFEPatientListGroupTableViewCell at_identifier]];
        [cell fillDataWithModel:model selected:self.selectedGroupId == model.blocId];
        return cell;
    }
    else {
        HMPstientListGroupRankModel* group = self.patientsArr[indexPath.section];

        PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientListTableViewCell at_identifier]];
        [cell configCellDataWithNewPatientListInfoModel:group.patientsArr[indexPath.row]];

        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        HMPatientListGroupModel *model = self.groupModelArr[indexPath.row];
        self.selectedGroupId = model.blocId;
        [self.leftTableView reloadData];
        [self dealWithData];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HMPstientListGroupRankModel* group = self.patientsArr[indexPath.section];

        NewPatientListInfoModel *model = group.patientsArr[indexPath.row];
        
        [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",model.userId]];
    }
}

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_leftTableView setDataSource:self];
        [_leftTableView setDelegate:self];
        [_leftTableView setBackgroundColor:[UIColor whiteColor]];
        [_leftTableView setRowHeight:65];
        [_leftTableView registerClass:[HMFEPatientListGroupTableViewCell class] forCellReuseIdentifier:[HMFEPatientListGroupTableViewCell at_identifier]];
        [_leftTableView setEstimatedSectionHeaderHeight:0];
        [_leftTableView setEstimatedSectionFooterHeight:0];
    }
    return _leftTableView;
}

#pragma mark - init UI
- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_rightTableView setDataSource:self];
        [_rightTableView setDelegate:self];
        [_rightTableView setBackgroundColor:[UIColor clearColor]];
        [_rightTableView setRowHeight:65];
        [_rightTableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:[PatientListTableViewCell at_identifier]];
//        [_rightTableView setEstimatedSectionHeaderHeight:0];
//        [_rightTableView setEstimatedSectionFooterHeight:0];
    }
    return _rightTableView;
}

- (NSMutableArray *)patientsArr {
    if (!_patientsArr) {
        _patientsArr = [NSMutableArray array];
    }
    return _patientsArr;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        [_emptyView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g"]];
        [_emptyView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
        
        UILabel *lb = [UILabel new];
        [lb setText:@"暂无用户"];
        [lb setTextColor:[UIColor colorWithHexString:@"666666"]];
        [lb setFont:[UIFont systemFontOfSize:16]];
        
        [_emptyView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyView);
            make.top.equalTo(image.mas_bottom).offset(5);
        }];
    }
    return _emptyView;
}

@end
