//
//  BloodOxygenResultContentViewController.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenResultContentViewController.h"
#import "CommonResultDetectTimeView.h"
#import "BloodOxygenResultView.h"
#import "BloodOxygenSuggestView.h"
#import "BloodOxygenationRecord.h"

@interface BloodOxygenResultContentViewController ()
{
    CommonResultDetectTimeView *testView;
    BloodOxygenResultView *resultView;
    BloodOxygenSuggestView *suggestView;
    
    DetectAlertInterrogationControl* interrogationControl;
    
    NSInteger surveyId;
    NSString* surveyModuleName;
}

@end

@implementation BloodOxygenResultContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    testView = [[CommonResultDetectTimeView alloc] init];
    [self.view addSubview:testView];
    
    resultView = [[BloodOxygenResultView alloc] init];
    
    interrogationControl = [[DetectAlertInterrogationControl alloc]init];
    [interrogationControl addTarget:self action:@selector(interrogationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:interrogationControl];
    [interrogationControl setHidden:YES];
    
    [self.view addSubview:resultView];
    
    suggestView = [[BloodOxygenSuggestView alloc] init];
    [self.view addSubview:suggestView];
    
    [self subviewLayout];
}


- (NSString*) resultTaskName
{
    return @"BloodOxygenationDetectResultTask";
}


- (void) subviewLayout
{
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(175);
        make.top.equalTo(testView.mas_bottom).with.offset(5);
    }];
    
    [interrogationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(resultView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(45);
    }];

    
    [suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(resultView.mas_bottom).with.offset(5);
        
    }];
}

- (void) interrogationControlClicked:(id) sender
{
    SurveyRecord *record = [[SurveyRecord alloc]init];
    
    [record setSurveyId:[NSString stringWithFormat:@"%ld", surveyId]];
    [record setSurveyMoudleName:surveyModuleName];
    [record setUserId:[NSString stringWithFormat:@"%ld", userId]];
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
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
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenationRecordStartViewController" ControllerObject:targetUser];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    BloodOxygenationResult* boxyResult = (BloodOxygenationResult*)result;

    [testView setDetectResult:boxyResult];
    [resultView setDetectResult:boxyResult];
    
    if (0 < boxyResult.surveyId && boxyResult.surveyMoudleName && 0 < boxyResult.surveyMoudleName.length)
    {
        surveyId = boxyResult.surveyId;
        userId = boxyResult.userId;
        surveyModuleName = boxyResult.surveyMoudleName;
        [interrogationControl setHidden:NO];
        [interrogationControl setSurveyModuleName:boxyResult.surveyMoudleName];
        
        [suggestView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(interrogationControl.mas_bottom).with.offset(5);
            make.height.mas_equalTo(@95);
        }];
    }
    
    [suggestView setDetectResult:boxyResult];
    
}
@end
