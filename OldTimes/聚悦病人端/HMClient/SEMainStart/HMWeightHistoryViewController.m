//
//  HMWeightHistoryViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHistoryViewController.h"
#import "HMWeightHistoryTopView.h"
#import "HMSuperviseDetailModel.h"
#import "HMWeightHistoryIdealWeightTableViewCell.h"
#import "HMWeightHistoryCompareTableViewCell.h"
#import "HMTZMainDiagramDataModel.h"
#import "HealthyEducationColumeModel.h"
#import "HealthEducationItem.h"
#import "HMWeightHealthClassTableViewCell.h"
#import "HMWeightPKViewController.h"
#import "HMIdealWeightViewController.h"
#import "HMSetNewTargetWeightViewController.h"

#define SEGMENTVIEWHEIGHT   45

#define TOPVIEWHEOGHT             (220 * (ScreenWidth / 375))
#define PAGESIZE       30

@interface HMWeightHistoryViewController ()<TaskObserver,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HMWeightHistoryTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HMTZMainDiagramDataModel *model;
@property (nonatomic, copy) NSArray<HealthEducationItem *> *notesArr;
@end

@implementation HMWeightHistoryViewController

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configElements];
    self.topView.page = 1;
    [self startHealthClassRequest];
    [self startGetTZDtailDataRequest];
    [self startGetTZMainDiagramDataRequest];

    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:upLoadWeightSuccessNotification object:nil];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SEGMENTVIEWHEIGHT - 64) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [_tableView setEstimatedRowHeight:45];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setTableHeaderView:self.topView];
    [_tableView registerClass:[HMWeightHistoryIdealWeightTableViewCell class] forCellReuseIdentifier:[HMWeightHistoryIdealWeightTableViewCell at_identifier]];
    [_tableView registerClass:[HMWeightHistoryCompareTableViewCell class] forCellReuseIdentifier:[HMWeightHistoryCompareTableViewCell at_identifier]];
    [_tableView registerClass:[HMWeightHealthClassTableViewCell class] forCellReuseIdentifier:[HMWeightHealthClassTableViewCell at_identifier]];
    

    [self.view addSubview:self.tableView];
}

- (void)startGetTZDtailDataRequest {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dicPost setValue:@"TZ" forKey:@"kpiCode"];
    [dicPost setValue:@"dtime" forKey:@"timeForm"];
    [dicPost setValue:@(self.topView.page) forKey:@"page"];
    [dicPost setValue:@(PAGESIZE) forKey:@"size"];
    
    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetDiagramDataRequest" taskParam:dicPost TaskObserver:self];
}

- (void)startGetTZMainDiagramDataRequest {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetTZMainDiagramDataRequest" taskParam:dicPost TaskObserver:self];
}


- (void)startHealthClassRequest {
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@"JKSH" forKey:@"typeCode"];
    [dicPost setValue:@(1) forKey:@"page"];
    [dicPost setValue:@(4) forKey:@"size"];

    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMFindClassDetailListByTypeCodeRequest" taskParam:dicPost TaskObserver:self];

}
#pragma mark - event Response
- (void)reloadAction {
    self.topView.page = 1;
    [self startGetTZDtailDataRequest];
    [self startGetTZMainDiagramDataRequest];

}
#pragma mark - Delegate
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *dict = change[@"new"];
        CGPoint point = dict.CGPointValue;
        if (point.y < 0) {
            [self.tableView setContentOffset:CGPointZero];
        }
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return self.notesArr.count > 0;
    }
    else {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    if (!indexPath.section) {
        if (!indexPath.row) {
             cell = [tableView dequeueReusableCellWithIdentifier:[HMWeightHistoryIdealWeightTableViewCell at_identifier]];
            if (!self.model.aimValue || !self.model.aimValue.length) {
                [[cell targetLb] setText:@"去制定"];

            }
            else {
                NSString *targetString = [NSString stringWithFormat:@"%.1f",self.model.aimValue.floatValue];
                [[cell targetLb] setText:[NSString stringWithFormat:@"%@kg",targetString]];

            }
            
        }
        else {
             cell = [tableView dequeueReusableCellWithIdentifier:[HMWeightHistoryCompareTableViewCell at_identifier]];
            [cell fillDataWithModel:self.model];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:[HMWeightHealthClassTableViewCell at_identifier]];
        [cell fillDataWithArray:self.notesArr];
        __weak typeof(self) weakSelf = self;
        
        [cell dealWithClick:^(NSInteger index) {
            HealthEducationItem* educationModel = weakSelf.notesArr[index];
            //跳转到宣教详情
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!indexPath.section && indexPath.row == 1) {
        HMWeightPKViewController *VC = [HMWeightPKViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (!indexPath.row && !indexPath.section) {
        if (!self.model.aimValue || !self.model.aimValue.length) {
            HMSetNewTargetWeightViewController *VC = [[HMSetNewTargetWeightViewController alloc] initWithType:HMGroupPKSetTatgetWeightStep_oneHeight nowWeight:0];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else {
            HMIdealWeightViewController *VC = [HMIdealWeightViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        }

      
    }
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
    
    if ([taskname isEqualToString:@"HMGetDiagramDataRequest"]) {
        NSDictionary *dict = (NSDictionary *)taskResult;
        NSArray *dataList = [HMSuperviseDetailModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        if (dataList && dataList.count) {
            [self.topView addDataWithDataList:dataList maxTarget:[dict[@"max"] floatValue] minTarget:[dict[@"min"] floatValue]];
            self.topView.page++;
        }
        else {
            if (self.topView.page > 1) {
                [self showAlertMessage:@"没有更多数据了"];
            }
        }
        
    }
    
    else if ([taskname isEqualToString:@"HMGetTZMainDiagramDataRequest"]) {
        self.model = (HMTZMainDiagramDataModel *)taskResult;
        [self.tableView reloadData];
    }
    else if ([taskname isEqualToString:@"HMFindClassDetailListByTypeCodeRequest"]) {
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSArray* notes = [dicResult valueForKey:@"list"];
        self.notesArr = notes;
        [self.tableView reloadData];
    }
}

#pragma mark - Interface

#pragma mark - init UI
- (HMWeightHistoryTopView *)topView {
    if (!_topView) {
        _topView = [[HMWeightHistoryTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,TOPVIEWHEOGHT)];
        __weak typeof(self) weakSelf = self;
        [_topView addNextPageAction:^{
            [weakSelf startGetTZDtailDataRequest];
        }];
       }
    return _topView;
}
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        
//    }
//    return _tableView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
