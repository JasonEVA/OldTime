//
//  BodyTemperatureDetectResultViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/4/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyTemperatureDetectResultViewController.h"
#import "BodyTemperatureDetectResultInstructView.h"
#import "CommonResultDetectTimeView.h"
#import "BodyTemperatureDetectRecord.h"
#import "BodyTemperatureDetectResultView.h"
#import "DetectSymptomResultView.h"

@interface BodyTemperatureDetectResultViewController ()

@property (nonatomic, readonly) UIScrollView* scrollView;
@property (nonatomic, readonly) CommonResultDetectTimeView* detectTimeView;
@property (nonatomic, readonly) BodyTemperatureDetectResultInstructView* instructView;
@property (nonatomic, readonly) BodyTemperatureDetectResultView* resultViwe;
@property (nonatomic,strong)  DetectSymptomResultView *symptomView;

@end

@implementation BodyTemperatureDetectResultViewController

@synthesize scrollView = _scrollView;
@synthesize detectTimeView = _detectTimeView;
@synthesize instructView = _instructView;
@synthesize resultViwe = _resultViwe;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!detectResult || 0 == detectResult.userId) {
        return;
    }
    [targetUser setUserId:detectResult.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectsRecordsStartViewController" ControllerObject:targetUser];
}

- (void) viewDidLayoutSubviews
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.detectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [self.instructView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@50);
        make.height.mas_equalTo(@175);
    }];
    
    [self.resultViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.instructView.mas_bottom).with.offset(5);
        make.height.mas_greaterThanOrEqualTo(@65);
        //        make.height.mas_equalTo(@65);
    }];
    
    [self.symptomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.resultViwe.mas_bottom).offset(5);
        make.height.mas_greaterThanOrEqualTo(@65);
    }];
    
}

- (NSString*) resultTaskName
{
    return @"BodyTemperatureDetectResultTask";
}


- (void) detectResultLoaded:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    detectResult = result;
    BodyTemperatureDetectResult* temperatureResult = (BodyTemperatureDetectResult*)result;
    
    
    [self.instructView setTemperature:temperatureResult.temperature];
    [self.detectTimeView setDetectResult:detectResult];
    
    [self.resultViwe setUserAlertResult:temperatureResult.userAlertResult];
    
    if (!kStringIsEmpty(temperatureResult.symptom)) {
        [_symptomView setHidden:NO];
        [_symptomView setDetectResult:temperatureResult];
        
        CGFloat resultheight = [_symptomView.contentLabel.text heightSystemFont:_symptomView.contentLabel.font width:_symptomView.contentLabel.width];
        
        [_symptomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(resultheight + 50);
        }];
    }
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.resultViwe.bottom)];
}

#pragma mark - settingAndGetting
- (UIScrollView*) scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (CommonResultDetectTimeView*) detectTimeView
{
    if (!_detectTimeView) {
        _detectTimeView = [[CommonResultDetectTimeView alloc] init];
        [_detectTimeView showBottomLine];
        [self.scrollView addSubview:_detectTimeView];
    }
    return _detectTimeView;
}

- (BodyTemperatureDetectResultInstructView*) instructView
{
    if(!_instructView) {
        _instructView = [[BodyTemperatureDetectResultInstructView alloc] init];
        [self.scrollView addSubview:_instructView];
    }
    
    return _instructView;
}

- (BodyTemperatureDetectResultView*) resultViwe
{
    if (!_resultViwe) {
        _resultViwe = [[BodyTemperatureDetectResultView alloc] init];
        [self.scrollView addSubview:_resultViwe];
    }
    
    return _resultViwe;
}

- (DetectSymptomResultView *)symptomView{
    if (!_symptomView) {
        _symptomView = [[DetectSymptomResultView alloc] init];
        [self.scrollView addSubview:_symptomView];
        [_symptomView setHidden:YES];
    }
    return _symptomView;
}


@end
