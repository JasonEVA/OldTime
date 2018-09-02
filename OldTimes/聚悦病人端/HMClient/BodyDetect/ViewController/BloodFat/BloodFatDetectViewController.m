//
//  BloodFatDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatDetectViewController.h"
#import "CommonDeviceDetectHomePageView.h"
#import "BluetoothDeviceControl.h"
#import "BloodFatBLEDevice.h"

@interface BloodFatDetectViewController ()
{
    CommonDeviceDetectHomePageView *homePageView;
    CommonDeviceDetectHomePageView *detectLayoutView;
    
    BluetoothDeviceControl *bleControl;
}
@end

@implementation BloodFatDetectViewController

- (void)dealloc
{
    [bleControl removeObserver:self forKeyPath:@"devicesState"];
    [bleControl removeObserver:self forKeyPath:@"bloodFatResult"];
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
    homePageView = [[CommonDeviceDetectHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"pic_xuezhi_ceshi_01"];
    [homePageView.button setHidden:YES];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    //更新约束
    [homePageView bloodFatUpdateConstraints];
}

- (void)initWithDetectLayoutView
{
    [homePageView removeFromSuperview];
    
    detectLayoutView = [[CommonDeviceDetectHomePageView alloc] init];
    [self.view addSubview:detectLayoutView];

    [detectLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    //更新约束
    [detectLayoutView detectLayoutUpdateConstraints];
    [detectLayoutView bloodFatdetectLayoutUpdateConstraints];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDeviceObject
{
    if (!bleControl)
    {
        bleControl = [[BloodFatBLEDevice alloc] init];
    }
    [bleControl addObserver:self forKeyPath:@"devicesState" options:NSKeyValueObservingOptionNew context:nil];
    [bleControl addObserver:self forKeyPath:@"bloodFatResult" options:NSKeyValueObservingOptionNew context:nil];
    
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
                    break;
                }
                    
                case CentralManager_Disconnect:
                {
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
                    
                default:
                    break;
            }
        }
    }
    
    if([keyPath isEqualToString:@"bloodFatResult"])
    {
        NSDictionary *dicBloodFat = [object valueForKey:@"bloodFatResult"];
        if (dicBloodFat && [dicBloodFat isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary* dicParams = [NSMutableDictionary dictionaryWithDictionary:dicBloodFat];
            
            NSMutableDictionary* dicDetectResult = [NSMutableDictionary dictionary];
            [dicDetectResult setValue:@"XZ" forKey:@"kpiCode"];
            [dicDetectResult setValue:dicParams forKey:@"testValue"];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dicParams setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
            
            [self postDetectResult:dicDetectResult];
        }
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
