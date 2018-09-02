//
//  BloodOxgenDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxgenDetectViewController.h"
#import "CommonDeviceDetectHomePageView.h"
#import "JYBluetoothManager.h"
#import "BerryMedBloodOxgenBLEDevice.h"
#import "BloodPressureDeviceHomePageView.h"

@interface BloodOxgenDetectViewController ()<BloodOxygenBLEResultDelegate,JYBluetoothManagerDelegate>
{
    CommonDeviceDetectHomePageView *homePageView;
    CommonDeviceDetectHomePageView *detectLayoutView;
    
    BerryMedBloodOxgenBLEDevice *bleControl;

    UILabel *lbSpO2Value;
    UILabel *lbPulseRateValue;
    
    UIButton *endButton;
}

@end

@implementation BloodOxgenDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
    
    bleControl = [[BerryMedBloodOxgenBLEDevice alloc] initWithDelegate:self];
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
    homePageView = [[CommonDeviceDetectHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"img_blood_ceshi_01"];
    [homePageView.button setHidden:YES];
//    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

- (void)initWithDetectLayoutView
{
    [homePageView removeFromSuperview];
    
    detectLayoutView = [[CommonDeviceDetectHomePageView alloc] init];
    [self.view addSubview:detectLayoutView];
//    [detectLayoutView hiddenGuideButton];
    [detectLayoutView setDeviceImg:@"img_blood_ceshi_02"];
    [detectLayoutView.bluetoothConnectIcon setHidden:YES];
    [detectLayoutView setRemindContent:@"将手指插入血氧仪中"];
    [detectLayoutView.button setBackgroundColor:[UIColor mainThemeColor]];
    [detectLayoutView.button addTarget:self action:@selector(measureBloodOxygen) forControlEvents:UIControlEventTouchUpInside];

    [detectLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    //更新约束
    [detectLayoutView detectLayoutUpdateConstraints];
}

#pragma mark -- Method
- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XYY_BR"];
}

- (void)measureBloodOxygen
{
    [detectLayoutView removeFromSuperview];
    
    UIView *bloodOxgenView = [[UIView alloc] init];
    [bloodOxgenView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bloodOxgenView];
    
    lbSpO2Value = [[UILabel alloc] init];
    [lbSpO2Value setText:@"--"];
    [lbSpO2Value setTextColor:[UIColor greenColor]];
    [lbSpO2Value setFont:[UIFont systemFontOfSize:30]];
    [lbSpO2Value setTextAlignment:NSTextAlignmentCenter];
    [bloodOxgenView addSubview:lbSpO2Value];
    
    UILabel *lbBloodOxygen = [[UILabel alloc] init];
    [lbBloodOxygen setText:@"血氧"];
    [lbBloodOxygen setTextAlignment:NSTextAlignmentCenter];
    [lbBloodOxygen setTextColor:[UIColor commonGrayTextColor]];
    [bloodOxgenView addSubview:lbBloodOxygen];
    
    lbPulseRateValue = [[UILabel alloc] init];
    [lbPulseRateValue setText:@"--"];
    [lbPulseRateValue setTextColor:[UIColor greenColor]];
    [lbPulseRateValue setFont:[UIFont systemFontOfSize:30]];
    [lbPulseRateValue setTextAlignment:NSTextAlignmentCenter];
    [bloodOxgenView addSubview:lbPulseRateValue];
    
    UILabel *lbPulseRate = [[UILabel alloc] init];
    [lbPulseRate setText:@"脉率"];
    [lbPulseRate setTextColor:[UIColor commonGrayTextColor]];
    [lbPulseRate setTextAlignment:NSTextAlignmentCenter];
    [lbBloodOxygen addSubview:lbPulseRate];
    
    UIView *vLineView = [[UIView alloc] init];
    [vLineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [bloodOxgenView addSubview:vLineView];
    
    UIView *hLineView = [[UIView alloc] init];
    [hLineView setBackgroundColor:[UIColor commonCuttingLineColor]];
    [bloodOxgenView addSubview:hLineView];
    
    endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endButton.layer setMasksToBounds:YES];
    [endButton.layer setCornerRadius:5.0];
    [endButton setTitle:@"结束" forState:UIControlStateNormal];
    [endButton setBackgroundColor:[UIColor mainThemeColor]];
    [endButton.titleLabel setFont: [UIFont font_30]];
    [endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:endButton];
    [endButton addTarget:self action:@selector(endButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bloodOxgenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    [lbSpO2Value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(bloodOxgenView);
        make.size.mas_equalTo(CGSizeMake(self.view.width/2,60));
    }];
    
    [lbBloodOxygen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbSpO2Value.mas_bottom).with.offset(10);
        make.left.mas_equalTo(bloodOxgenView);
        make.size.mas_equalTo(CGSizeMake(self.view.width/2,20));
    }];
    
    [lbPulseRateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSpO2Value.mas_top);
        make.left.equalTo(lbBloodOxygen.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.width/2, 60));
    }];
    
    
    [lbPulseRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbBloodOxygen.mas_top);
        make.left.equalTo(lbBloodOxygen.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.width/2, 20));
    }];
    
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bloodOxgenView).with.offset(10);
        make.center.equalTo(bloodOxgenView);
        make.bottom.equalTo(bloodOxgenView);
        make.width.mas_equalTo(1);
    }];
    
    [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bloodOxgenView.mas_bottom).with.offset(-1);
        make.left.equalTo(bloodOxgenView).with.offset(10);
        make.right.equalTo(bloodOxgenView).with.offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bloodOxgenView.mas_bottom).with.offset(40);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(45);
    }];
    
    //开始计时测量
    /*dispatch_async(dispatch_get_main_queue(), ^{
        
        [NSTimer scheduledscheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeProgress:) userInfo:nil repeats:YES];
    });*/
}

- (void)endButtonClicked:(UIButton *)sender
{
    [self stopMessure];
}

//测量未定
- (void)changeProgress:(NSTimer *)timer
{
    //progressView.progress += 0.1;
    
    //if (progressView.progress >= 1.0)
    //{
    
        [timer invalidate];
        
        [self stopMessure];
    //}
}

//停止测量，上传数据
- (void)stopMessure
{
    //NSLog(@"===%lu %lu %lu", (unsigned long)_SpO2Value,(unsigned long)_pulseRateValue,(unsigned long)_piValue);

     //_isResult = YES;
    [endButton setEnabled:NO];
    [endButton setBackgroundColor:[UIColor commonLightGrayTextColor]];
    
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicResult setValue:@"OXY" forKey:@"kpiCode"];
    
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_SpO2Value] forKey:@"OXY_SUB"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_pulseRateValue] forKey:@"PULSE_RATE"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_piValue] forKey:@"PI_VAL"];
    [dicResult setValue:dicValue forKey:@"testValue"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [self postDetectResult:dicResult];

}

#pragma mark --  JYBluetoothManagerDelegate
- (void)currentCentralManagerStatus:(BLEStatus)status{
    switch (status) {
        case BLEStatePoweredOff:
        {
            [homePageView setRemindContent:@"请开启手机蓝牙"];
            break;
        }
            
        case BLEStatePoweredOn:
        {
            [homePageView setRemindContent:@"请打开设备开关"];
            [bleControl startScanning];
            //[homePageView star];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 连接设备
- (void)bleConnectSuccess
{
    [self initWithDetectLayoutView];
}

- (void)bleConnectFailed
{
}

- (void)bleDisConnected
{
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


#pragma mark -- BloodOxygenBLEResultDelegate
-(void)didRefreshOximeterParams:(BMOximeterParams*)params
{
    self.SpO2Value = params.SpO2Value;
    self.pulseRateValue = params.pulseRateValue;
    self.piValue = params.piValue;
    NSLog(@"---%lu %lu %lu", (unsigned long)_SpO2Value,(unsigned long)_pulseRateValue,(unsigned long)_piValue);
    
    [lbSpO2Value setText:[NSString stringWithFormat:@"%ld％",(unsigned long)_SpO2Value]];
    [lbPulseRateValue setText:[NSString stringWithFormat:@"%ld",(unsigned long)_pulseRateValue]];
}

@end
