//
//  ECGDetectResultContentViewController.m
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGDetectResultContentViewController.h"
#import "ECGDetectTimeView.h"
#import "ECGResultValueView.h"
#import "ECGResultView.h"
#import "HeartRateDetectRecord.h"
#import "DetailECGViewController.h"

@interface ECGDetectResultContentViewController ()
{
    ECGDetectTimeView *testView;
    ECGResultValueView *resultValueView;
    ECGResultView *resultView;
    
    HeartRateDetectResult* hrResult;
}
@property (nonatomic, assign) BOOL isXD;  //是否心电
@end

@implementation ECGDetectResultContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if ([detectRecord.kpiCode isEqualToString:@"XD"]) {
        self.isXD = YES;
    }
    
    if (self.paramObject && [self.paramObject isKindOfClass:[HeartRateDetectRecord class]]) {
        HeartRateDetectRecord* hrRecord = (HeartRateDetectRecord *)self.paramObject;
        if ([hrRecord.kpiCode isEqualToString:@"XD"]) {
            self.isXD = YES;
        }
    }
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    testView = [[ECGDetectTimeView alloc] init];
    [self.view addSubview:testView];
    
    resultValueView = [[ECGResultValueView alloc] init];
    [self.view addSubview:resultValueView];
    
    resultView = [[ECGResultView alloc] init];
    [self.view addSubview:resultView];
    [resultView.detailBtn setHidden:!self.isXD];
    [resultView.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self subviewLayout];
}

- (NSString*) resultTaskName
{
    return @"HeartRateDetectResultTask";
//    if (self.isXD) {
//        return @"ECGDetectResultTask";
//    }
//    else{
//        return @"HeartRateDetectResultTask";
//    }
//    return nil;
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
    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectRecordStartViewController" ControllerObject:targetUser];
}

- (void) subviewLayout
{
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [resultValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(testView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@144);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(resultValueView.mas_bottom).with.offset(5);
    }];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    hrResult = (HeartRateDetectResult*) result;
    if (self.isXD) {
        hrResult.isXD = YES;
    }
    [testView setDetectResult:hrResult];
    [resultValueView setDetectResult:hrResult];
    [resultView setDetectResult:hrResult];
}

//进入详细心电图界面
- (void)detailBtnClick
{
    //[HMViewControllerManager createViewControllerWithControllerName:@"DetailECGViewController" ControllerObject:hrResult];
    
    DetailECGViewController *detail = [[DetailECGViewController alloc] init];
    [detail detectResultLoaded:hrResult];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
