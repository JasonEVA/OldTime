//
//  U80LHBloodPressureViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "U80LHBloodPressureViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BloodPresureDeviceDetectLayoutView.h"
#import "BluetoothDeviceControl.h"
#import "U80LHBloodPressureBLEDevice.h"
#import "BloodPressureThreeDetectViewController.h"

@interface U80LHBloodPressureViewController ()<BloodPressureBluetoothControlResultDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    BloodPresureDeviceDetectLayoutView *detectLayoutView;
    BluetoothDeviceControl  *bleControl;

    BOOL isResult;
    BOOL isDefualt;
}
@property (nonatomic, assign) BOOL isThriceDetect;

@end

@implementation U80LHBloodPressureViewController

- (void) dealloc
{
    [bleControl removeObserver:self forKeyPath:@"diaRecord"];
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    [bleControl removeObserver:self forKeyPath:@"pressureResult"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
    
    [self createDeviceObject];

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
    homePageView = [[BloodPressureDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"pic_xueya_ceshi_03"];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

- (void)initWithDetectLayoutView
{
    [homePageView removeFromSuperview];
    
    detectLayoutView = [[BloodPresureDeviceDetectLayoutView alloc] init];
    [self.view addSubview:detectLayoutView];
    
    [detectLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Method
- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XYJ_YRN"];
}

- (void) createDeviceObject
{
    if (!bleControl)
    {
        bleControl = [[U80LHBloodPressureBLEDevice alloc] init];
    }
    
    [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
    [bleControl addObserver:self forKeyPath:@"diaRecord" options:NSKeyValueObservingOptionNew context:nil];
    [bleControl addObserver:self forKeyPath:@"pressureResult" options:NSKeyValueObservingOptionNew context:nil];
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
                    [homePageView setRemindContent:@"请开启手机蓝牙"];
                    break;
                }
                    
                case CentralManager_PoweredON:
                {
                    [homePageView setRemindContent:@"请打开设备开关"];
                    [homePageView startBluetoothConnectAnimationPlay];
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
                    [self initWithDetectLayoutView];
                    [detectLayoutView.measureButton addTarget:self action:@selector(buttonStateChange) forControlEvents:UIControlEventTouchUpInside];
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
                    
                case Measurement_Results:
                {
                    isResult = YES;
                    [detectLayoutView.measureButton setTitle:@"开始" forState:UIControlStateNormal];
                    [detectLayoutView setHeartValue:@"0"];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    
    //测量中
    if ([keyPath isEqualToString:@"diaRecord"])
    {
        id value = [object valueForKey:keyPath];
        if (value && [value isKindOfClass:[NSString class]])
        {
            NSString* str = (NSString*)value;
            
            [detectLayoutView setHeartValue:str];
        }
        
        if (![detectLayoutView.heartImage.layer animationForKey:@"animationGroup"])
        {
            [detectLayoutView setHeartImageAnimationPlay];
        }
        
    }else
    {
        if ([detectLayoutView.heartImage.layer animationForKey:@"animationGroup"])
        {
            [detectLayoutView.heartImage.layer removeAnimationForKey:@"animationGroup"];
        }
    }
    
    //获取到测量结果
    if ([keyPath isEqualToString:@"pressureResult"])
    {
        NSDictionary *dicPressure = [object valueForKey:@"pressureResult"];
        if (dicPressure && [dicPressure isKindOfClass:[NSDictionary class]])
        {
            isResult = YES;
            
//            NSMutableDictionary* dicValue = [NSMutableDictionary dictionaryWithDictionary:dicPressure];
//            
//            NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
//            
//            [dicDetectResult setValue:@"XY" forKey:@"kpiCode"];
//            [dicDetectResult setValue:dicValue forKey:@"testValue"];
//            
//            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
//            
//            [self setDetectResult:dicDetectResult];
            
            NSMutableDictionary* dicValue = [NSMutableDictionary dictionaryWithDictionary:dicPressure];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dicValue setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
            
            [dicValue setValue:@"2" forKey:@"inputMode"];

            //如果是设备监测，则下次测量默认为设备监测
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"0" forKey:@"XYManualInputTpye"];
            [userDefaults synchronize];
            
            NSArray *vcs = self.navigationController.viewControllers;
            [vcs enumerateObjectsUsingBlock:^(HMBasePageViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([vc isKindOfClass:[BloodPressureThreeDetectViewController class]] && [vcs[vcs.count-2] isKindOfClass:[BloodPressureThreeDetectViewController class]]) {
                    _isThriceDetect = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:BloodPressureDetectResultNotify object:nil userInfo:dicValue];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
            }];
            
            if (!_isThriceDetect) {
                
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureThreeDetectViewController" ControllerObject:dicValue];
            }
        }
    }
}

- (void)buttonStateChange
{
    [detectLayoutView.measureButton setTitle:@"测量中……" forState:UIControlStateNormal];
    [detectLayoutView.measureButton setEnabled:NO];
    //给蓝牙发指令（写数据）
    Byte byte[] = {0xFD,0xFD,0xFA,0x05,0X0D, 0x0A};
    
    NSData *data = [[NSData alloc] initWithBytes:byte length:6];
    
    [bleControl writeDate:data];
}

#pragma mark --BloodPressureBluetoothControlResultDelegate

- (void)measureBloodPressureError:(float)value
{
    switch ((int)value)
    {
        case 14:
            [self showAlertMessage:@"EEPROM异常"];
            break;
        case 1:
            [self showAlertMessage:@"人体心跳信号太小或压力突降"];
            break;
        case 2:
            [self showAlertMessage:@"杂讯干扰"];
            break;
        case 3:
            [self showAlertMessage:@"充气时间过长"];
            break;
        case 5:
            [self showAlertMessage:@"测得的结果异常"];
            break;
        case 12:
            [self showAlertMessage:(@"校正异常 ")];
            break;
        case 11:
            [self showAlertMessage:@"电源低电压"];
            break;
            
        default:
            break;
    }
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
