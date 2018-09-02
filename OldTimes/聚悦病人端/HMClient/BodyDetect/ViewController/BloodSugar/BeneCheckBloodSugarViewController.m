//
//  BeneCheckBloodSugarViewController.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BeneCheckBloodSugarViewController.h"
#import "BloodSugarDeviceHomePageView.h"
#import "BluetoothDeviceControl.h"
#import "BeneCheckBloodSugarBLEDevice.h"
#import "BloodSugarDetectTestPeriodViewController.h"

@interface BeneCheckBloodSugarViewController ()
{
    BloodSugarDeviceHomePageView *homePageView;
    BluetoothDeviceControl *bleControl;
    
    BOOL isResult;
    
    NSString *testPeriodCode;
}
@end

@implementation BeneCheckBloodSugarViewController

- (void)dealloc
{
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    [bleControl removeObserver:self forKeyPath:@"bloodSugarResult"];
}

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
        [bleControl disConnectPeripheral];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (bleControl && bleControl.devicesState != CentralManager_PoweredOFF){
        [bleControl connectPeripheralsTimeout:30];
    }
}

#pragma mark -- init
- (void)initWithHomePage
{
    homePageView = [[BloodSugarDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImage:@"xuetang_ceshi_bg12"];
    [homePageView.measureButton setTitle:@"获取设备中……" forState:UIControlStateNormal];
    [homePageView.testPeriodControl addTarget:self action:@selector(testPeriodControlClicked) forControlEvents:UIControlEventTouchUpInside];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
}

#pragma mark -- Method
- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XTY_BJ"];
}

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
        [self createDeviceObject];
    }];
}

- (void) createDeviceObject
{
    
    if (!bleControl)
    {
        bleControl = [[BeneCheckBloodSugarBLEDevice alloc] init];
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
                    [homePageView.measureButton setTitle:@"请开启蓝牙" forState:UIControlStateNormal];
                    break;
                }
                    
                case CentralManager_PoweredON:
                {
                    [homePageView.measureButton setTitle:@"连接中……" forState:UIControlStateNormal];
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
                    [homePageView.measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
                    
                    [homePageView setDeviceImage:@"xuetang_ceshi_bg13"];
                    
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
                    isResult = YES;
                    [homePageView.measureButton setTitle:@"获取设备中" forState:UIControlStateNormal];
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
        if (dicBloodSugar && [dicBloodSugar isKindOfClass:[NSDictionary class]])
        {
            
            NSString *bloodSugarValue = [dicBloodSugar valueForKey:@"XT_SUB"];
            NSDictionary *BloodSugarDic = [NSMutableDictionary dictionary];
            CGFloat temp = bloodSugarValue.floatValue;
            NSString *onePointBloodSugarValue = [NSString stringWithFormat:@"%.1f",temp];
            [BloodSugarDic setValue:onePointBloodSugarValue forKey:testPeriodCode];
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
