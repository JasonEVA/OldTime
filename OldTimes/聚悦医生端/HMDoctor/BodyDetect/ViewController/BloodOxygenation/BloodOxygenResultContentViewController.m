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
}

@end

@implementation BloodOxygenResultContentViewController


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
    
    testView = [[CommonResultDetectTimeView alloc] init];
    [self.view addSubview:testView];
    
    resultView = [[BloodOxygenResultView alloc] init];
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
    
    [suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(resultView.mas_bottom).with.offset(5);
        
    }];
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!detectResult || 0 == detectResult.userId) {
        return;
    }
    [targetUser setUserId:detectResult.userId];
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
    [suggestView setDetectResult:boxyResult];
    
}
@end
