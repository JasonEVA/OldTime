//
//  HMHistoryPatientListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHistoryPatientListViewController.h"
#import "JWSegmentView.h"
#import "PatientListTableViewCell.h"
#import "HMSomeOneALLHistorySessionViewController.h"

#define SEGMENTVIEWHEIGHT  40

@interface HMHistoryPatientListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic) HMFEPatientListViewType type;
@property (nonatomic, strong) JWSegmentView *segmentView;
@end

@implementation HMHistoryPatientListViewController
- (instancetype)initWithType:(HMFEPatientListViewType)type
{
    self = [super init];
    if (self) {
        if (type == HMFEPatientListViewType_Single) {
            self.type = HMFEPatientListViewType_Package;
        }
        else {
            self.type = type;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titel = @"";
    switch (self.type) {
        case HMFEPatientListViewType_Free:
            titel = @"免费历史用户";
            break;
        case HMFEPatientListViewType_Package:
        case HMFEPatientListViewType_Single:
            titel = @"收费历史用户";
            break;
        case HMFEPatientListViewType_Group:
            titel = @"集团历史用户";
            break;
        default:
            break;
    }
    [self setTitle:titel];
    
    [self configElements];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self startGetHistoryRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    if (self.type == HMFEPatientListViewType_Package || self.type == HMFEPatientListViewType_Single) {
        [self.view addSubview:self.segmentView];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        if ([self.view.subviews containsObject:self.segmentView]) {
            make.top.equalTo(self.segmentView.mas_bottom);
        }
        else {
            make.top.equalTo(self.view);
        }
    }];
}

- (void)startGetHistoryRequest {
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];

    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.staffId] forKey:@"staffId"];

    [dicPost setValue:@(self.type + 1) forKey:@"paymentType"];
    [dicPost setValue:@(1) forKey:@"pageNum"];
    [dicPost setValue:@(1000) forKey:@"pageSize"];


    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMFindHistorySessionPatientListRequest" taskParam:dicPost TaskObserver:self];
    
    
    /*
     ###
     // 医生端 历史患者列表
     // paymentType 0 全部 1 个人免费 2 套餐 3 单次 4 集团套餐用户
     POST http://127.0.0.1:10018/uniqueComservice2/base.do?do=httpInterface&flag=2&module=workBenchPatientService&method=findStaffhHistoryPatientList HTTP/1.1
     Content-Type: application/json
     
     {
     "staffId": "3023819",
     "paymentType": 4,
     "pageNum": 1,
     "pageSize": 3
     }
     */
    
}
#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无历史用户" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"g"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientListTableViewCell at_identifier]];
    [cell configCellDataWithNewPatientListInfoModel:self.dataList[indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMSomeOneALLHistorySessionViewController *VC = [[HMSomeOneALLHistorySessionViewController alloc] initWithModel:self.dataList[indexPath.row] type:self.type];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError ) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
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
    
    if ([taskname isEqualToString:@"HMFindHistorySessionPatientListRequest"])
    {
        self.dataList = taskResult;
        [self.tableView reloadData];
    }
  
    
}
#pragma mark - Interface

#pragma mark - init UI
- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, SEGMENTVIEWHEIGHT) titelArr:@[@"套餐",@"单项"] tagArr:@[@(HMFEPatientListViewType_Package),@(HMFEPatientListViewType_Single)] titelSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] lineJWColor:[UIColor colorWithHexString:@"fffffff"] backJWColor:[UIColor mainThemeColor] lineWidth:(ScreenWidth / 2.0) block:^(NSInteger selectedTag) {
            
            weakSelf.type = selectedTag;
            [weakSelf startGetHistoryRequest];
        }];
    }
    return _segmentView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setRowHeight:90];
        [_tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = [UIColor mainThemeColor];
        
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}


@end
