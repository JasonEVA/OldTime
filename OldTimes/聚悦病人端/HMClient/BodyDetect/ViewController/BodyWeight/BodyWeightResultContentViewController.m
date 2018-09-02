//
//  BodyWeightResultContentViewController.m
//  HMClient
//
//  Created by lkl on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightResultContentViewController.h"
#import "BodyWeightResultDetectTimeView.h"
#import "BodyWeightResultView.h"
#import "BodyWeightSuggestView.h"

@interface BodyWeightResultContentViewController ()
{
    BodyWeightResultDetectTimeView* timeview; //测试时间
    BodyWeightResultView* resultview;         //检测结果
    BodyWeightSuggestView* suggestionview;    //检测结果
    DetectAlertInterrogationControl* interrogationControl;
    
    NSInteger surveyId;
    NSString* surveyModuleName;
}
@end

@implementation BodyWeightResultContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    timeview = [[BodyWeightResultDetectTimeView alloc]init];
    [self.view addSubview:timeview];

    resultview = [[BodyWeightResultView alloc]init];
    [self.view addSubview:resultview];
    
    interrogationControl = [[DetectAlertInterrogationControl alloc]init];
    [self.view addSubview:interrogationControl];
    [interrogationControl setHidden:YES];
    [interrogationControl addTarget:self action:@selector(interrogationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    suggestionview = [[BodyWeightSuggestView alloc]init];
    [self.view addSubview:suggestionview];
    
    [self subviewLayout];
    
}

- (NSString*) resultTaskName
{
    return @"BodyWeightDetectResultTask";
}


- (void) subviewLayout
{
    [timeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [resultview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@175);
        make.top.equalTo(timeview.mas_bottom).with.offset(5);
    }];
    
    
    [interrogationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(resultview.mas_bottom).with.offset(5);
        make.height.mas_equalTo(45);
    }];
    
    [suggestionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(resultview.mas_bottom).with.offset(5);
        
    }];
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
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightRecordsStartViewController" ControllerObject:targetUser];
}

- (void) interrogationControlClicked:(id) sender
{
    SurveyRecord *record = [[SurveyRecord alloc]init];
    
    [record setSurveyId:[NSString stringWithFormat:@"%ld", surveyId]];
    [record setSurveyMoudleName:surveyModuleName];
    [record setUserId:[NSString stringWithFormat:@"%ld", userId]];
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}


- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    BodyWeightDetectResult* weightResult = (BodyWeightDetectResult*)result;
    [timeview setDetectResult:weightResult];
    
    [resultview setDetectResult:weightResult];
    
    if (0 < weightResult.surveyId && weightResult.surveyMoudleName && 0 < weightResult.surveyMoudleName.length)
    {
        surveyId = weightResult.surveyId;
        userId = weightResult.userId;
        surveyModuleName = weightResult.surveyMoudleName;
        [interrogationControl setHidden:NO];
        [interrogationControl setSurveyModuleName:weightResult.surveyMoudleName];
        
        [suggestionview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(interrogationControl.mas_bottom).with.offset(5);
            
            
        }];
    }
    [suggestionview setDetectResult:weightResult];
}

@end
