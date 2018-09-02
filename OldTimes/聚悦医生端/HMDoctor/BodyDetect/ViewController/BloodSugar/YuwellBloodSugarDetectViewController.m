//
//  YuwellBloodSugarDetectViewController.m
//  HMClient
//
//  Created by yinquan on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "YuwellBloodSugarDetectViewController.h"
#import "BloodSugarDeviceHomePageView.h"
#import "BloodSugarDetectTestPeriodViewController.h"
#import "YuwellBloodSugarBleDeviceControl.h"

@interface YuwellBloodSugarDetectViewController ()
{
    YuwellBloodSugarBleDeviceControl *bleControl;
    NSString *testPeriodCode;
    BOOL isResult;
}
@property (nonatomic, readonly) BloodSugarDeviceHomePageView* homePageView;
@end

@implementation YuwellBloodSugarDetectViewController
@synthesize homePageView = _homePageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self homePageView];
    
    //弹出血糖测量时段选择控件
    [self testPeriodControlClicked];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if (bleControl) {
        //停止扫描并断开连接
        [bleControl stopScanning];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (bleControl && bleControl.currentCentralManagerState == BLEStatePoweredOn){
        [bleControl startScanning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) testPeriodControlClicked
{
    [BloodSugarDetectTestPeriodViewController createWithParentViewController:self isDevice:YES selectblock:^(NSDictionary *testPeriodItem) {
        
        if (kDictIsEmpty(testPeriodItem))
        {
            [self showAlertMessage:@"必须选择时段，才能进行测试。"];
            return;
        }
        
        testPeriodCode = [testPeriodItem valueForKey:@"code"];
        [self.homePageView setTestPeriodSelect:[testPeriodItem valueForKey:@"name"]];
        
        bleControl = [[YuwellBloodSugarBleDeviceControl alloc] initWithDelegate:self];
    }];
}

#pragma mark - settingAndGetting
- (BloodSugarDeviceHomePageView*) homePageView
{
    if (!_homePageView) {
        _homePageView = [[BloodSugarDeviceHomePageView alloc] init];
        [self.view addSubview:_homePageView];
        [_homePageView setDeviceImage:@"xuetang_ceshi_bg14"];
        [_homePageView setRemindContent:@"请插入血糖试纸"];
        [_homePageView.measureButton setTitle:@"获取设备中……" forState:UIControlStateNormal];
        [_homePageView.testPeriodControl addTarget:self action:@selector(testPeriodControlClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _homePageView;
}


#pragma mark --  JYBluetoothManagerDelegate
- (void)currentCentralManagerStatus:(BLEStatus)status{
    switch (status) {
        case BLEStatePoweredOff:
        {
            [self.homePageView.measureButton setTitle:@"请开启蓝牙" forState:UIControlStateNormal];
            break;
        }
            
        case BLEStatePoweredOn:
        {
            [self.homePageView setRemindContent:@"请插入血糖试纸"];
            [self.homePageView.measureButton setTitle:@"连接中……" forState:UIControlStateNormal];
            [bleControl startScanning];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 连接设备
- (void)bleConnectSuccess
{
    [self.homePageView.measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
    [_homePageView setRemindContent:@""];
    [self.homePageView setDeviceImage:@"xuetang_ceshi_bg15"];
}

- (void)bleConnectFailed
{
}

- (void)bleDisConnected
{
    if (isResult)
    {
        return;
    }
    if (!self.isAppear) {
        return;
    }
    [self showAlertMessage:@"设备连接断开" clicked:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)bleDeviceScanTimeOut{
    [self showAlertMessage:@"设备连接超时，您可以手动上传数据,或者重新测量" clicked:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark -- YuwellBloodBloodSugarBLEDelegate
- (void)detectBloodSugarValue:(float)value{
    isResult = YES;

    NSDictionary *BloodSugarDic = [NSMutableDictionary dictionary];
    NSString *onePointBloodSugarValue = [NSString stringWithFormat:@"%.1f",value];
    [BloodSugarDic setValue:onePointBloodSugarValue forKey:testPeriodCode];
    
    NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
    [dicDetectResult setValue:@"XT" forKey:@"kpiCode"];
    
    [dicDetectResult setValue:BloodSugarDic forKey:@"testValue"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [self setDetectResult:dicDetectResult];
}

@end
