//
//  OnetouchUltraEasyBloodSugarViewController.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OnetouchUltraEasyBloodSugarViewController.h"
#import "BloodSugarDeviceHomePageView.h"
#import "OnetouchUItraEasyBloodSugarBLEDevice.h"
#import "BloodSugarDetectTestPeriodViewController.h"

@interface OnetouchUltraEasyBloodSugarViewController ()
{
    BloodSugarDeviceHomePageView *homePageView;
 
    OnetouchUItraEasyBloodSugarBLEDevice *bleControl;
    
    BOOL isResult;
    
    NSString *testPeriodCode;
}
@end

@implementation OnetouchUltraEasyBloodSugarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithHomePage];
    
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

#pragma mark -- init
- (void)initWithHomePage
{
    homePageView = [[BloodSugarDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImage:@"xuetang_ceshi_bg10"];
    [homePageView setRemindContent:@"请插入蓝牙模块"];
    [homePageView.measureButton setTitle:@"获取设备中……" forState:UIControlStateNormal];
    [homePageView.testPeriodControl addTarget:self action:@selector(testPeriodControlClicked) forControlEvents:UIControlEventTouchUpInside];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

#pragma mark -- Method
- (void)testPeriodControlClicked
{
    [BloodSugarDetectTestPeriodViewController createWithParentViewController:self isDevice:YES selectblock:^(NSDictionary *testPeriodItem) {
        
        if (kDictIsEmpty(testPeriodItem))
        {
            [self showAlertMessage:@"必须选择时段，才能进行测试。"];
            return;
        }
        
        testPeriodCode = [testPeriodItem valueForKey:@"code"];
        [homePageView setTestPeriodSelect:[testPeriodItem valueForKey:@"name"]];
        
        bleControl = [[OnetouchUItraEasyBloodSugarBLEDevice alloc] initWithDelegate:self];
    }];
}

- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XTY_QS"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --  JYBluetoothManagerDelegate
- (void)currentCentralManagerStatus:(BLEStatus)status{
    switch (status) {
        case BLEStatePoweredOff:
        {
            [homePageView.measureButton setTitle:@"请开启蓝牙" forState:UIControlStateNormal];
            break;
        }
            
        case BLEStatePoweredOn:
        {
            [homePageView.measureButton setTitle:@"连接中……" forState:UIControlStateNormal];
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
    [homePageView setDeviceImage:@"xuetang_ceshi_bg11"];
    [homePageView setRemindContent:@"请使用血糖仪进行测试"];
    [homePageView.measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
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

#pragma mark --
- (void)detectBloodSugarValue:(NSMutableDictionary *)valueDic{
    isResult = YES;
    
    if (kDictIsEmpty(valueDic)) {
        return;
    }
    //血糖值
    NSString *bloodSugarValue = [valueDic valueForKey:@"XT_SUB"];
    NSString *uniqueTestGid = [valueDic valueForKey:@"uniqueTestGid"];
    
    NSString *onePointBloodSugarValue = [NSString stringWithFormat:@"%.1f",bloodSugarValue.floatValue];
    NSDictionary *BloodSugarDic = [NSMutableDictionary dictionary];
    [BloodSugarDic setValue:onePointBloodSugarValue forKey:testPeriodCode];
        
    NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
    [dicDetectResult setValue:uniqueTestGid forKey:@"uniqueTestGid"];
    [dicDetectResult setValue:@"XT" forKey:@"kpiCode"];
    
    [dicDetectResult setValue:BloodSugarDic forKey:@"testValue"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [self setDetectResult:dicDetectResult];
}

@end
