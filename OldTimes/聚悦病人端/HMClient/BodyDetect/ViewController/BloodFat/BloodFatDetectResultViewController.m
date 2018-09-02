//
//  BloodFatDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatDetectResultViewController.h"
#import "BloodFatDetectTimeView.h"
#import "BloodFatResultValueView.h"
#import "BloodFatRecord.h"

@interface BloodFatDetectResultViewController ()
{
    BloodFatDetectTimeView* timeview;
    
    BloodFatResultValueView* tcValueView;
    BloodFatResultValueView* tgValueView;
    BloodFatResultValueView* hdlcValueView;
    BloodFatResultValueView* ldlcValueView;
    
    BloodFatResultValueView* divValueView;
}
@end

@implementation BloodFatDetectResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    [self createDetectResultView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectRecordsStartViewController" ControllerObject:targetUser];
}

- (NSString*) resultTaskName
{
    return @"BloodFatDetectResultTask";
}

- (void) createDetectResultView
{
    timeview = [[BloodFatDetectTimeView alloc]init];
    [self.view addSubview:timeview];
    
    tgValueView = [[BloodFatResultValueView alloc]initWithName:@"甘油三酯" ExtName:@"(TG)"];
    [self.view addSubview:tgValueView];
    tcValueView = [[BloodFatResultValueView alloc]initWithName:@"甘油固醇" ExtName:@"(TC)"];
    [self.view addSubview:tcValueView];
    hdlcValueView = [[BloodFatResultValueView alloc]initWithName:@"高密度脂蛋白固醇" ExtName:@"(HDL-C)"];
    [self.view addSubview:hdlcValueView];
    ldlcValueView = [[BloodFatResultValueView alloc]initWithName:@"低密度脂蛋白固醇" ExtName:@"(LDL-C)"];
    [self.view addSubview:ldlcValueView];
    
    divValueView = [[BloodFatResultValueView alloc]initWithName:@"TC/HDL-C" ExtName:nil];
    [self.view addSubview:divValueView];
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    [timeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [tgValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(timeview.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@60);
    }];
    
    [tcValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(tgValueView.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
    
    [hdlcValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(tcValueView.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
    
    [ldlcValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(hdlcValueView.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
    
    [divValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(ldlcValueView.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    BloodFatResult* bfResult = (BloodFatResult*)result;
    [timeview setDetectResult:bfResult];

    [tgValueView setResultValue:bfResult.dataDets.TG];
    [tcValueView setResultValue:bfResult.dataDets.TC];
    [hdlcValueView setResultValue:bfResult.dataDets.HDL_C];
    [ldlcValueView setResultValue:bfResult.dataDets.LDL_C];
    [divValueView setResultValue:bfResult.dataDets.TC_DIVISION_HDL_C];
}
@end
