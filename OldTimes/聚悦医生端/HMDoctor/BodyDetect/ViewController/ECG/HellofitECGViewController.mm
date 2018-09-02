//
//  HellofitECGViewController.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HellofitECGViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "JYBluetoothManager.h"
#import "HellofitECGBLEDevice.h"

#import "LeadPlayer.h"
#import "CustomProgressView.h"
#import "HFdiagnoseAlgorithm.h"
#import "BodyDetectSysConvertUtil.h"

@interface HellofitECGViewController ()<ECGBluetoothControlResultDelegate,JYBluetoothManagerDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    HellofitECGBLEDevice *bleControl;
    
    LeadPlayer *drawECGView;
    CustomProgressView *progressView;
    UIButton *measureButton;
    
    BOOL isResult;
}
@property (nonatomic, copy) NSArray *resultArray;
@property (nonatomic, copy) NSMutableArray *bitmapArray;
@property (nonatomic,strong) UIImageView *deviceImageView;
@property (nonatomic, assign) BOOL isCollect;  //是否收集数据
@end

@implementation HellofitECGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self initWithHomePage];
    bleControl = [[HellofitECGBLEDevice alloc] initWithDelegate:self];
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

#pragma mark -- Method
- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XDY_HLF"];
}

#pragma mark -- init
- (void)initWithHomePage
{
    homePageView = [[BloodPressureDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"xinlv_shenti_body"];
    [homePageView.startButton setHidden:YES];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (void)initWithDetectSubViews
{
    [homePageView removeFromSuperview];

    drawECGView = [[LeadPlayer alloc] init];
    [self.view addSubview:drawECGView];
    self.isStart = NO;
    self.isStop = NO;
    
    [drawECGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.height/3);
    }];
    
    progressView = [[CustomProgressView alloc] init];
    progressView.backgroundColor = [UIColor mainThemeColor];
    [self.view addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(drawECGView.mas_bottom);
        make.height.mas_equalTo(2);
    }];
    
    _deviceImageView = [[UIImageView alloc] init];
    [self.view addSubview:_deviceImageView];
    [_deviceImageView setImage:[UIImage imageNamed:@"xinlv_shenti_body"]];
    
    measureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [measureButton.layer setMasksToBounds:YES];
    [measureButton.layer setCornerRadius:5.0];
    [measureButton.layer setBorderWidth:1.0f];
    [measureButton.layer setBorderColor:[UIColor commonGrayTextColor].CGColor];
    [measureButton setTitle:@"设备正在握手连接" forState:UIControlStateNormal];
    [measureButton.titleLabel setFont: [UIFont font_30]];
    [measureButton setEnabled:NO];
    [measureButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
    [self.view addSubview:measureButton];

    [measureButton addTarget:self action:@selector(detectBtnStart:) forControlEvents:UIControlEventTouchUpInside];

    [measureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-55);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(45);
    }];
    
    [_deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawECGView.mas_bottom).with.offset(8);
        make.bottom.equalTo(measureButton.mas_top).with.offset(5);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(DeviceHomePageImg_Width);
        make.height.mas_lessThanOrEqualTo(DeviceHomePageImg_Height);
    }];

}


#pragma mark -- Private Method
- (void)detectBtnStart:(UIButton *)sender
{
    [measureButton.layer setBorderWidth:0.0f];
    [measureButton setTitle:@"开始采集" forState:UIControlStateNormal];
    [measureButton setBackgroundColor:[UIColor mainThemeColor]];
    [measureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //请求发送数据
    [bleControl writeDate:[BodyDetectSysConvertUtil dataByteHexString:@"FF0403010000"]];

    [sender removeTarget:self action:@selector(detectBtnStart:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//开始采集数据
- (void)collectBtnClick:(UIButton *)sender
{
    [measureButton setEnabled:NO];
    [measureButton setTitle:@"采集中……" forState:UIControlStateNormal];
    [measureButton setBackgroundColor:[UIColor commonGrayTextColor]];
    _isCollect = YES;
    
    if (!kArrayIsEmpty(_ecgData))
    {
        [_ecgData removeAllObjects];
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeProgressStart:) userInfo:nil repeats:YES];
    });
}

//握手成功
- (void)phone_hellofit_handshake
{
    [measureButton setEnabled:YES];
    [measureButton setTitle:@"开始测量" forState:UIControlStateNormal];
    [measureButton.layer setBorderColor:[UIColor mainThemeColor].CGColor];
    [measureButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
}

- (void)measureECGStop
{
    self.isStop = YES;
}

-(void)measureECGSuccessWithPoints
{
    self.isStop = NO;
    [drawECGView.pointsArray addObjectsFromArray:_ecgData];
    [drawECGView fireDrawing];
}

//测量30s
-(void)changeProgressStart:(NSTimer *)timer
{
    if (!_isStop)
    {
        progressView.progress += 0.001;
        
    }
    if (progressView.progress >= 1.0)
    {
        [timer invalidate];
        
        //测量完成
        [self stopSendECGData];
    }
}

-(void)stopSendECGData
{
    isResult = YES;
    
    [measureButton setTitle:@"采集完成" forState:UIControlStateNormal];
    //停止发送数据
    [bleControl writeDate:[BodyDetectSysConvertUtil dataByteHexString:@"FF0403000000"]];
    
    HFdiagnoseAlgorithm *demo = [[HFdiagnoseAlgorithm alloc]init];
    int HfData[_ecgData.count];
    for (int i = 0; i<_ecgData.count; i++)
    {
        HfData[i] = [_ecgData[i] intValue];
    }
    NSData *data1 = [[NSData alloc]init];
    NSData *data2 = [[NSData alloc]init];
    NSData *data3 = [[NSData alloc]init];
    
    data1 = [NSData dataWithBytes:HfData length:sizeof(HfData)];
    
    int res = [demo diagnoseAlgorithm:data1 withecgInfo:&data2 withdiseaseInfo:&data3];
    
    int *rate;
    if (res)
    {
        rate = (int *)[data2 bytes];
//        int len_rate = (int)data2.length / 4;
        
//        NSLog(@"返回的ECG信息数据长度%d：",len_rate);
//        NSLog(@"输入数据心率为：%d",rate[0]);
//        NSLog(@"RR间期/ms：%d",rate[1]);
//        NSLog(@"QRS宽度/ms：%d",rate[2]);
        
        if (!_resultArray) {
            _resultArray = [[NSArray alloc] init];
        }
        _resultArray = [self diseaseLog:data3];
        
        //诊断结束，清除内存
        [demo clearMemory];
    }else
    {
        //诊断结束，清除内存
        [demo clearMemory];
        
        [self showAlertMessage:@"数据干扰太大，无法分析，请重新测量！" clicked:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        return;
    }

    
    NSString *symptom = [_resultArray componentsJoinedByString:@"|"];
    
    NSString *bitmap = [_ecgData componentsJoinedByString:@","];
    
    if (!_bitmapArray)
    {
        _bitmapArray = [[NSMutableArray alloc] init];
    }
    [_bitmapArray addObject:bitmap];
    
    //上传数据
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
    
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[0]] forKey:@"XL_OF_XD"];
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[1]] forKey:@"RR"];
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[2]] forKey:@"QRS"];
    [dicValue setValue:_bitmapArray forKey:@"BITMAP"];
    [dicValue setValue:[NSString stringWithFormat:@"125"] forKey:@"rate"];
    
    NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
    [dicDetectResult setValue:@"XD" forKey:@"kpiCode"];
    [dicDetectResult setValue:dicValue forKey:@"testValue"];
    [dicDetectResult setValue:symptom forKey:@"symptom"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [self postDetectResult:dicDetectResult];
    
}

- (NSMutableArray *)diseaseLog:(NSData *)dis
{
    NSMutableArray *diseaseArray = [[NSMutableArray alloc] init];
    
    int *disease = (int *)[dis bytes];
    int len_disease = (int)dis.length / 4;
    
    for (int i = 0; i < len_disease; i++)
    {
        if ( disease[i] != -1 )
        {
            switch (i)
            {
                case 0:
                    [diseaseArray addObject:@"单发室性早搏"];
                    break;
                    
                case 1:
                    [diseaseArray addObject:@"成对室性早搏"];
                    break;
                    
                case 2:
                    [diseaseArray addObject:@"加速性室性逸搏心律"];
                    break;
                    
                case 3:
                    [diseaseArray addObject:@"室性心动过速"];
                    break;
                    
                case 4:
                    [diseaseArray addObject:@"室性二联律"];
                    break;
                    
                case 5:
                    [diseaseArray addObject:@"室性三联律"];
                    break;
                    
                case 6:
                    [diseaseArray addObject:@"单发室上性早搏"];
                    break;
                    
                case 7:
                    [diseaseArray addObject:@"成对室上性早搏"];
                    break;
                    
                case 8:
                    [diseaseArray addObject:@"加速性室上性逸搏心律"];
                    break;
                    
                case 9:
                    [diseaseArray addObject:@"室上性心动过速"];
                    break;
                    
                case 10:
                    [diseaseArray addObject:@"室上性二联律"];
                    break;
                    
                case 11:
                    [diseaseArray addObject:@"室上性三联律"];
                    break;
                    
                case 12:
                    [diseaseArray addObject:@"长间期"];
                    break;
                    
                case 13:
                    [diseaseArray addObject:@"窦性心动过速"];
                    break;
                    
                case 14:
                    [diseaseArray addObject:@"窦性心动过缓"];
                    break;
                    
                case 15:
                    [diseaseArray addObject:@"窦性心率不齐"];
                    break;
                    
                default:
                    break;
            }
        }
    }
    if (0 == diseaseArray.count)
    {
        [diseaseArray addObject:@"心电正常"];
    }
    return diseaseArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- ECGBluetoothControlResultDelegate
//解析数据
- (void)measureECGSuccessWithDecodeData:(NSData *)valueData
{
    NSData* headerData = [valueData subdataWithRange:NSMakeRange(1, 3)];
    NSString* headerDataString = [headerData hexString];
    
    if ([headerDataString isEqualToString:@"FF0001"])
    {
        NSLog(@"设备握手成功");
        [self phone_hellofit_handshake];
    }
    
    Byte *bytes = (Byte *)valueData.bytes;
    
    int dataLen = bytes[0]& 0xFF;
    if (dataLen == 19)
    {
        int sensorState = bytes[dataLen-6]&0xFF;
        if (sensorState == 200)
        {
            //接触
            //NSLog(@"%@",valueData);
            int ecgDataEndPos = dataLen - 6;
            if (!_ecgData)
            {
                _ecgData = [[NSMutableArray alloc] init];
            }
            for (int i = 1; i<ecgDataEndPos; i=i+2)
            {
                int valueInt = [self signedWithValue:(bytes[i+1]&0xFF)+((bytes[i]&0xFF)<<8) length:16];
                
                //四舍五入为最近的整数
                [_ecgData addObject:[NSNumber numberWithInt:-round(valueInt*0.143f)]];
            }
            
            [self measureECGSuccessWithPoints];
        }
        if (sensorState==0)
        {
            [self measureECGStop];
        }
    }
    
}

-(int)signedWithValue:(int)value length:(int)length
{
    if ((value &1<<(length-1))!=0)
    {
        value = -1 * ((1 << (length - 1)) - (value & (1 << (length - 1)) - 1));
    }
    return value;
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
            [homePageView startBluetoothConnectAnimationPlay];
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
    [self initWithDetectSubViews];
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
    [measureButton setBackgroundColor:[UIColor commonGrayTextColor]];
    [measureButton setEnabled:NO];
    
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

@end
