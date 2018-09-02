//
//  HMSuperviseDetialViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/7/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseDetialViewController.h"
#import "HMSuperviseChartView.h"
#import "CoordinationFilterView.h"
#import "HMSuperviseDetailModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HMSuperviseEachPointModel.h"
#import "PEFResultModel.h"

#define TOPVIEWHEIGHT  (125 - 64)
#define CHARTWIDTH      (ScreenWidth)
#define CHARTHEIGHT    (ScreenHeight - 64 - TOPVIEWHEIGHT)
#define PAGESIZE       30
@interface HMSuperviseDetialViewController ()<CoordinationFilterViewDelegate,TaskObserver>

@property (nonatomic, strong)  CoordinationFilterView  *filterView; //
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) HMSuperviseChartView *chartView;  // 图表
@property (nonatomic, copy) NSString *kpiCode;
@property (nonatomic, strong) UIImageView *rightArrowView;
@property (nonatomic, strong) UILabel *rightTielLb;
@property (nonatomic, strong) UILabel *subTitelOneLb;
@property (nonatomic, strong) UILabel *subTitelTwoLb;
@property (nonatomic, strong) UIButton *toTestBtn;

@end

@implementation HMSuperviseDetialViewController

- (instancetype)initWithKpiCode:(NSString *)kpiCode {
    if (self = [super init]) {
        self.kpiCode = kpiCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    // 禁用滑动返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    [self configTitel];
    
    [self configElements];
    
    [self refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"UPLOADTESTSUCCESSED" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TOPVIEWHEIGHT - 142);
        make.height.equalTo(@142);
    }];
    
    [self.view addSubview:self.chartView];
    
    [self.topView addSubview:self.subTitelOneLb];
    [self.topView addSubview:self.subTitelTwoLb];
    [self.topView addSubview:self.toTestBtn];
    
    [self.toTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView).offset(-20);
        make.right.equalTo(self.topView).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@85);
    }];
    
    [self.subTitelOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.bottom.equalTo(self.toTestBtn.mas_centerY).offset(-5);
        make.right.lessThanOrEqualTo(self.toTestBtn.mas_left).offset(-5);
    }];
    
    [self.subTitelTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.top.equalTo(self.toTestBtn.mas_centerY).offset(3);
        make.right.lessThanOrEqualTo(self.toTestBtn.mas_left).offset(-5);
    }];

}

- (void)configTitel {
    NSString *typeString = self.kpiCode;
    if ([typeString isEqualToString:@"XY"]) {
        // 血压
        [self setTitle:@"血压"];
    }
    else if ([typeString isEqualToString:@"XT"]) {
        // 血糖
        [self setTitle:@"血糖"];
        
    }
    else if ([typeString isEqualToString:@"HX"]) {
        // 呼吸
        [self setTitle:@"呼吸"];
    }
    else if ([typeString isEqualToString:@"NL"]) {
        // 尿量
        [self setTitle:@"尿量"];
       
    }
    else if ([typeString isEqualToString:@"TZ"]) {
        // 体重
        [self setTitle:@"体重"];
        
    }
    else if ([typeString isEqualToString:@"OXY"]) {
        // 血氧
        [self setTitle:@"血氧"];
       
    }
    else if ([typeString isEqualToString:@"XL"]) {
        // 心率
        [self setTitle:@"心率"];
       
    }
    else if ([typeString isEqualToString:@"TEM"]) {
        // 体温
        [self setTitle:@"体温"];
        
    }
    else if ([typeString isEqualToString:@"FLSZ"]) {
        // 体温
        [self setTitle:@"呼气峰流速值"];
        
    }
    else {
        [self setTitle:@"详情"];
    }
    
    
    self.rightArrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_sanjiao_close"]];
    self.rightTielLb = [UILabel new];
    [self.rightTielLb setText:@"默认值"];
    [self.rightTielLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    [self.rightTielLb setFont:[UIFont systemFontOfSize:16]];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 25)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTwoClick)];
    [backView addGestureRecognizer:tap];
    
    [backView addSubview:self.rightTielLb];
    [backView addSubview:self.rightArrowView];
    
    [self.rightTielLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.centerY.equalTo(backView);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.centerY.equalTo(backView);
    }];
    
    
    UIBarButtonItem *rightBtnOne = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_shuju"] style:UIBarButtonItemStylePlain target:self action:@selector(rightOneClick)];
    
    UIBarButtonItem *rightBtnTwo = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [self.navigationItem setRightBarButtonItems:@[rightBtnTwo,rightBtnOne]];
    
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
        //心率
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

- (void)startGetTrendDtailDataRequest {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dicPost setValue:self.kpiCode forKey:@"kpiCode"];
    [dicPost setValue:[self acquireTimeFrom] forKey:@"timeForm"];
    [dicPost setValue:@(self.chartView.page) forKey:@"page"];
    [dicPost setValue:@(PAGESIZE) forKey:@"size"];

    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetDiagramDataRequest" taskParam:dicPost TaskObserver:self];
}

- (void)startRequestTodayFlsz {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    NSDate *date = [NSDate date];
    NSString *timeStr = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    [dicPost setValue:@(timeStr.integerValue * 1000) forKey:@"timeStamp"];

    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetTodayFLSZRequest" taskParam:dicPost TaskObserver:self];
    
}
- (NSString *)acquireTimeFrom {
    NSString *titel = @"";
    
    switch (self.chartView.selectedScreening) {
        case SESuperviseScreening_Default:
        {
            titel = @"dtime";
            break;
        }
        case SESuperviseScreening_Day:
        {
            titel = @"davg";
            
            break;
        }
        case SESuperviseScreening_Week:
        {
            titel = @"wavg";
            
            break;
        }
        case SESuperviseScreening_Month:
        {
            titel = @"mavg";
            
            break;
        }
    }
    
    return titel;
            
            /*每日次数 dtime
             日平均 davg
             周平均 wavg
             月平均 mavg
             {
             "userId": "10614",
             "kpiCode": "XY",
             "timeForm":"dtime",
             "page": 1,
             "size": 8
             }
             */

}

- (void)configTopViewWithHistory:(PEFResultModel *)model {
    if ([self.kpiCode isEqualToString:@"XY"]) {
        
        [self.subTitelOneLb setText:@"控压目标(mmHg)"];
        [self.subTitelTwoLb setText:@"高压 90-140   低压 60-90"];
    }
    else if ([self.kpiCode isEqualToString:@"XL"]) {
        [self.subTitelOneLb setText:@"心率目标(次/分)"];
        [self.subTitelTwoLb setText:@"60-100"];
    }
    else if ([self.kpiCode isEqualToString:@"TZ"]) {
        [self.subTitelOneLb setText:@"体重目标(kg/m²)"];
        [self.subTitelTwoLb setText:@"BMI=18.5-23.9"];
    }
    else if ([self.kpiCode isEqualToString:@"OXY"]) {
        [self.subTitelOneLb setText:@"血氧目标(%)"];
        [self.subTitelTwoLb setText:@"90-100"];
    }
    else if ([self.kpiCode isEqualToString:@"TEM"]) {
        [self.subTitelOneLb setText:@"体温目标(℃)"];
        [self.subTitelTwoLb setText:@"36.0-37.2"];
    }
    else if ([self.kpiCode isEqualToString:@"NL"]) {
        [self.subTitelOneLb setText:@"尿量目标(ml)"];
        [self.subTitelTwoLb setText:@"日 0-2000 夜 0-2000"];

    }
    else if ([self.kpiCode isEqualToString:@"XT"]) {
        [self.subTitelOneLb setText:@"控糖目标(mmol/L)"];
        [self.subTitelTwoLb setText:@"餐后:3.9-7.8 餐前:3.9-6.1"];
    }
    else if ([self.kpiCode isEqualToString:@"HX"]) {
        [self.subTitelOneLb setText:@"呼吸目标(次/分)"];
        [self.subTitelTwoLb setText:@"12-20"];
    }
    else if ([self.kpiCode isEqualToString:@"FLSZ"]) {
        if (model) {
            if (model.variationRate && model.variationRate.length) {
                [self.subTitelOneLb setText:[NSString stringWithFormat:@"今日日间变异率 %@",model.variationRate]];

            }
            else {
                [self.subTitelOneLb setText:[NSString stringWithFormat:@"今日日间变异率 未知"]];

            }
            
            [self.subTitelTwoLb setText:[NSString stringWithFormat:@"历史最高值 %@(L/min)",model.maxOfHistory]];
        }
    }
}

- (void)refreshData {
    self.chartView.page = 1;
    if ([self.kpiCode isEqualToString:@"FLSZ"]) {
        // 峰流速值先请求日间变异率
        [self startRequestTodayFlsz];
    }
    else {
        [self startGetTrendDtailDataRequest];
    }
}
#pragma mark - event Response
- (void)rightOneClick {
    UserInfo* targetUser = [[UserInfo alloc]init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    
    if ([self.kpiCode isEqualToString:@"XT"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarRecordsStartViewController" ControllerObject:targetUser];
    }
    else if ([self.kpiCode isEqualToString:@"OXY"]) {
         [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenationRecordStartViewController" ControllerObject:targetUser];
    }
    else if ([self.kpiCode isEqualToString:@"XY"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureRecordStartViewController" ControllerObject:targetUser];
    }
    else if ([self.kpiCode isEqualToString:@"TEM"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectsRecordsStartViewController" ControllerObject:targetUser];

    }
    else if ([self.kpiCode isEqualToString:@"TZ"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightRecordsStartViewController" ControllerObject:targetUser];

    }
    else if ([self.kpiCode isEqualToString:@"HX"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingRecordsStartViewController" ControllerObject:targetUser];
    }
    else if ([self.kpiCode isEqualToString:@"XL"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectRecordStartViewController" ControllerObject:targetUser];
    }
    else if ([self.kpiCode isEqualToString:@"FLSZ"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"PEFRecordsStartViewController" ControllerObject:targetUser];

    }
    else if ([self.kpiCode isEqualToString:@"NL"]) {
        [HMViewControllerManager createViewControllerWithControllerName:@"UrineVolumeRecordsStartViewController" ControllerObject:targetUser];

    }
}

- (void)rightTwoClick {
    if (self.isLoading || self.chartView.collectionView.decelerating) {
        return;
    }
    
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-5);
        }];
        [self.rightArrowView setImage:[UIImage imageNamed:@"img_sanjiao_open"]];
    }
    else {
        [self.filterView removeFromSuperview];
        [self.rightArrowView setImage:[UIImage imageNamed:@"img_sanjiao_close"]];
        _filterView = nil;
    }

}
- (void)toTestClick {
        [self targetValueDashboardClicked:self.kpiCode];
}
#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    if (self.chartView.selectedScreening == tag) {
        return;
    }
    self.chartView.selectedScreening = tag;
    NSString *titel = @"";
    switch (tag) {
        case SESuperviseScreening_Default:
        {
            titel = @"默认值";
            break;
        }
        case SESuperviseScreening_Day:
        {
            titel = @"日均值";

            break;
        }
        case SESuperviseScreening_Week:
        {
            titel = @"周均值";

            break;
        }
        case SESuperviseScreening_Month:
        {
            titel = @"月均值";

            break;
        }
    }
    [self.rightTielLb setText:titel];
    self.chartView.page = 1;
    [self startGetTrendDtailDataRequest];
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
            [self.chartView addDataWithDataList:dataList maxTarget:[dict[@"max"] floatValue] minTarget:[dict[@"min"] floatValue]];
            if (self.chartView.page == 1) {
                [self configTopViewWithHistory:nil];
            }
            self.chartView.page++;
        }
        else {
            [self showAlertMessage:@"没有更多数据了"];
        }
        
    }
    else if ([taskname isEqualToString:@"HMGetTodayFLSZRequest"]) {
        // 峰流速值今日日间变异率
        PEFResultModel *model = (PEFResultModel *)taskResult;
        [self configTopViewWithHistory:model];
        [self startGetTrendDtailDataRequest];
    }
    
}


#pragma mark - init
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 142)];
        [_topView setBackgroundColor:[UIColor mainThemeColor]];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395"] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        gradientLayer.locations = @[@0.1, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, 142);
        [_topView.layer addSublayer:gradientLayer];
    }
    return _topView;
}

- (HMSuperviseChartView *)chartView {
    if (!_chartView) {
        _chartView = [[HMSuperviseChartView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT,CHARTWIDTH , CHARTHEIGHT) kpiCode:self.kpiCode];
        __weak typeof(self) weakSelf = self;
        [_chartView addNextPageAction:^{
            [weakSelf startGetTrendDtailDataRequest];
        }];
    }
    return _chartView;
}
- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        NSArray *titelArr = @[];
        NSArray *tagArr = @[];
        if ([self.kpiCode isEqualToString:@"NL"]) {
            // 尿量不显示日均
            titelArr = @[@"默认值",@"周均值",@"月均值"];
            tagArr = @[@(SESuperviseScreening_Default),@(SESuperviseScreening_Week),@(SESuperviseScreening_Month)];
        }
        else if ([self.kpiCode isEqualToString:@"FLSZ"]) {
            // 峰流速值不显示 周均 月均
            titelArr = @[@"默认值",@"日均值"];
            tagArr = @[@(SESuperviseScreening_Default),@(SESuperviseScreening_Day)];
        }
        else {
            titelArr = @[@"默认值",@"日均值",@"周均值",@"月均值"];
            tagArr = @[@(SESuperviseScreening_Default),@(SESuperviseScreening_Day),@(SESuperviseScreening_Week),@(SESuperviseScreening_Month)];
        }
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"",@"",@"",@""] titles:titelArr tags:tagArr];
        
        [_filterView setSelectedRow:@(SESuperviseScreening_Default)];
        self.chartView.selectedScreening = SESuperviseScreening_Default;
        _filterView.delegate = self;
        __weak typeof(self) weakSelf = self;
        [_filterView removeAction:^{
            [weakSelf.rightArrowView setImage:[UIImage imageNamed:@"img_sanjiao_close"]];
        }];
    }
    return _filterView;
}


- (UILabel *)subTitelOneLb {
    if (!_subTitelOneLb) {
        _subTitelOneLb = [UILabel new];
        [_subTitelOneLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_subTitelOneLb setFont:[UIFont systemFontOfSize:14]];
        [_subTitelOneLb setText:@"测试字样"];
    }
    return _subTitelOneLb;
}

- (UILabel *)subTitelTwoLb {
    if (!_subTitelTwoLb) {
        _subTitelTwoLb = [UILabel new];
        [_subTitelTwoLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_subTitelTwoLb setFont:[UIFont systemFontOfSize:14]];
        [_subTitelTwoLb setText:@"测试字样"];
    }
    return _subTitelTwoLb;
}

- (UIButton *)toTestBtn {
    if (!_toTestBtn) {
        _toTestBtn = [[UIButton alloc] init];
        [_toTestBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_toTestBtn setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:0.2]];
        [_toTestBtn setTitle:@"去测量" forState:UIControlStateNormal];
        [_toTestBtn.layer setCornerRadius:15];
        [_toTestBtn.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_toTestBtn.layer setBorderWidth:0.5];
        [_toTestBtn addTarget:self action:@selector(toTestClick) forControlEvents:UIControlEventTouchUpInside];
        [_toTestBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _toTestBtn;
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
