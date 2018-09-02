//
//  HMStepHistoryViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepHistoryViewController.h"
#import "JWSegmentView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HMStepHistoryTopView.h"
#import "HMStepHistoryTableViewCell.h"
#import "HMGroupPKEnum.h"
#import "HMStepHistoryModel.h"

#define SEGMENTVIEWHEIGHT   45
#define TOPVIEW             (SEGMENTVIEWHEIGHT + 64)
#define REQUESTSIZE         30
@interface HMStepHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) JWSegmentView *segmentView;
@property (nonatomic, strong) HMStepHistoryTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HMStepHistoryModel *selectModel;
@end

@implementation HMStepHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [self setFd_prefersNavigationBarHidden:YES];
    [self configElements];
    
    self.topView.page = 1;
    self.topView.selectedType = HMGroupPKScreening_Day;
    
    [self startRequestStepHistorylist];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK_im_back1"]];
    [topView setUserInteractionEnabled:YES];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@TOPVIEW);
        make.top.left.right.equalTo(self.view);
    }];
    
    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.centerY.equalTo(topView.mas_top).offset(44);
    }];
    
    UILabel *titelLb = [UILabel new];
    [titelLb setText:@"步数记录"];
    [titelLb setFont:[UIFont boldFont_36]];
    [titelLb setTextColor:[UIColor whiteColor]];
    [topView addSubview:titelLb];
    [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.centerY.equalTo(popBtn);
    }];
    
    [topView addSubview:self.segmentView];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}

// 获取数据
- (void)startRequestStepHistorylist {

    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:@(self.topView.page) forKey:@"page"];
    [dict setObject:@(REQUESTSIZE) forKey:@"size"];
    [dict setObject:[self acquireTimeFrom] forKey:@"timeStage"];
    [self at_postLoading];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetStepHistoryRequest" taskParam:dict TaskObserver:self];
    
}

- (NSString *)acquireTimeFrom {
    NSString *titel = @"";
    
    switch (self.topView.selectedType) {
        case HMGroupPKScreening_Day:
        {
            titel = @"day";
            break;
        }
        case HMGroupPKScreening_Week:
        {
            titel = @"weak";
            
            break;
        }
        case HMGroupPKScreening_Month:
        {
            titel = @"month";
            
            break;
        }
       
    }
    
    return titel;
    
    // timeStagetuple = ('day', 'weak', 'month')
    
}

#pragma mark - event Response
- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Delegate



#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   HMStepHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMStepHistoryTableViewCell at_identifier]];
    [cell fillDataWithModel:self.selectModel cellType:indexPath.row PKScreening:self.topView.selectedType];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
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
    [self at_hideLoading];

    if ([taskname isEqualToString:@"HMGetStepHistoryRequest"]) {
        NSArray *temp = (NSArray *)taskResult;
        if (!temp ||![temp isKindOfClass:[NSArray class]]) {
            return;
        }
        if (temp.count) {
            [self.topView addDataWithArray:temp requstSize:REQUESTSIZE];
            self.topView.page ++;
        }
        else {
            [self showAlertMessage:@"没有更多数据了"];
            [self.topView addEmptyData];
        }
    }
    
}

#pragma mark - Interface

#pragma mark - init UI
- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0, TOPVIEW - SEGMENTVIEWHEIGHT, ScreenWidth, SEGMENTVIEWHEIGHT) titelArr:@[@"日",@"周",@"月"] tagArr:@[@(HMGroupPKScreening_Day),@(HMGroupPKScreening_Week),@(HMGroupPKScreening_Month)] titelSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"ffffff" alpha:0.5] lineJWColor:[UIColor colorWithHexString:@"fffffff"] backJWColor:[UIColor clearColor] lineWidth:60 block:^(NSInteger selectedTag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.topView.selectedType = selectedTag;
            strongSelf.topView.page = 1;
            [strongSelf startRequestStepHistorylist];
            
        }];
    }
    return _segmentView;
}

- (HMStepHistoryTopView *)topView {
    if (!_topView) {
        _topView = [[HMStepHistoryTopView alloc] initWithFrame:CGRectMake(0, TOPVIEW, ScreenWidth, (220 * (ScreenWidth / 375)) + 140)];
        __weak typeof(self) weakSelf = self;
        [_topView addNextPageAction:^{
            [weakSelf startRequestStepHistorylist];
        }];
        
        [_topView configTable:^(HMStepHistoryModel *HMStepHistoryModel) {
            weakSelf.selectModel = HMStepHistoryModel;
            [weakSelf.tableView reloadData];
        }];
        
        [_topView scrollCallBack:^(BOOL isScrolling) {
            weakSelf.segmentView.isDisable = isScrolling;
        }];
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:45];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView registerClass:[HMStepHistoryTableViewCell class] forCellReuseIdentifier:[HMStepHistoryTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];

    }
    return _tableView;
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
