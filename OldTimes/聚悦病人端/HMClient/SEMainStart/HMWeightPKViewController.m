//
//  HMWeightPKViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightPKViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HMSetpPKMainTableViewCell.h"
#import "JWSegmentView.h"
#import "HMGroupPKEnum.h"
#import "HMLoseWeightPkModel.h"

#define TOPVIEWHEIGHT     (260 * (ScreenWidth / 375))
@interface HMWeightPKViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *fifteenDataList;
@property (nonatomic, copy) NSArray *thirtyDataList;

@property (nonatomic, strong) JWSegmentView *segmentView;
@property (nonatomic) HMGroupWeightPKTimeType selectType;
@property (nonatomic) BOOL isFifteenRequested;
@property (nonatomic) BOOL isThirtyRequested;

@end

@implementation HMWeightPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFd_prefersNavigationBarHidden:YES];
    self.selectType = HMGroupWeightPKTimeType_thirtyDays;
    [self startRequestPKlist];
    
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

#pragma mark -private method
- (void)configElements {
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@TOPVIEWHEIGHT);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back1"]];
    [imageView addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
    }];
    
    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(15);
        make.centerY.equalTo(imageView.mas_top).offset(44);
    }];

    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

}

// 获取PK列表
- (void)startRequestPKlist {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:[self configStringWithType] forKey:@"timeType"];
    [dict setObject:@(1) forKey:@"page"];
    [dict setObject:@(1000) forKey:@"size"];

    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetGroupLoseWeightPKListRequest" taskParam:dict TaskObserver:self];
    
}

- (NSString *)configStringWithType {
    if (self.selectType == HMGroupWeightPKTimeType_thirtyDays) {
        return @"30";
    }
    else {
        return @"15";
    }
}

#pragma mark - event Response
- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectType == HMGroupWeightPKTimeType_thirtyDays) {
        return self.thirtyDataList.count;
    }
    else {
        return self.fifteenDataList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMSetpPKMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMSetpPKMainTableViewCell at_identifier]];
    if (self.selectType == HMGroupWeightPKTimeType_thirtyDays) {
        [cell fillLoseWeightDataWithModel:self.thirtyDataList[indexPath.row] ranking:indexPath.row + 1];
    }
    else {
        [cell fillLoseWeightDataWithModel:self.fifteenDataList[indexPath.row] ranking:indexPath.row + 1];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    HMConsultingRecordsModel *model = self.dataList[indexPath.row];
    //    HMStaffNavTitleHistoryChatViewController *VC = [[HMStaffNavTitleHistoryChatViewController alloc] initWithHMConsultingRecordsModel:model];
    //
    //    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无瘦身结果" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"ic_default"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    NSArray *dataList = @[];
    if (self.selectType == HMGroupWeightPKTimeType_thirtyDays) {
        dataList = self.thirtyDataList;
    }
    else {
        dataList = self.fifteenDataList;
    }
    
    if (!dataList ||dataList.count == 0) {
        return YES;
    }
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
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMGetGroupLoseWeightPKListRequest"]) {
        [self at_hideLoading];
        if (self.selectType == HMGroupWeightPKTimeType_thirtyDays) {
            self.thirtyDataList = taskResult;
            self.isThirtyRequested = YES;
        }
        else {
            self.fifteenDataList = taskResult;
            self.isFifteenRequested =  YES;
        }
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
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [_tableView setRowHeight:70];
        [_tableView registerClass:[HMSetpPKMainTableViewCell class] forCellReuseIdentifier:[HMSetpPKMainTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}

- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT, ScreenWidth, 45) titelArr:@[@"近30天瘦身结果",@"近15天瘦身结果"] tagArr:@[@(0),@(1)] titelSelectedJWColor:[UIColor colorWithHexString:@"333333"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"333333" alpha:0.5] lineJWColor:[UIColor mainThemeColor] backJWColor:[UIColor whiteColor] lineWidth:125 block:^(NSInteger selectedTag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (selectedTag) {
                // 15
                strongSelf.selectType = HMGroupWeightPKTimeType_fifteenDays;
                if (!strongSelf.isFifteenRequested) {
                    [strongSelf startRequestPKlist];
                }
                else {
                    [strongSelf.tableView reloadData];
                }
            }
            else {
                // 30
                strongSelf.selectType = HMGroupWeightPKTimeType_thirtyDays;
                if (!strongSelf.isThirtyRequested) {
                    [strongSelf startRequestPKlist];
                }
                else {
                    [strongSelf.tableView reloadData];
                }
            }
            
            
        }];
    }
    return _segmentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
