//
//  BreathingDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingDetectResultViewController.h"
#import "BreathingResultValueView.h"
#import "BreathingResultView.h"
#import "DetectSymptomResultView.h"
#import "CommonResultDetectTimeView.h"

@interface BreathingDetectResultViewController ()
{
    BreathingResultValueView* retValueView;
    BreathingResultView* retView;
    DetectSymptomResultView *symptomView;
}
@property (nonatomic,strong) CommonResultDetectTimeView *detectTimeView;
@end

@implementation BreathingDetectResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];

    retValueView = [[BreathingResultValueView alloc]init];
    [self.view addSubview:retValueView];
    
    retView = [[BreathingResultView alloc]init];
    [self.view addSubview:retView];
    
    symptomView = [[DetectSymptomResultView alloc] init];
    [self.view addSubview:symptomView];
    [symptomView setHidden:YES];
    
    [self.detectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [self subviewLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) resultTaskName
{
    return @"BreathingDetectResultTask";
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!detectResult || 0 == detectResult.userId) {
        return;
    }
    [targetUser setUserId:detectResult.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BreathingRecordsStartViewController" ControllerObject:targetUser];
}

- (void) subviewLayout
{
    [retValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_detectTimeView.mas_bottom).offset(5);
        make.height.mas_equalTo(@144);
    }];
    
    [retView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(retValueView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@95);
    }];
    
    [symptomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(retView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@200);
    }];
}

- (void) detectResultLoaded:(DetectResult*) result
{
    BreathingDetctResult* breathResult = (BreathingDetctResult*) result;
    [retValueView setDetectResult:breathResult];
    [retView setDetectResult:breathResult];
    [self.detectTimeView setDetectResult:detectResult];
    
    if (!kStringIsEmpty(breathResult.symptom))
    {
        [symptomView setHidden:NO];
        [symptomView setDetectResult:breathResult];
        
        CGFloat resultheight = [symptomView.contentLabel.text heightSystemFont:symptomView.contentLabel.font width:symptomView.contentLabel.width];
        
        [symptomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(resultheight + 50);
        }];
    }
}

- (CommonResultDetectTimeView*) detectTimeView
{
    if (!_detectTimeView) {
        _detectTimeView = [[CommonResultDetectTimeView alloc] init];
        [_detectTimeView showBottomLine];
        [self.view addSubview:_detectTimeView];
    }
    return _detectTimeView;
}

@end
