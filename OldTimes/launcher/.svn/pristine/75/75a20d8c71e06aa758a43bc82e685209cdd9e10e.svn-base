//
//  ATStaticViewController.m
//  Clock
//
//  Created by Dariel on 16/7/26.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATStaticViewController.h"
#import "ATStatisticsView.h"
#import "ATStatisticsViewAdapter.h"
#import "ATStaticRequest.h"
#import "ATStaticContentModel.h"
#import "ATStaticOutsideDetailRequest.h"
#import "ATStaticOutSideDetailView.h"
#import "ATStaticViewCell.h"
#import "ATStaticOutsideDetailRequest.h"
#import "DQAlertView.h"

#import "ATSharedMacro.h"
#import "UIColor+ATHex.h"
static const CGFloat staticHeadHeight = 215.0f;
static const CGFloat navgationBarHeight = 64.0f;


@interface ATStaticViewController ()<ATStatisticsViewDelegate, ATHttpRequestDelegate, ATStatisticsViewDelegate, ATStatisticsViewAdapterDelegate>

@property (nonatomic, strong) ATStatisticsView *statisticsView;
@property (nonatomic, strong) ATStatisticsViewAdapter *statisticsAdapter;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) ATStaticOutSideDetailView *staticOutSideView;

@end

@implementation ATStaticViewController

- (ATStatisticsView *)statisticsView {
    if (!_statisticsView) {
        _statisticsView = [[ATStatisticsView alloc] initWithFrame:self.view.bounds];
        self.statisticsAdapter = [[ATStatisticsViewAdapter alloc] init];
        [_statisticsView setTableViewAdapter:self.statisticsAdapter];
        
        self.statisticsAdapter.delegate = self;
        _statisticsView.delegate = self;
    }
    
    return _statisticsView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.statisticsView;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"统计";
    self.currentDate = [NSDate date];

    [self getDataSourceFromServer:self.currentDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleDefault;
}


- (void)getDataSourceFromServer:(NSDate *) date {
    
    // 获取年月
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM";
    NSString *timeString = [fmt stringFromDate:date];
    
    // 获取月份天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger numberOfDaysInMonth = range.length;
    
    ATStaticRequest *req = [[ATStaticRequest alloc] init];
    req.userId = self.userId;
    req.startTime = [NSString stringWithFormat:@"%@-01 00:00:00", timeString];
    req.endTime = [NSString stringWithFormat:@"%@-%ld 23:59:59",timeString, numberOfDaysInMonth];
    req.orgId = self.orgId;
    
    [self postLoading:@"加载统计数据"];
    [req requestWithDelegate:self];
}


- (void)loadStaticDataSource:(ATStaticContentModel *)dataSource {
    
    
    self.statisticsAdapter.adapterArray = [NSMutableArray arrayWithArray:dataSource.List];
    self.statisticsView.normalLabelNum.text = [NSString stringWithFormat:@"%ld",(long)dataSource.Normal];
    self.statisticsView.unnormalLabelNum.text = [NSString stringWithFormat:@"%ld",(long)dataSource.Abnormal];
    
    if (dataSource.List.count == 0) {
        
        [self showNoContentWarningView:CGRectMake(0, staticHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT-staticHeadHeight - navgationBarHeight)];
        
        
        
    }else {
        [self hideNoContentWarningView];
    }
    
    [self.statisticsView refreshTableView];
    
}


- (void)loadstaticOutSideDataSource:(NSArray *)staticOutsideModels {

    // 1条数据高度 100
    // 2         220
    // 3         300
    CGFloat staticOutSideViewHeight;
    if (staticOutsideModels.count == 1) {
        staticOutSideViewHeight = 100;
    }else if (staticOutsideModels.count == 2){
        staticOutSideViewHeight = 220;
    }else {
        staticOutSideViewHeight = 300;
    }
    
    self.staticOutSideView = [[ATStaticOutSideDetailView alloc] initWithFrame:CGRectMake(0, 0, 265, staticOutSideViewHeight)];
    
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:@"外出详细" message:nil cancelButtonTitle:@"关闭" otherButtonTitle:nil];
    alertView.backgroundColor = [UIColor whiteColor];
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:20];
    alertView.titleLabel.textColor = [UIColor at_blueColor];
    alertView.messageView = self.staticOutSideView;
    alertView.messageViewHeight = staticOutSideViewHeight;
    alertView.messageBottomPadding = 0.0;
    [alertView.cancelButton setTitleColor:[UIColor at_blackColor] forState:UIControlStateNormal];
    alertView.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    alertView.titleBottomPadding = 10;
    
    [alertView show];
    
    self.staticOutSideView.staticOutSideModels = staticOutsideModels;
    [self.staticOutSideView.detailTableView reloadData];
}


#pragma mark - ATHttpRequestDelegate

- (void)requestSucceed:(ATHttpBaseRequest *)request withResponse:(ATHttpBaseResponse *)response
{
    [self hideLoading];
    
   if ([response isKindOfClass:[ATStaticResponse class]]) {
        ATStaticResponse *rsp = (ATStaticResponse *)response;
        [self loadStaticDataSource:rsp.dataSource];
    }
    
    if ([response isKindOfClass:[ATStaticOutsideDetailResponse class]]) {
        ATStaticOutsideDetailResponse *rsp = (ATStaticOutsideDetailResponse *)response;
        [self loadstaticOutSideDataSource:rsp.dataSource];
    }
}



#pragma mark - ATStatisticsViewDelegate
- (void)changeDate:(UILabel *)dateLabel isAddMouth:(BOOL)isAdd nextButton:(UIButton *)nextButton{
    
    NSDate *lastDate = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月";
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calender components:(NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay ) fromDate:self.currentDate];
    
    if (isAdd) { // 增加
        
        [cmp setMonth:[cmp month] + 1];
        NSDate *lastMonDate = [calender dateFromComponents:cmp];
        self.currentDate = lastMonDate;
        [self getDataSourceFromServer:self.currentDate];
        NSString *string = [fmt stringFromDate:lastMonDate];
        dateLabel.text = string;
        
    }else { // 减少
        [cmp setMonth:[cmp month] - 1];
        NSDate *lastMonDate = [calender dateFromComponents:cmp];
        self.currentDate = lastMonDate;
        [self getDataSourceFromServer:self.currentDate];
        NSString *string = [fmt stringFromDate:lastMonDate];
        dateLabel.text = string;
    }
    
    if ([[fmt stringFromDate:lastDate] isEqualToString:[fmt stringFromDate:self.currentDate]]) {
        nextButton.hidden = YES;
    }else {
        nextButton.hidden = NO;
    }
}


#pragma mark - ATStatisticsViewAdapterDelegate
- (void)sendDateForRequest:(double)date staticViewCell:(ATStaticViewCell *)cell {
    
    NSDate *workTime=[NSDate dateWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *timeString = [fmt stringFromDate:workTime];
    
    ATStaticOutsideDetailRequest *req = [[ATStaticOutsideDetailRequest alloc] init];
    req.userId = self.userId;
    req.startTime = [NSString stringWithFormat:@"%@ 00:00:00", timeString];
    req.endTime = [NSString stringWithFormat:@"%@ 23:59:59",timeString];
    req.orgId = self.orgId;
    
    [self postLoading:@"加载外出详情数据"];
    [req requestWithDelegate:self];
}

@end
