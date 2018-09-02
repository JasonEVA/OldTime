//
//  DetectInputBaseViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/8/9.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DetectInputBaseViewController.h"
#import "DeviceTestTimeSelectView.h"

@interface DetectInputBaseViewController ()<UIScrollViewDelegate>
{
    DeviceTestTimeSelectView *testTimeView;
}
@end

@implementation DetectInputBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    // 设置元素控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.testTimeControl];
    [self.scrollView addSubview:self.saveButton];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.testTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45 * kScreenScale);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 46));
        make.top.equalTo(self.testTimeControl.mas_bottom).with.offset(30);
    }];
}

#pragma mark - Private Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
}

- (void)checkForOnce {
    if (self.comPickerView) {
        [self.comPickerView removeFromSuperview];
        self.comPickerView = nil;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)createAlertFrame:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(kPickerViewHeight);
    }];
}
#pragma mark - eventRespond
- (void)testTimeControlClick
{
    if (self.comPickerView && self.comPickerView == testTimeView) {
        return;
    }
    [self checkForOnce];
    if (self.excTime && 0 < self.excTime.length) {
        return;
    }
    testTimeView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerView = testTimeView;
    [self.view addSubview:testTimeView];
    [self createAlertFrame:testTimeView];
    __weak typeof(DeviceTestTimeControl) *controlSelf = _testTimeControl;
    __weak typeof(self) weakSelf = self;
    [testTimeView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *tempStr = [format stringFromDate:selectedTime];
        [controlSelf.lbtestTime setText:tempStr];
        weakSelf.testDate = selectedTime;
    }];
    [testTimeView setDate:self.testDate?:[NSDate date]];
    
}

- (void)saveDatabuttonClick{
    
}

#pragma mark -- init
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor commonBackgroundColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (DeviceTestTimeControl *)testTimeControl{
    if (!_testTimeControl) {
        _testTimeControl = [[DeviceTestTimeControl alloc] init];
        [_testTimeControl setArrowHide:YES];
        [_testTimeControl addTarget:self action:@selector(testTimeControlClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.excTime && 0 < self.excTime.length) {
            NSDate* excDate = [NSDate dateWithString:self.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateStr = [excDate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
            [_testTimeControl.lbtestTime setText:dateStr];
        }
    }
    return _testTimeControl;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton new];
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton.layer setMasksToBounds:YES];
        [_saveButton.layer setCornerRadius:5.0];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont: [UIFont font_30]];
        [_saveButton setBackgroundColor:[UIColor mainThemeColor] ];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveDatabuttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
