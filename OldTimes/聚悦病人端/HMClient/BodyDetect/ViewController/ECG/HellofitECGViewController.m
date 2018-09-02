//
//  HellofitECGViewController.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HellofitECGViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BluetoothDeviceControl.h"
#import "HellofitECGBLEDevice.h"


@interface HellofitECGViewController ()<BluetoothControlDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    BluetoothDeviceControl *bleControl;
    UIButton *measureButton;
    UIImageView *deviceImg;
    
    BOOL isResult;
}
@end

@implementation HellofitECGViewController

- (void)dealloc
{
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    
    //主动断开连接
    [bleControl disConnectPeripheral];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initWithHomePage];
}

- (void)initWithHomePage
{
    homePageView = [[BloodPressureDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"xinlv_shenti_body"];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

- (void) createDeviceObject
{
    
    if (!bleControl)
    {
        bleControl = [[HellofitECGBLEDevice alloc] init];
    }
    bleControl.delegate = self;
    [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
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
                    [measureButton setTitle:@"请开启蓝牙" forState:UIControlStateNormal];
                }
                    break;
                    
                case CentralManager_PoweredON:
                {
                    [bleControl connectPeripheralsTimeout:30];
                    [measureButton setTitle:@"获取设备中……" forState:UIControlStateNormal];
                }
                    break;
                    
                case CentralManager_ConnectSussess:
                {
                    [measureButton setTitle:@"开始测量" forState:UIControlStateNormal];
                    [measureButton addTarget:self action:@selector(buttonStateChange:) forControlEvents:UIControlEventTouchUpInside];
                    [measureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [measureButton setBackgroundColor:[UIColor mainThemeColor]];
                }
                    break;
                    
                case CentralManager_Disconnect:
                {
                    if (isResult)
                    {
                        return;
                    }
                    [self showAlertMessage:@"设备连接断开"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)buttonStateChange:(UIButton *)sender
{
    [measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
    
    //请求发送数据
    //[bleControl writeDate:[self dataByteHexString:@"FF0403010000"]];
}

-(void)stopSendECGData
{
    isResult = YES;
    //停止发送数据
    //[bleControl writeDate:[self dataByteHexString:@"FF0403000000"]];
    [measureButton setTitle:@"测量完成" forState:UIControlStateNormal];
    [measureButton.layer setBorderWidth:1.0];
    measureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    measureButton.backgroundColor = [UIColor whiteColor];
    [measureButton setEnabled:NO];
    
    //HFdiagnoseAlgorithm *demo = [[HFdiagnoseAlgorithm alloc]init];
    
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
