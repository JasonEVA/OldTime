//
//  HMSupervisePlanViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSupervisePlanViewController.h"
#import "HMSESuperViseTableViewCell.h"
#import "HMSupervisePlanHeadView.h"
#import "HMSuperviseDetialViewController.h"

@interface HMSupervisePlanViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *typeStringList;
@property (nonatomic) BOOL isFirstIn;
@property (nonatomic, strong) HMSupervisePlanHeadView *headView;
@end

@implementation HMSupervisePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataList = [NSMutableArray array];
    self.typeStringList = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startGetTrendDataRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startGetTrendDataRequest {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    if (!self.isFirstIn) {
        [self at_postLoading];
        self.isFirstIn = YES;
    }
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetTrendDataRequest" taskParam:dicPost TaskObserver:self];
}

- (void)targetValueDashboardClicked:(NSString *)kpiCode {
    NSString *controllerName = nil;
    if (!kpiCode || 0 == kpiCode.length) {
        return;
    }
    if ([kpiCode isEqualToString:@"XY"]) {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TZ"]) {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XT"]) {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XD"]) {
        //心电
        controllerName = @"ECGDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        //心率
        controllerName = @"HeartRateDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XZ"]) {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"OXY"]) {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"NL"]) {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"HX"]) {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TEM"]) {
        //体温
        controllerName = @"BodyTemperatureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        //峰流速值
        controllerName = @"PEFDetectStartViewController";
    }
    if (!controllerName || 0 == controllerName.length) {
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMSESuperViseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMSESuperViseTableViewCell at_identifier]];

    [cell fillDataWith:self.typeStringList[indexPath.row] dataArr:self.dataList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.dataList[indexPath.row];
    if (arr && arr.count) {
        HMSuperviseDetialViewController *VC = [[HMSuperviseDetialViewController alloc] initWithKpiCode:self.typeStringList[indexPath.row]];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else {
        // 没数据去测试
        [self targetValueDashboardClicked:self.typeStringList[indexPath.row]];
    }
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"您还没有监测计划哦" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_i"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        [self.headView setHidden:YES];
        return YES;
    }
    [self.headView setHidden:NO];
    return NO;
}
#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMGetTrendDataRequest"]) {
        [self.typeStringList removeAllObjects];
        [self.dataList removeAllObjects];
        
        NSArray *tempArr = (NSArray *)taskResult;
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.typeStringList addObject:obj[@"kpiCode"]];
            [self.dataList addObject:obj[@"data"]];

        }];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:90];
        _tableView.separatorStyle = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)]];
        [_tableView registerClass:[HMSESuperViseTableViewCell class] forCellReuseIdentifier:[HMSESuperViseTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView setTableHeaderView:self.headView];
    }
    return _tableView;
}

- (HMSupervisePlanHeadView *)headView {
    if (!_headView) {
        _headView = [[HMSupervisePlanHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _headView;
}


@end
