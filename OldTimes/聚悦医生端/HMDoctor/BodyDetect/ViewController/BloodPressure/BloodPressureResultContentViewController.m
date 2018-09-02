//
//  BloodPressureResultContentViewController.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureResultContentViewController.h"
#import "BloodPressureDetectTimeView.h"
#import "BloodPressureResultView.h"
#import "BloodPressureInquiryChartControl.h"
#import "BloodPressureResultHealthGuideView.h"
#import "BloodPressureDetectRecord.h"
#import "BloodPressureThriceDetectResultView.h"

@interface BloodPressureResultContentViewController ()
{
    UIScrollView *scrollView;
    
    BloodPressureDetectTimeView *testView;
    BloodPressureResultView *resultView;
    BloodPressureInquiryChartControl *inquiryChartControl;
    BloodPressureResultHealthGuideView *healthAssessView;
    BloodPressureResultHealthGuideView *healthSuggestView;
    BloodPressureThriceDetectResultView *thriceDetectView;
    BloodPressureThriceDetectDataListView *dataListView;
    
    NSInteger surveyId;
    
    NSString* surveyModuleName;
}

@end

@implementation BloodPressureResultContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIButton *historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [historybutton setTitle:@"历史数据" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    testView = [[BloodPressureDetectTimeView alloc] init];
    [scrollView addSubview:testView];
    
    resultView = [[BloodPressureResultView alloc] init];
    [scrollView addSubview:resultView];
    
    inquiryChartControl = [[BloodPressureInquiryChartControl alloc] init];
    [scrollView addSubview:inquiryChartControl];
    [inquiryChartControl addTarget:self action:@selector(inquiryChartControlClick) forControlEvents:UIControlEventTouchUpInside];
    [inquiryChartControl setHidden:YES];
    
    healthAssessView = [[BloodPressureResultHealthGuideView alloc] init];
    [scrollView addSubview:healthAssessView];
    [healthAssessView setTitle:@"健康评估"];
    
    healthSuggestView = [[BloodPressureResultHealthGuideView alloc] init];
    [scrollView addSubview:healthSuggestView];
    [healthSuggestView setTitle:@"健康建议"];
    
    thriceDetectView = [[BloodPressureThriceDetectResultView alloc] init];
    [scrollView addSubview:thriceDetectView];
    
    dataListView = [[BloodPressureThriceDetectDataListView alloc] init];
    [scrollView addSubview:dataListView];
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(scrollView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(70);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(testView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(277);
    }];
    
    [thriceDetectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(resultView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(105);
    }];
    
    [dataListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(thriceDetectView.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
    
    [inquiryChartControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(dataListView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(45);
    }];
    
    [healthAssessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(dataListView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(80);
    }];
    
    [healthSuggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(healthAssessView.mas_bottom);
        make.height.mas_equalTo(80);
    }];
    
}

- (NSString*) resultTaskName
{
    return @"BloodPressureDetectResultTask";
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (userId)
    {
        [targetUser setUserId:userId];
    }
    else
    {
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [targetUser setUserId:curUser.userId];
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureRecordStartViewController" ControllerObject:targetUser];
}

- (void)inquiryChartControlClick
{
    //跳转到问诊表
    SurveyRecord *record = [[SurveyRecord alloc]init];
    
    
    [record setSurveyId:[NSString stringWithFormat:@"%ld", surveyId]];
    [record setSurveyMoudleName:surveyModuleName];
    [record setUserId:userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    BloodPressureDetectResult* bpResult = (BloodPressureDetectResult*)result;
    
    [testView setDetectResult:bpResult];
    [resultView setDetectResult:bpResult];
    [thriceDetectView setDetectResult:bpResult];
    [dataListView setDetectResult:bpResult];
    
    [healthAssessView setValueString:bpResult.userAlertResult];
    [healthSuggestView setValueString:bpResult.userHealthySuggest];
    
    [scrollView setScrollEnabled:YES];
    
    //更新布局
    float dataListViewHeight = bpResult.xyTestDataVoList.count * 40;
    [dataListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40 + dataListViewHeight);
    }];
    
    CGFloat width = kScreenWidth - 25;
    CGFloat textHeight = [bpResult.userHealthySuggest heightSystemFont:[UIFont font_26] width:width];
    [healthSuggestView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight+55);
    }];
    
    [scrollView setContentSize:CGSizeMake(self.view.width, healthSuggestView.top+dataListViewHeight+textHeight+55)];
    
    if (0 < bpResult.surveyId && bpResult.surveyMoudleName && 0 < bpResult.surveyMoudleName.length)
    {
        surveyId = bpResult.surveyId;
        userId = bpResult.userId;
        surveyModuleName = bpResult.surveyMoudleName;
        [inquiryChartControl setHidden:NO];
        [inquiryChartControl setSurveyModuleName:bpResult.surveyMoudleName];
        
        [healthAssessView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(inquiryChartControl.mas_bottom).with.offset(5);
            make.height.mas_equalTo(80);
        }];
        [scrollView setContentSize:CGSizeMake(self.view.width, healthSuggestView.top+dataListViewHeight+textHeight+55+45)];
    }

}

@end
