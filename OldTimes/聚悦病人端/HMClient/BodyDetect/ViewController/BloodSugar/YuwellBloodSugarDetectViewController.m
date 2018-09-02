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
    BluetoothDeviceControl *bleControl;
    NSString *testPeriodCode;
    BOOL isResult;
}
@property (nonatomic, readonly) BloodSugarDeviceHomePageView* homePageView;
@end

@implementation YuwellBloodSugarDetectViewController
@synthesize homePageView = _homePageView;

- (void)dealloc
{
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    [bleControl removeObserver:self forKeyPath:@"bloodSugarResult"];
}

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
        [bleControl disConnectPeripheral];
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
        [self createDeviceObject];
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

#pragma mark - BLE
- (void) createDeviceObject
{
    if (!bleControl)
    {
        bleControl = [[YuwellBloodSugarBleDeviceControl alloc] init];
        
        [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
        [bleControl addObserver:self forKeyPath:@"bloodSugarResult" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [bleControl controlSetup];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"devicesState"])
    {
        id value = [object valueForKey:keyPath];
        if (value && [value isKindOfClass:[NSNumber class]])
        {
            NSNumber* numValue = (NSNumber*)value;
            switch (numValue.intValue)
            {
                case CentralManager_PoweredOFF:
                {
                    [self.homePageView.measureButton setTitle:@"请开启蓝牙" forState:UIControlStateNormal];
                    break;
                }
                    
                case CentralManager_PoweredON:
                {
                    [self.homePageView setRemindContent:@"请插入血糖试纸"];
                    [self.homePageView.measureButton setTitle:@"连接中……" forState:UIControlStateNormal];
                    [bleControl connectPeripheralsTimeout:30];
                    
                    break;
                }
                    
                case CentralManager_ConnectTimeOut:
                {
                    [self showAlertMessage:@"设备连接超时，您可以手动上传数据,或者重新测量" clicked:^{
                        if (self.navigationController) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }];
                    
                    break;
                }
                    
                case CentralManager_ConnectSussess:
                {
                    [self.homePageView.measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
                    [_homePageView setRemindContent:@""];
                    [self.homePageView setDeviceImage:@"xuetang_ceshi_bg15"];
                    
                    break;
                }
                    
                case CentralManager_Disconnect:
                {
                    if (isResult)
                    {
                        return;
                    }
                    if (!self.isAppear) {
                        return;
                    }
                    [self showAlertMessage:@"设备连接断开" clicked:^{
                        
                        if (self.navigationController) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }];
                    break;
                }
                    
                case Measurement_Results: //测量错误
                {
//                    isResult = YES;
                    [self.homePageView setRemindContent:@"请插入血糖试纸"];
                    [self.homePageView.measureButton setTitle:@"获取设备中" forState:UIControlStateNormal];
                    [self showAlertMessage:@"测量错误，请重新测量" clicked:^{
                        if (bleControl && bleControl.devicesState != CentralManager_PoweredOFF){
                            [bleControl connectPeripheralsTimeout:30];
                        }
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    if([keyPath isEqualToString:@"bloodSugarResult"])
    {
        isResult = YES;
        
        //血糖值
        NSDictionary *dicBloodSugar = [object valueForKey:@"bloodSugarResult"];
        
        NSString *bloodSugarValue = [dicBloodSugar valueForKey:@"XT_SUB"];
        NSDictionary *BloodSugarDic = [NSMutableDictionary dictionary];
        CGFloat temp = bloodSugarValue.floatValue;
        NSString *onePointBloodSugarValue = [NSString stringWithFormat:@"%.1f",temp];
        [BloodSugarDic setValue:onePointBloodSugarValue forKey:testPeriodCode];
        
        
        if (dicBloodSugar && [dicBloodSugar isKindOfClass:[NSDictionary class]])
        {
            
            NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
            [dicDetectResult setValue:@"XT" forKey:@"kpiCode"];
            
            [dicDetectResult setValue:BloodSugarDic forKey:@"testValue"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
            
            [self setDetectResult:dicDetectResult];
        }
    }

}

@end
